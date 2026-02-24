# CLAUDE.md

## Purpose
This file gives agents clear, repo‑specific guidance for developing and testing this iOS app. Follow these instructions when reading, modifying, or adding code anywhere in the repository.

## Test & Validate

### Xcode MCP (preferred)
- If the Xcode MCP server is available and connected, use it to build and run tests.
- Use `BuildProject` to build, `RunAllTests` to run the full unit test suite, and `RunSomeTests` for targeted tests.
- Use `GetBuildLog` and `XcodeListNavigatorIssues` to inspect build errors and warnings.

### Fastlane (fallback)
- If Xcode MCP is not available, fall back to Fastlane via Bundler: `bundle exec fastlane ios <lane>`.
- Run `fastlane ios test` after changing non‑UI code (models, view models, services, utilities, business logic).
- Run `fastlane ios test_ui` only when you change UI flows or code that affects UI behavior. Note:
  - UI tests may take 8+ minutes to complete.
  - Intermittent flakiness is known; failures are not always related to your change.
- Output locations: unit tests write to `test-output/`; UI tests write to `test-ui-output/`. Inspect these artifacts when diagnosing failures.

### Local Swift packages
- The app depends on several Swift packages that are embedded locally (e.g. `ProjectInterShared`). Their tests are **not** included in the Xcode test plan or Fastlane lanes.
- When making changes to a local Swift package, run its tests directly: `cd <package-directory> && swift test`.

### General
- If unit or UI tests fail or are unstable in a way you cannot explain, stop and ask the user to intervene before proceeding.

## UI Test Server (local)
- UI tests in CI start a mock backend (`project-inter-mock-server`). To reproduce locally:
  - Clone the server repo: `git clone https://github.com/brendan-ch/project-inter-mock-server`
  - `cd project-inter-mock-server && npm install && npm run dev`
  - In another terminal, run the UI tests with `bundle exec fastlane ios test_ui`.

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
- `fastlane/` — Lanes for tests and distribution.

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
- For flaky UI tests, capture artifacts from `test-ui-output/` and ask for guidance before disabling tests.

## Git & Commit Conventions
- Use Conventional Commits for messages:
  - `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`
- Branch naming: `feat/<short-name>`, `fix/<short-name>`, `chore/<short-name>`, `docs/<short-name>`.

## Code Signing & CI
- Fastlane lanes use `match` for code signing. Do not change signing settings without confirmation.
- Local runs may require credentials; in CI, secrets provide `MATCH_*` values. If signing fails, stop and ask the user.
- CI relies on paths `test-output/` and `test-ui-output/` and `fastlane` lanes; avoid moving these without updating workflows.

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
- Tests: note which lanes you ran locally (`fastlane ios test`, and when relevant `fastlane ios test_ui`) and any flakiness observed.
- Artifacts: if UI-related, include screenshots or a short screen recording.

### PR Checklist
- [ ] Runs `bundle exec fastlane ios test` clean locally.
- [ ] UI changes validated; ran `bundle exec fastlane ios test_ui` if flows impacted (optional due to runtime).
- [ ] Updated GraphQL types via `./apollo-ios-cli generate` if schema/operations changed and committed outputs.
- [ ] Logging uses `ProjectInterLogging` (no stray `print`).
- [ ] No unintended signing/CI config changes.
