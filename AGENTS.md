# AGENTS.md

## Purpose
This file gives agents clear, repo‑specific guidance for developing and testing this macOS app. Follow these instructions when reading, modifying, or adding code anywhere in the repository.

## Test & Validate (Fastlane)
- Run `fastlane test` after changing non‑UI code (models, view models, services, utilities, business logic).
- Run `fastlane test_ui` only when you change UI flows or code that affects UI behavior. Note:
  - UI tests may take 8+ minutes to complete.
  - Intermittent flakiness is known; failures are not always related to your change.
- If unit or UI tests fail or are unstable in a way you cannot explain, stop and ask the user to intervene before proceeding.

## UI & Platform Guidelines
- This is a macOS app built primarily with SwiftUI.
- Design UI to be idiomatic for macOS and follow Apple Human Interface Guidelines (HIG).
- Prefer SwiftUI for all new UI. Use AppKit only when functionality is unavailable in SwiftUI.
- When AppKit is required, bridge using `NSViewRepresentable` (or `NSViewControllerRepresentable` as appropriate) with minimal surface area.
- Use SF Symbols for iconography.

## Frameworks & APIs
- Target the latest macOS version; there are no backward‑compatibility constraints.
- Prefer the most modern macOS and Swift APIs available.
- Avoid introducing legacy or deprecated APIs unless absolutely necessary and explicitly justified.

## Development Practices for Agents
- Keep changes focused and minimal; avoid unrelated refactors.
- Prefer small, composable SwiftUI views with clear data flow.
- Ensure model and business logic are well‑covered by unit tests (`fastlane test`).
- Be cautious with UI test runs (`fastlane test_ui`) due to runtime and flakiness; run them only when relevant.
- If you encounter unclear requirements, flaky tests, or API limitations, pause and ask the user for guidance.

## When to Ask the User
- Any failing or flaky unit/UI tests you cannot attribute to your changes.
- Decisions requiring non‑SwiftUI AppKit workarounds or platform trade‑offs.
- Significant design choices that impact macOS UX patterns or HIG compliance.

