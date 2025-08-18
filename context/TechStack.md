# Tech Stack & Architecture

## Core Technologies
- SwiftUI for UI layer
- MVVM architecture (lean implementation)
- Modern Swift concurrency (async/await)
- Combine for reactive data flow
- Swift Package Manager for dependencies

## Architecture Decisions
- Lean MVVM: ViewModels handle minimal business logic
- Views are dumb and purely declarative
- Async/await for all network and heavy operations
- @MainActor for UI-bound ViewModels
- Composition over inheritance

## Best Practices
- Weak self in async contexts
- Prefer small, focused components
- State management via @Published
- Error handling with async/throws
- SwiftUI previews for all views

## Performance Guidelines
- Minimize view updates
- Use task modifiers for async work
- Profile with Instruments regularly
- Cache expensive computations
