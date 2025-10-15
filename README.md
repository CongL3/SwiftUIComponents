# SwiftUIComponents

This project is a comprehensive showcase of native SwiftUI components, designed to provide developers with a complete reference for all built-in UI elements.

## 🎯 Mission

Our goal is to create a single, easy-to-use resource that demonstrates the full range of native SwiftUI components and their available styles. This project is for developers who want to see everything iOS provides out of the box, without the distraction of custom implementations.

## ✨ Features

*   **Component Library**: A collection of 49 native SwiftUI components, with more on the way.
*   **Companion App**: An iOS app that showcases all the components in the library, with live previews and interactive examples.
*   **Code Generation**: The ability to auto-generate working SwiftUI code for any component in the library.

## 🏛️ Architecture

This project is built using a lightweight Model-View-ViewModel (MVVM) architecture, with a focus on composition and performance. The core technologies include:

*   **SwiftUI**: For the UI layer.
*   **MVVM**: For the architecture.
*   **async/await**: For modern concurrency.
*   **Combine**: For reactive data flow.
*   **Swift Package Manager**: For dependency management.

For a more detailed overview of the architecture, please see the [Architecture](docs/ARCHITECTURE.md) document.

## 📚 Component Library

The component library is organized into the following categories:

*   **Buttons & Actions**: 4/7 complete
*   **Controls & Selection**: 5/7 complete
*   **Text & Input**: 6/6 complete
*   **Feedback & Indicators**: 2/4 complete
*   **Navigation**: 1/8 complete
*   **Layout & Data**: 0/10 complete
*   **Media & Graphics**: 0/5 complete
*   **System Integration**: 0/6 complete

For a complete list of all the components in the library, please see the [Component Roadmap](docs/ComponentRoadmap.md).

## 🤝 Contributing

We welcome contributions to this project! If you're interested in helping us build the ultimate SwiftUI component reference, please see our [CONTRIBUTING.md](CONTRIBUTING.md) file for more information.

## 🚀 Roadmap

Our immediate focus is on filling the gaps in our component library. Based on user feedback and the current status of the project, our priorities are as follows:

1.  **Complete Feedback & Indicators**: Add `ProgressView` and `HUD/Loading` components.
2.  **Add Core Navigation**: Implement `NavigationStack`, `Sheet`, `Popover`, and `FullScreenCover`.
3.  **Add Essential Media**: Add `Image`, `AsyncImage`, and `Symbol`.
4.  **Add Core Layout**: Implement `List`, `ScrollView`, `Form`, `Section`, and `Divider`.
5.  **Add System Integration**: Add `PhotosPicker`, `DocumentPicker`, and `MapKit`.

For a more detailed overview of our future plans, please see the [TDD.md](docs/TDD.md) document.
