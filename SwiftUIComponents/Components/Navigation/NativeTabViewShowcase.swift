import SwiftUI

// MARK: - Native iOS TabView Showcase
// This component demonstrates native SwiftUI TabView
// NO custom implementations - pure native Apple UI only

public struct NativeTabViewShowcase: SwiftUIComponent {
    public let configuration: NativeTabViewConfiguration
    @State private var selectedTab = 0
    @State private var pageTabSelection = 0
    
    public init(configuration: NativeTabViewConfiguration) {
        self.configuration = configuration
    }
    
    public init() {
        self.configuration = NativeTabViewConfiguration()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: configuration.spacing) {
            // Label
            if !configuration.label.isEmpty {
                Text(configuration.label)
                    .font(configuration.labelFont)
                    .foregroundStyle(configuration.labelColor)
            }
            
            // Native iOS TabView Examples
            VStack(spacing: 24) {
                // Standard TabView
                VStack(alignment: .leading, spacing: 8) {
                    Text("Standard TabView")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TabView(selection: $selectedTab) {
                        VStack {
                            Image(systemName: "house.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.blue)
                            Text("Home")
                                .font(.headline)
                            Text("This is the home tab")
                                .foregroundStyle(.secondary)
                        }
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }
                        .tag(0)
                        
                        VStack {
                            Image(systemName: "magnifyingglass")
                                .font(.largeTitle)
                                .foregroundStyle(.green)
                            Text("Search")
                                .font(.headline)
                            Text("This is the search tab")
                                .foregroundStyle(.secondary)
                        }
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                        .tag(1)
                        
                        VStack {
                            Image(systemName: "person.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.purple)
                            Text("Profile")
                                .font(.headline)
                            Text("This is the profile tab")
                                .foregroundStyle(.secondary)
                        }
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                        .tag(2)
                    }
                    .frame(height: 200)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Text("Standard tab bar with icons and labels")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                // Page TabView
                VStack(alignment: .leading, spacing: 8) {
                    Text("Page TabView Style")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TabView(selection: $pageTabSelection) {
                        VStack {
                            Circle()
                                .fill(.red.gradient)
                                .frame(width: 80, height: 80)
                            Text("Page 1")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text("Swipe to navigate")
                                .foregroundStyle(.secondary)
                        }
                        .tag(0)
                        
                        VStack {
                            Circle()
                                .fill(.blue.gradient)
                                .frame(width: 80, height: 80)
                            Text("Page 2")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text("Swipe to navigate")
                                .foregroundStyle(.secondary)
                        }
                        .tag(1)
                        
                        VStack {
                            Circle()
                                .fill(.green.gradient)
                                .frame(width: 80, height: 80)
                            Text("Page 3")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text("Swipe to navigate")
                                .foregroundStyle(.secondary)
                        }
                        .tag(2)
                    }
                    .tabViewStyle(.page)
                    .frame(height: 200)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Text("Page-style TabView with page indicators")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                // Page TabView with Index Display Always
                VStack(alignment: .leading, spacing: 8) {
                    Text("Page TabView with Always Visible Indicators")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TabView {
                        VStack {
                            Rectangle()
                                .fill(.orange.gradient)
                                .frame(height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Text("Card 1")
                                .font(.headline)
                        }
                        
                        VStack {
                            Rectangle()
                                .fill(.pink.gradient)
                                .frame(height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Text("Card 2")
                                .font(.headline)
                        }
                        
                        VStack {
                            Rectangle()
                                .fill(.cyan.gradient)
                                .frame(height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Text("Card 3")
                                .font(.headline)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .frame(height: 180)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Text("Page indicators always visible")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Helper Text
            if !configuration.helperText.isEmpty {
                Text(configuration.helperText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Configuration

public struct NativeTabViewConfiguration: ComponentConfiguration {
    public let label: String
    public let helperText: String
    public let spacing: CGFloat
    public let labelFont: Font
    public let labelColor: Color
    
    public init(
        label: String = "Native iOS TabView",
        helperText: String = "Different native TabView styles and configurations",
        spacing: CGFloat = 8,
        labelFont: Font = .headline,
        labelColor: Color = .primary
    ) {
        self.label = label
        self.helperText = helperText
        self.spacing = spacing
        self.labelFont = labelFont
        self.labelColor = labelColor
    }
    
    // ComponentConfiguration requirements
    public static var displayName: String { "Native TabView Showcase" }
    public static var category: ComponentCategory { .navigation }
    public static var minimumIOSVersion: String { "16.0" }
    public static var description: String { "Showcase of native iOS TabView with different styles (.automatic, .page)" }
}

// MARK: - Convenience Methods

extension NativeTabViewShowcase {
    public static func standard(
        label: String = "Native iOS TabView"
    ) -> NativeTabViewShowcase {
        NativeTabViewShowcase(configuration: NativeTabViewConfiguration(
            label: label
        ))
    }
    
    public static func withHelper(
        label: String = "Native iOS TabView",
        helperText: String
    ) -> NativeTabViewShowcase {
        NativeTabViewShowcase(configuration: NativeTabViewConfiguration(
            label: label,
            helperText: helperText
        ))
    }
}

// MARK: - SwiftUI Preview

#Preview("Native TabView Showcase") {
    NavigationStack {
        ScrollView {
            VStack(spacing: 24) {
                NativeTabViewShowcase.standard()
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle("Native TabView Styles")
    }
} 