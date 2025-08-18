import SwiftUI

// MARK: - Native iOS Button Showcase
// This component demonstrates native SwiftUI Button styles
// NO custom implementations - pure native Apple UI only

public struct NativeButtonShowcase: SwiftUIComponent {
    public let configuration: NativeButtonConfiguration
    @State private var isPressed = false
    
    public init(configuration: NativeButtonConfiguration) {
        self.configuration = configuration
    }
    
    public init() {
        self.configuration = NativeButtonConfiguration()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: configuration.spacing) {
            // Label
            if !configuration.label.isEmpty {
                Text(configuration.label)
                    .font(configuration.labelFont)
                    .foregroundStyle(configuration.labelColor)
            }
            
            // Native iOS Button Examples
            VStack(spacing: 16) {
                // Automatic Button Style
                VStack(alignment: .leading, spacing: 8) {
                    Text("Automatic Button Style")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Button("Automatic Style") {
                        // Action
                    }
                    .buttonStyle(.automatic)
                    
                    Text("System default button style")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                // Bordered Button Style
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bordered Button Style")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Button("Bordered Style") {
                        // Action
                    }
                    .buttonStyle(.bordered)
                    
                    Text("Button with border outline")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                // Bordered Prominent Button Style
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bordered Prominent Button Style")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Button("Bordered Prominent") {
                        // Action
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Text("Prominent button with filled background")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                // Plain Button Style
                VStack(alignment: .leading, spacing: 8) {
                    Text("Plain Button Style")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Button("Plain Style") {
                        // Action
                    }
                    .buttonStyle(.plain)
                    
                    Text("Minimal button without styling")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                // Button with Icon
                VStack(alignment: .leading, spacing: 8) {
                    Text("Button with Icon")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Button(action: {
                        // Action
                    }) {
                        Label("Download", systemImage: "arrow.down.circle")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Text("Native button with SF Symbol icon")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                // Destructive Button
                VStack(alignment: .leading, spacing: 8) {
                    Text("Destructive Button")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Button("Delete", role: .destructive) {
                        // Destructive action
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Text("Button with destructive role")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                // Disabled Button
                VStack(alignment: .leading, spacing: 8) {
                    Text("Disabled Button")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Button("Disabled Button") {
                        // Action
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(true)
                    
                    Text("Button in disabled state")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                // Button with Control Size
                VStack(alignment: .leading, spacing: 8) {
                    Text("Button Sizes")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    HStack(spacing: 12) {
                        Button("Mini") {
                            // Action
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.mini)
                        
                        Button("Small") {
                            // Action
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        
                        Button("Regular") {
                            // Action
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.regular)
                        
                        Button("Large") {
                            // Action
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    }
                    
                    Text("Different native button sizes")
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

public struct NativeButtonConfiguration: ComponentConfiguration {
    public let label: String
    public let helperText: String
    public let spacing: CGFloat
    public let labelFont: Font
    public let labelColor: Color
    
    public init(
        label: String = "Native iOS Buttons",
        helperText: String = "All native SwiftUI button styles and configurations",
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
    public static var displayName: String { "Native Button Showcase" }
    public static var category: ComponentCategory { .buttons }
    public static var minimumIOSVersion: String { "16.0" }
    public static var description: String { "Showcase of native iOS Button with all built-in styles and configurations" }
}

// MARK: - Convenience Methods

extension NativeButtonShowcase {
    public static func standard(
        label: String = "Native iOS Buttons"
    ) -> NativeButtonShowcase {
        NativeButtonShowcase(configuration: NativeButtonConfiguration(
            label: label
        ))
    }
    
    public static func withHelper(
        label: String = "Native iOS Buttons",
        helperText: String
    ) -> NativeButtonShowcase {
        NativeButtonShowcase(configuration: NativeButtonConfiguration(
            label: label,
            helperText: helperText
        ))
    }
}

// MARK: - SwiftUI Preview

#Preview("Native Button Showcase") {
    NavigationStack {
        ScrollView {
            VStack(spacing: 24) {
                NativeButtonShowcase.standard()
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle("Native Button Styles")
    }
} 