import SwiftUI

struct NavigationStackShowcase: View {
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0) {
                NativeNavigationExample(
                    title: "NavigationStack with Path",
                    description: "iOS 16+ NavigationStack with programmatic navigation path",
                    navigationPath: $navigationPath
                )
                
                Divider()
                    .padding(.horizontal)
                
                NativeNavigationExample(
                    title: "Deep Link Navigation",
                    description: "Navigate directly to nested screens using path",
                    navigationPath: $navigationPath
                )
                
                Divider()
                    .padding(.horizontal)
                
                NativeNavigationExample(
                    title: "Path Management",
                    description: "Programmatically control navigation stack",
                    navigationPath: $navigationPath
                )
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .navigationTitle("NavigationStack")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: NavigationDestination.self) { destination in
                NavigationDestinationView(destination: destination, navigationPath: $navigationPath)
            }
        }
    }
}

enum NavigationDestination: Hashable, CaseIterable {
    case detail
    case settings
    case profile
    case nested
    
    var title: String {
        switch self {
        case .detail: return "Detail View"
        case .settings: return "Settings"
        case .profile: return "Profile"
        case .nested: return "Nested View"
        }
    }
    
    var description: String {
        switch self {
        case .detail: return "A detailed view with more information"
        case .settings: return "App settings and preferences"
        case .profile: return "User profile information"
        case .nested: return "A nested view that can navigate further"
        }
    }
    
    var systemImage: String {
        switch self {
        case .detail: return "doc.text"
        case .settings: return "gear"
        case .profile: return "person.circle"
        case .nested: return "arrow.right.circle"
        }
    }
}

struct NativeNavigationExample: View {
    let title: String
    let description: String
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 8) {
                // Navigation buttons
                HStack(spacing: 12) {
                    NavigationButton(
                        destination: .detail,
                        navigationPath: $navigationPath
                    )
                    
                    NavigationButton(
                        destination: .settings,
                        navigationPath: $navigationPath
                    )
                }
                
                HStack(spacing: 12) {
                    NavigationButton(
                        destination: .profile,
                        navigationPath: $navigationPath
                    )
                    
                    NavigationButton(
                        destination: .nested,
                        navigationPath: $navigationPath
                    )
                }
                
                // Path management buttons
                HStack(spacing: 12) {
                    Button("Deep Link") {
                        // Navigate directly to nested path
                        navigationPath.append(NavigationDestination.detail)
                        navigationPath.append(NavigationDestination.nested)
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Pop to Root") {
                        navigationPath = NavigationPath()
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            Text("Path count: \(navigationPath.count)")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

struct NavigationButton: View {
    let destination: NavigationDestination
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        NavigationLink(value: destination) {
            VStack(spacing: 4) {
                Image(systemName: destination.systemImage)
                    .font(.title2)
                
                Text(destination.title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(.bordered)
    }
}

struct NavigationDestinationView: View {
    let destination: NavigationDestination
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Image(systemName: destination.systemImage)
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                
                Text(destination.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(destination.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 12) {
                Text("Navigation Path Info")
                    .font(.headline)
                
                Text("Current path count: \(navigationPath.count)")
                    .font(.body)
                
                if destination == .nested {
                    NavigationLink("Go Deeper", value: NavigationDestination.detail)
                        .buttonStyle(.borderedProminent)
                }
                
                HStack(spacing: 12) {
                    Button("Pop One Level") {
                        navigationPath.removeLast()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Pop to Root") {
                        navigationPath = NavigationPath()
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle(destination.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStackShowcase()
} 