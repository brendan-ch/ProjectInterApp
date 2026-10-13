# CLAUDE.md

## Purpose
This file gives agents clear, repo‑specific guidance for developing and testing this iOS app. Follow these instructions when reading, modifying, or adding code anywhere in the repository.

## Test & Validate

### Xcode MCP (preferred)
- If the Xcode MCP server is available and connected, use it to build and run unit tests.
- Always call `XcodeListWindows` first to get the `tabIdentifier` required by most tools.

**Full tool reference:**

| Tool | Purpose |
|------|---------|
| `XcodeListWindows` | List open Xcode windows and get `tabIdentifier` values (required by most tools) |
| `BuildProject` | Build the project and wait for completion |
| `GetBuildLog` | Retrieve the build log to diagnose compilation errors |
| `XcodeListNavigatorIssues` | List errors and warnings shown in Xcode's Issue Navigator |
| `XcodeRefreshCodeIssuesInFile` | Refresh code diagnostics (errors/warnings) for a specific file |
| `RunAllTests` | Run all tests in the active test plan |
| `RunSomeTests` | Run a specific subset of tests by identifier |
| `GetTestList` | List all available tests in the active test plan |
| `RenderPreview` | Render a SwiftUI `#Preview` macro and return a screenshot |
| `ExecuteSnippet` | Execute a Swift code snippet in the context of the project |
| `DocumentationSearch` | Search Apple developer documentation |
| `XcodeRead` | Read a file through Xcode (use standard `Read` tool instead for most cases) |
| `XcodeWrite` | Write/create a file through Xcode |
| `XcodeUpdate` | Update (edit) file contents through Xcode |
| `XcodeLS` | List directory contents through Xcode |
| `XcodeGlob` | Glob-pattern file search through Xcode |
| `XcodeGrep` | Regex content search through Xcode |
| `XcodeMakeDir` | Create a directory through Xcode |
| `XcodeMV` | Move or rename a file/directory through Xcode |
| `XcodeRM` | Delete a file or directory through Xcode |

- **UI tests** cannot be run via Xcode MCP (the active test plan cannot be switched). Use `xcodebuild` instead:
  ```
  xcodebuild test \
    -project ProjectInter.xcodeproj \
    -scheme ProjectInter \
    -testPlan ProjectInterUITests \
    -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.5'
  ```
  - Adjust the `-destination` to match an available simulator (run `xcodebuild -showdestinations -scheme ProjectInter` to list them).
  - The mock server must be running before starting UI tests (see **UI Test Server** below).

### xcodebuild (fallback)
- If Xcode MCP is not available, use `xcodebuild` for test plans and plain Xcode builds.
- Run the unit test plan after changing non‑UI code (models, view models, services, utilities, business logic):
  ```
  xcodebuild test -project ProjectInter.xcodeproj -scheme ProjectInter -testPlan ProjectInterTests -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -xcconfig Config/CI.xcconfig
  ```
- Run the UI test plan only when you change UI flows or code that affects UI behavior:
  ```
  xcodebuild test -project ProjectInter.xcodeproj -scheme ProjectInter -testPlan ProjectInterUITests -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -xcconfig Config/CI.xcconfig
  ```
- Note: UI tests may take 8+ minutes to complete; intermittent flakiness is known; failures are not always related to your change.
- `Config/CI.xcconfig` disables code signing, which is fine for simulator-only test runs.
- Adjust the `-destination` to match an available simulator (run `xcodebuild -showdestinations -scheme ProjectInter` to list them).
- Test results land in the `.xcresult` bundle passed via `-resultBundlePath`. Inspect this artifact when diagnosing failures.

### Local Swift packages
- The app depends on several Swift packages that are embedded locally (e.g. `ProjectInterShared`). Their tests are **not** included in the Xcode test plan.
- When making changes to a local Swift package, run its tests directly: `cd <package-directory> && swift test`.

### Validation order
1. Build the project.
2. Run unit tests (Xcode MCP `RunAllTests` or the `xcodebuild` unit-test fallback above).
3. Run local Swift package tests if packages were changed (`cd <package-directory> && swift test`).
4. **Run UI tests last** — they take the longest, and require the mock server running first.

### General
- If unit or UI tests fail or are unstable in a way you cannot explain, stop and ask the user to intervene before proceeding.

## UI Test Server (local)
- UI tests require a mock backend running locally. To set it up:
  1. If the server repo doesn't exist, clone it alongside this repo:
     ```
     cd .. && git clone https://github.com/brendan-ch/project-inter-monitoring-server.git
     ```
  2. Install dependencies and start the server **in the background**:
     ```
     cd ../project-inter-mock-server && npm install && npm run dev
     ```
  3. The server runs on port 4000. Ensure it is running before starting UI tests.

## UI & Platform Guidelines
- The app is built primarily with SwiftUI.
- Prefer SwiftUI for all new UI. Use platform frameworks only when functionality is unavailable in SwiftUI.
- If building for macOS, bridge using `NSViewRepresentable` / `NSViewControllerRepresentable` as appropriate.
- If building for iOS, bridge using `UIViewRepresentable` / `UIViewControllerRepresentable` as appropriate.
- Design UI to be idiomatic for the platform and follow Apple Human Interface Guidelines (HIG).
- Use SF Symbols for iconography.

## Frameworks & APIs
- Target the latest OS version, with backwards compatibility going back to iOS 18.
- Prefer the most modern Swift and platform APIs available (Swift Concurrency over legacy patterns where possible).
- Avoid introducing legacy or deprecated APIs unless absolutely necessary and explicitly justified.

