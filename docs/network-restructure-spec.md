# Spec — Network-layer restructure (Apollo 2.4 flattening)

Status: approved decisions recorded; implementation pending.
Branch context: `chore/apollo-updates` (mid Apollo 2.0 → 2.4 migration; main app + widget schemes build at time of writing; unit-test target intentionally broken, its files are rewritten by this change).

## Decisions register (all confirmed)

| # | Decision |
|---|---|
| D1 | `ApolloNetworkModel`, `MockApolloClient`, and the auto-test protocol mechanism are **deleted entirely**. Tests never construct a client; they inject `Result`s through the view models. |
| D2 | Query construction: `convertNetworkArgumentsIntoQuery` becomes **static**, instance state removed from it. `refreshDataOnce` is removed; repeated fetch-once orchestration at call sites is explicitly accepted. |
| D3 | Mutations: `client.perform` calls move into `ShuttleInfoContentView`; `generateNotificationInput` becomes static. `NotificationSchedulingModel` is dissolved. Its 4 network tests are pruned. |
| D4 | `Refreshable` and `GraphQLQueryConvertible` protocols are **deleted**. `GraphQLQueryable` dissolves (its only survivor, `processRefreshDataResult`, stays via `GraphQLProcessable`). |
| D5 | **Loading state moves out of the view models entirely** into each view / `NetworkView`. The stream-consumption loop and the owning task also live in the view. Therefore `injectUpdateStream` **retires** (supersedes the original note "task stored in dataRefreshLoopTask" — no `dataRefreshLoopTask` exists anymore). The model API is data-only. |
| D6 | Loading-state transitions become per-result in the view: `.success → .succeeded`, `.failure → .failed`, `.initializing` at restart. Intended behavior change: transient poll failures now recover on the next successful poll (today the state latches "failed" until restart). |
| D7 | `convertNetworkArgumentsIntoQuery` returns **non-optional** once `NetworkArguments` exist (`nil`-return cases came from optional arguments; views guard on `networkArguments != nil` instead). |
| D8 | Server URL changes: a running stream keeps polling the old URL until the app restarts — **accepted known limitation** (temporary, the "accept staleness" option). `ApolloClient.shared` remains a computed property so new clients read the latest `URL.apiBaseUrl`. |
| D9 | Early guard for double-restart lives in the `NetworkView` default impl (`stopDataUpdates()` before starting a new task) — no stream is ever created without a consumer. |
| D10 | Deprecated Apollo 1.x callback shims do not survive this change: queries via 2.4 async `fetch`, mutations via 2.4 async `perform(mutation:requestConfiguration:)`. The rewritten `ApolloClientProtocol.swift` shim file from the enumeration pass is deleted. |

## Target architecture

### `ApolloClient` extension (ProjectInterShared, `ApolloClient.swift`)
```swift
public extension ApolloClient {
    static var shared: ApolloClient { ApolloClient(url: .apiBaseUrl) }   // stays computed (D8)

    /// Polling stream: fetch → yield → sleep, until the consuming task is cancelled.
    func getStream<Query: GraphQLQuery>(
        _ query: Query,
        sleepDuration: Duration = .seconds(5)
    ) -> AsyncStream<Result<Query.Data, any Error>>
}
```
- Loop uses the modern single-response async fetch; yields `.success(response.data)` / `.failure(error)`; `onTermination` implementation detail — loop cancels cleanly when the stream is consumed by a cancelled task.
- Not unit-tested (D1 / "minimal orchestration" note).
- `GraphQLConstructable.getGraphQLResult` becomes a one-liner over the same async fetch (resolves the old duplication TODO), returning `GraphQLResponse<Query>`.

