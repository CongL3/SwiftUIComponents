import SwiftUI

// MARK: - Native Apple Toggle Styles Showcase
// This component demonstrates ALL built-in SwiftUI toggle styles
// NO custom implementations - pure native Apple UI only

public struct NativeToggleShowcase: SwiftUIComponent {
    public let configuration: NativeToggleConfiguration
    @State private var isOn: Bool = false
    
    public init(configuration: NativeToggleConfiguration) {
        self.configuration = configuration
        self._isOn = State(initialValue: configuration.isOn)
    }
    
    public init() {
        self.configuration = NativeToggleConfiguration()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: configuration.spacing) {
            // Native SwiftUI Toggle with specified style
            nativeToggle
            
            // Helper text
            if !configuration.helperText.isEmpty {
                Text(configuration.helperText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .onChange(of: isOn) { oldValue, newValue in
            configuration.onToggle?(newValue)
        }
    }
    
    @ViewBuilder
    private var nativeToggle: some View {
        switch configuration.style {
        case .automatic:
            Toggle(configuration.label, isOn: $isOn)
                .toggleStyle(.automatic) // Default toggle style
            
        case .switch:
            Toggle(configuration.label, isOn: $isOn)
                .toggleStyle(.switch) // Switch toggle style
            
        case .checkbox:
            // Note: .checkbox is only available on macOS
            Toggle(configuration.label, isOn: $isOn)
                .toggleStyle(.switch) // Fallback to switch on iOS
            
        case .button:
            Toggle(configuration.label, isOn: $isOn)
                .toggleStyle(.button) // Button toggle style
        }
    }
}

// MARK: - Configuration

public struct NativeToggleConfiguration: ComponentConfiguration {
    public static let displayName = "Native Toggle Showcase"
    public static let category: ComponentCategory = .controls
    public static let minimumIOSVersion = "16.0"
    public static let description = "Showcase of all native Apple toggle styles"
    
    // Content
    public let label: String
    public let isOn: Bool
    public let helperText: String
    
    // Native Style Selection
    public let style: NativeToggleStyle
    
    // Layout
    public let spacing: CGFloat
    
    // Behavior
    public let onToggle: ((Bool) -> Void)?
    
    public init(
        label: String = "Toggle Option",
        isOn: Bool = false,
        helperText: String = "",
        style: NativeToggleStyle = .automatic,
        spacing: CGFloat = 8,
        onToggle: ((Bool) -> Void)? = nil
    ) {
        self.label = label
        self.isOn = isOn
        self.helperText = helperText
        self.style = style
        self.spacing = spacing
        self.onToggle = onToggle
    }
}

// MARK: - Native Toggle Styles

public enum NativeToggleStyle: CaseIterable {
    case automatic  // Default toggle style
    case `switch`     // Switch toggle style
    case checkbox   // Checkbox toggle style (primarily macOS)
    case button     // Button toggle style
    
    public var displayName: String {
        switch self {
        case .automatic: return "Automatic"
        case .`switch`: return "Switch"
        case .checkbox: return "Checkbox"
        case .button: return "Button"
        }
    }
    
    public var description: String {
        switch self {
        case .automatic: return "Default toggle style based on platform"
        case .`switch`: return "iOS-style switch toggle"
        case .checkbox: return "Checkbox-style toggle (macOS)"
        case .button: return "Button-style toggle"
        }
    }
}

// MARK: - Convenience Initializers

extension NativeToggleShowcase {
    public static func automatic(
        label: String,
        isOn: Bool = false
    ) -> NativeToggleShowcase {
        NativeToggleShowcase(configuration: NativeToggleConfiguration(
            label: label,
            isOn: isOn,
            helperText: "Default toggle style for platform",
            style: .automatic
        ))
    }
    
    public static func `switch`(
        label: String,
        isOn: Bool = false
    ) -> NativeToggleShowcase {
        NativeToggleShowcase(configuration: NativeToggleConfiguration(
            label: label,
            isOn: isOn,
            helperText: "iOS-style switch toggle",
            style: .switch
        ))
    }
    
    public static func checkbox(
        label: String,
        isOn: Bool = false
    ) -> NativeToggleShowcase {
        NativeToggleShowcase(configuration: NativeToggleConfiguration(
            label: label,
            isOn: isOn,
            helperText: "Checkbox-style toggle",
            style: .checkbox
        ))
    }
    
    public static func button(
        label: String,
        isOn: Bool = false
    ) -> NativeToggleShowcase {
        NativeToggleShowcase(configuration: NativeToggleConfiguration(
            label: label,
            isOn: isOn,
            helperText: "Button-style toggle",
            style: .button
        ))
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        ScrollView {
            LazyVStack(spacing: 30) {
                // All Native Toggle Styles
                Group {
                    Text("Native Apple Toggle Styles")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Automatic Style
                    NativeToggleShowcase.automatic(
                        label: "Automatic Toggle",
                        isOn: true
                    )
                    
                    Divider()
                    
                    // Switch Style
                    NativeToggleShowcase.`switch`(
                        label: "Switch Toggle",
                        isOn: false
                    )
                    
                    Divider()
                    
                    // Checkbox Style
                    NativeToggleShowcase.checkbox(
                        label: "Checkbox Toggle",
                        isOn: true
                    )
                    
                    Divider()
                    
                    // Button Style
                    NativeToggleShowcase.button(
                        label: "Button Toggle",
                        isOn: false
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Native Toggle Styles")
        .navigationBarTitleDisplayMode(.large)
    }
} 