## Development Practices for Agents
- Keep changes focused and minimal; avoid unrelated refactors.
- Prefer small, composable SwiftUI views with clear data flow.
- Ensure model and business logic are well‑covered by unit tests.
- Be cautious with UI test runs due to runtime and flakiness; run them only when relevant.
- If you encounter unclear requirements, flaky tests, or API limitations, pause and ask the user for guidance.

## When to Ask the User
- Any failing or flaky unit/UI tests you cannot attribute to your changes.
- Decisions requiring non‑SwiftUI AppKit workarounds or platform trade‑offs.
- Significant design choices that impact iOS UX patterns or HIG compliance.

## Repository Layout
- `ProjectInter/` — App target (SwiftUI views, view models, models, singletons).
- `ProjectInterOperations/` — Apollo GraphQL generated Swift package (schema + operations + test mocks).
- `ProjectInterLogging/` — Swift package wrapping `os.Logger` categories.
- `ProjectInterTests/` — Unit tests; see `ProjectInterTests.xctestplan`.
- `ProjectInterUITests/` — UI tests; see `ProjectInterUITests.xctestplan`.
- `Config/` — Project-level xcconfigs (`Shared.xcconfig` base settings + out-of-repo team include, `CI.xcconfig` for signing-free simulator CI).

## GraphQL / Apollo Codegen
- The repo includes the Apollo iOS CLI (`./apollo-ios-cli`) and `apollo-codegen-config.json`.
- After editing any `.graphql`/`.graphqls` files or changing GraphQL operations, regenerate types:
  - `./apollo-ios-cli generate`
  - Commit resulting changes under `ProjectInterOperations/` (including test mocks).
- Use generated types and operations from `ProjectInterOperations` in app code; avoid handwritten query strings.

## Logging
- Use structured logging via `ProjectInterLogging`:
  - `Loggers.shared.networkingLogger` for network events
  - `Loggers.shared.systemEventsLogger` for app/system lifecycle
  - `Loggers.shared.globalStateEventsLogger` for selection/state changes
- Avoid `print` in production code. Choose appropriate levels: `debug`, `info`, `notice`, `warning`, `error`.
- Optional: set `LogSubsystem` in Info.plist to override the default subsystem used by `os.Logger`.

## State & Concurrency
- Prefer Swift Concurrency (`async/await`, `@MainActor`) for async work.
- Use SwiftUI environment injection (e.g., `.environment(...)`) for app‑wide models; keep view models lightweight.
- Only use singletons already established in the codebase (e.g., `ApolloNetworkModelSingleton`, `ApolloClientHolderSingleton`) for shared infra; otherwise favor DI to keep code testable.

## Testing Conventions
- Mirror app structure in `ProjectInterTests/` for unit tests and in `ProjectInterUITests/` for UI flows.
- Use existing test plans; avoid renaming them unless coordinated (`ProjectInterTests.xctestplan`, `ProjectInterUITests.xctestplan`).
- Add unit tests for view models, models, and pure logic. Add UI tests only for critical flows.
- For flaky UI tests, capture the `.xcresult` artifact (`-resultBundlePath`) and ask for guidance before disabling tests.

## Git & Commit Conventions
- Use Conventional Commits for messages:
  - `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`
- Branch naming: `feat/<short-name>`, `fix/<short-name>`, `chore/<short-name>`, `docs/<short-name>`.

## Code Signing & CI
- Signing is automatic everywhere (Xcode cloud-signing). The development team comes from `../SharedXcodeSettings/DeveloperSettings.xcconfig` (outside the repo) via `Config/Shared.xcconfig`; see `Config/DeveloperSettings.sample.xcconfig` for setup.
- CI simulator tests pass `-xcconfig Config/CI.xcconfig`, which disables signing entirely — no Apple credentials or certificates are needed in CI.
- TestFlight delivery happens through Xcode Cloud (App Store Connect); GitHub Actions handles PR tests and version-bump PRs only.
- CI relies on `.xcresult` artifacts under `output/` and the `Config/` xcconfigs; avoid moving these without updating workflows.

## Commit Style

For each commit message, use a short message describing the change. Call out specific file names. Capitalize the commit message and use the description when the name becomes too long.

## Pull Request Style
- Title: short, Conventional Commit type + concise scope (e.g., `chore/create-logging-module`).
- Labels: apply a primary type label (`chore`, `feat`, `fix`, etc.). Do not apply `bypass ci/cd` unless explicitly requested.
- Body:
  - 1–3 sentence summary of what and why.
  - Link issues with closing keywords (e.g., `Closes #123`).
  - Call out notable architectural changes or new dependencies.
- Scope: keep PRs focused and reviewable; avoid unrelated refactors.
- Tests: note which test plans you ran locally (`xcodebuild test -testPlan ProjectInterTests`, and when relevant `ProjectInterUITests`) and any flakiness observed.
- Artifacts: if UI-related, include screenshots or a short screen recording.

### PR Checklist
- [ ] Runs the unit test plan clean locally (`xcodebuild test -testPlan ProjectInterTests ...`).
- [ ] UI changes validated; ran the UI test plan if flows impacted (optional due to runtime).
- [ ] Updated GraphQL types via `./apollo-ios-cli generate` if schema/operations changed and committed outputs.
- [ ] Logging uses `ProjectInterLogging` (no stray `print`).
- [ ] No unintended signing/CI config changes.