### `NetworkDataModel` (view-model base class)
- Generic params unchanged: `<NetworkArguments, GraphQLQueryType: GraphQLQuery>`.
- `InitializationState` and all loading-state members are **removed** (moved view-side). `dataInitState`, `setDataInitState`, `resetDataInitState`, `startRefreshingData`, `refreshDataOnce`, `injectUpdateStream`, `apolloNetworkModel`, `dataRefreshLoopTask`: all deleted.
- Constructor: plain `required init()`.
- Public API:
  ```swift
  @MainActor func injectUpdate(_ result: Result<GraphQLQueryType.Data, any Error>)
  func processRefreshDataResult(_ result: Result<GraphQLQueryType.Data, any Error>)   // subclass hook (GraphQLProcessable)
  static func convertNetworkArgumentsIntoQuery(_ arguments: NetworkArguments) -> GraphQLQueryType   // D7
  ```
- Subclasses' `clearData()` drops `resetDataInitState()`; keeps data clearing.
- `PlaceholderBuildable` requirement `init(dataInitState:)` is dropped; placeholders construct via `init()` and set data. (All current placeholders use the `.succeeded` path only.)
- `MapView.ViewModel.hasReceivedInitialData` / position reset logic stays in the model (data-processing concern).
- Wrinkle handled: `ShuttleInfoContentView.ViewModel.convertNetworkArgumentsIntoQuery` currently stores `self.stopId` as a side effect. With static conversion, `stopId` becomes a settable property the **view** assigns from its `networkArguments` before starting updates (tests set it directly).
- Wrinkle handled: `ParkingStructureInfoContentView.ViewModel` conversion depends on `oneWeekAgo`/`calendar`. Static signature gains `referenceDate: Date` (view passes `.now`); `generateHistoricalAverageInput` also becomes static.

### `NetworkView` (views own networking + loading state)
```swift
protocol NetworkView: View {
    associatedtype NetworkArguments
    associatedtype ViewModelType: GraphQLProcessable & Clearable

    var dataInitState: InitializationState { get set }     // satisfied by @State
    var updateTask: Task<Void, Error>? { get set }         // satisfied by @State
    var viewModel: ViewModelType { get }
    var networkArguments: NetworkArguments? { get }
}

extension NetworkView {
    func restartDataUpdates() {
        stopDataUpdates()                                  // D9: no orphaned streams
        guard let networkArguments else { return }
        dataInitState = .initializing
        let query = ViewModelType.convertNetworkArgumentsIntoQuery(networkArguments)   // static (D2)
        let stream = ApolloClient.shared.getStream(query)
        updateTask = Task {
            for await result in stream {
                dataInitState = (try? result.get()) != nil ? .succeeded : .failed    // D6
                await viewModel.injectUpdate(result)
            }
        }
    }
    func stopDataUpdates() {
        updateTask?.cancel()
        updateTask = nil
    }
}
```
- `globalSystemsModel` drops from the protocol (existed only to fetch `apolloNetworkModel`).
- Each view: `@State private var dataInitState: InitializationState = .notInitialized`, `@State private var updateTask: Task<Void, Error>?`; `WithInitializationView(dataInitState:)` now binds the view-local state.
- `RouteInfoContentView` auto-select-on-load observes **its own** `.onChange(of: dataInitState)`.
- `ShuttleInfoContentView`: heading text passes to a simplified `etaDisplay` ("ETA currently not available" constant when data absent; loses the `.initializing`-empty-string special case — accepted).
- `InitializationState` enum relocates to the view domain (e.g. beside `WithInitializationView`).

### Fetch-once call sites (repeated 3-line pattern, accepted)
Query → `try? await ApolloClient.shared.fetch(query:)` → `guard let data = response.data` → `injectUpdate(.success(data))` /  `.failure`:
- `ProjectInterApp`: welcome `refreshDataOnce` (systems), `ContentViewWrapper` `.task` systems + selection-change stops, schema-version stream (via `getStream`, 300s — starts with view-less equivalent wiring in the app struct)
- `StopSelectionView` (stops)
- `GlobalIdSelectionModel.autoSelectRouteIdFromShuttleId` (static `RouteIdSelectionSyncModel.convertNetworkArgumentsIntoQuery`, fetch, `injectUpdate`, read back `routeId`)
- `ParkingStructureInfoContentView` current-day historical: static query with `referenceDate` → fetch → pure extracted `processCurrentDayAverages(_:)` on the view model (testable without a client)

