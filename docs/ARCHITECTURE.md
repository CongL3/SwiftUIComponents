# Architecture

This document provides a detailed overview of the project's architecture and the reasoning behind our design choices.

## 🏛️ Core Principles

*   **Lean MVVM**: We use a lightweight Model-View-ViewModel (MVVM) architecture, where ViewModels are responsible for handling minimal business logic.
*   **Composition**: We favor small, focused components that can be easily combined to create more complex UIs.
*   **SwiftUI Native**: We leverage SwiftUI's declarative paradigm to create a more expressive and maintainable codebase.
*   **Performance First**: We prioritize performance by optimizing for smooth animations and updates.

## 🏗️ Component Structure

Our components follow a consistent structure, with a clear separation of concerns:

```swift
// Base component pattern
struct MyComponent: View {
    // 1. Public interface
    let title: String
    var onAction: () -> Void
    
    // 2. Private state
    @State private var isAnimating = false
    
    // 3. Computed properties
    private var animationDuration: Double { isAnimating ? 0.3 : 0.15 }
    
    // 4. Body implementation
    var body: some View {
        // Component implementation
    }
    
    // 5. Private view builders
    @ViewBuilder
    private func buildContent() -> some View {
        // Subview implementation
    }
}
```

## 🧱 ViewModel Pattern

Our ViewModels are responsible for managing the state of our components and handling user actions:

```swift
@MainActor
final class ComponentViewModel: ObservableObject {
    // 1. Published state
    @Published private(set) var state: State
    
    // 2. Action handling
    func handleAction(_ action: Action) async throws {
        // Handle user actions
    }
    
    // 3. Side effects
    private func performSideEffect() async {
        // Handle side effects
    }
}
```

## 📚 Component Guidelines

### State Management

*   Use `@State` for internal view state.
*   Use `@Binding` for parent-controlled state.
*   Use `@Published` for ViewModel state.
*   Avoid global state when possible.

### Performance Optimization

*   Keep views small and focused.
*   Use `@ViewBuilder` for complex subviews.
*   Leverage SwiftUI's view identity system.
*   Profile with Instruments regularly.

### Error Handling

```swift
// Standard error handling pattern
enum ComponentError: Error {
    case invalidInput
    case processingFailed
}

// Usage in ViewModel
do {
    try await processInput()
} catch {
    state = .error(error)
}
```

## 🧪 Testing Strategy

*   Unit tests for ViewModels.
*   SwiftUI previews for visual testing.
*   Snapshot tests for UI consistency.
*   Performance tests for animations.