### `NotificationSchedulingModel` dissolution (D3)
- `generateNotificationInput` → `static` on `ShuttleInfoContentView`.
- View performs both mutations directly:
  ```swift
  let response = try await ApolloClient.shared.perform(mutation: ScheduleNotificationMutation(input: generateNotificationInput(args)))
  guard response.data?.scheduleNotification.success == true else { /* handle */ }
  ```
  Same shape for cancel. Delete `NotificationSchedulingFailedError`, `NotificationInfo`, `@State notificationSchedulingState`, `setApolloClientOnNotificationSchedulingModel()`.
- Note: today the view already `catch { print(error) }`es these calls; keep equivalent minimal handling.

### `ServerUrlConfigurationModel`
- Loses the `apolloNetworkModel` dependency entirely (constructor trims; no `reconfigure`). Persists URL + bumps `urlVersion`; no other changes. Tests keep behavioral assertions, fixture drops the model.

### Files lifecycle
**Create:** `ApolloClient.getStream` extension content; `NetworkDataModelTests`; static converters.
**Delete:** `ApolloNetworkModel.swift`, `ApolloNetworkModelTests.swift`, `NetworkDataModelTestsProtocol.swift`, `ProjectInterShared/.../Mocks/MockApolloClient.swift`, `ShuttleInfoContentView+NotificationSchedulingModel.swift` (contents relocated), `Refreshable.swift`, `GraphQLQueryConvertible.swift`, `GraphQLQueryable.swift`, rewritten `ApolloClientProtocol.swift` shim file, `GlobalStopsModel`'s duplicate `dataRefreshLoopTask`.
**Move/edit:** `InitializationState` location, `Replacing` per-view content per above.

### Known limitations / behavior changes (accepted)
1. Stale stream URL until app restart after a server-URL change (D8).
2. Loading state: per-result recovery (D6) — outward-visible change from the latch behavior.
3. Shuttle heading shows "ETA currently not available" during initial load instead of "" (minor).
4. All Apollo data construction from test mocks requires `await Data.from(mock)` (2.4 API).

## Test inventory (final shape)

**Prune:**
- `ApolloNetworkModelTests` (4 tests) — class deleted.
- `NetworkDataModelTestsProtocol.swift` + 42 reciprocal wrapper tests across 7 conforming suites.
- 4 `ShuttleInfoContentViewNotificationSchedulingModelTests` network tests (D3) — file deleted; optionally add a pure `generateNotificationInput` test.
- Redundant rewrites: Map partial-data ×2, RouteInfo no-shuttles, Shuttle `availableNotificationOptions` ×3 (keep 1 pure + 1 boundary), GlobalSystems empty-mock, all `refreshDataOnceDoesNothing…` fetch-path tests.

**Keep (pure; mostly untouched):** `RouteListContentViewRoute` logic tests, Apollo-initializer tests (MapView/Stop/Shuttle/ETA/ParkingStructure), `asMKCoordinateRegion`, closest-stop selection, `findAverageCorrespondingToDate`, `ServerUrlConfigurationModelTests` (fixture trim), `viewModelCorrectlyGeneratesHistoricalAverageInput` (updated to static call).

**Add:**
- `NetworkDataModelTests` (spy subclass): `injectUpdate(.success)` routes to `processRefreshDataResult`; `injectUpdate(.failure)` leaves data untouched, no crash. (Loading-state tests deliberately dropped — state is untestable view-side.)
- Per-conformer rewrites around `injectUpdate`: GlobalSystems (systems mapping, initialRegion mapping, nil-initialRegion), GlobalStops (refresh+sort), SchemaVersion (2× `isCompatible`), RouteList (`loadedRoutesAreSorted`, inactive-routes), RouteInfo (`sortsShuttlesBySecondsRemaining`), Shuttle (under-1-min ETA, condensed notification options), Map (position reset on first load ×2 via two injections, ordered-stop `routeIds`), ParkingStructuresList (`structuresSupportedBySystem`), ParkingStructureInfo (4 `parkingInsight` + `processCurrentDayAverages`).
- Mechanism: injectable `Result` payloads built from `ApolloTestSupport.Mock` (`.Data.from(mock)` → `await`).
