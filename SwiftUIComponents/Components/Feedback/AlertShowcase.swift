import SwiftUI

// MARK: - Native iOS Alert Showcase
// This component demonstrates native SwiftUI Alert functionality
// NO custom implementations - pure native Apple UI only

public struct NativeAlertShowcase: SwiftUIComponent {
    public let configuration: NativeAlertConfiguration
    @State private var showingAlert = false
    @State private var showingConfirmation = false
    @State private var showingDestructive = false
    @State private var showingTextInput = false
    @State private var inputText = ""
    
    public init(configuration: NativeAlertConfiguration) {
        self.configuration = configuration
    }
    
    public init() {
        self.configuration = NativeAlertConfiguration()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: configuration.spacing) {
            // Label
            if !configuration.label.isEmpty {
                Text(configuration.label)
                    .font(configuration.labelFont)
                    .foregroundStyle(configuration.labelColor)
            }
            
            // Alert Trigger Buttons
            VStack(spacing: 12) {
                // Simple Alert
                Button("Show Simple Alert") {
                    showingAlert = true
                }
                .buttonStyle(.bordered)
                .alert("Alert Title", isPresented: $showingAlert) {
                    Button("OK") { }
                } message: {
                    Text("This is a simple alert message.")
                }
                
                // Confirmation Alert
                Button("Show Confirmation Alert") {
                    showingConfirmation = true
                }
                .buttonStyle(.bordered)
                .alert("Confirm Action", isPresented: $showingConfirmation) {
                    Button("Cancel", role: .cancel) { }
                    Button("Confirm") {
                        // Action confirmed
                    }
                } message: {
                    Text("Are you sure you want to proceed?")
                }
                
                // Destructive Alert
                Button("Show Destructive Alert") {
                    showingDestructive = true
                }
                .buttonStyle(.bordered)
                .alert("Delete Item", isPresented: $showingDestructive) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        // Destructive action
                    }
                } message: {
                    Text("This action cannot be undone.")
                }
                
                // Text Input Alert (iOS 16+)
                Button("Show Text Input Alert") {
                    showingTextInput = true
                }
                .buttonStyle(.bordered)
                .alert("Enter Name", isPresented: $showingTextInput) {
                    TextField("Name", text: $inputText)
                    Button("Cancel", role: .cancel) {
                        inputText = ""
                    }
                    Button("Save") {
                        // Save the input
                        inputText = ""
                    }
                } message: {
                    Text("Please enter your name:")
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

public struct NativeAlertConfiguration: ComponentConfiguration {
    public let label: String
    public let helperText: String
    public let spacing: CGFloat
    public let labelFont: Font
    public let labelColor: Color
    
    public init(
        label: String = "Native iOS Alerts",
        helperText: String = "Tap buttons to see different native alert styles",
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
    public static var displayName: String { "Native Alert Showcase" }
    public static var category: ComponentCategory { .feedback }
    public static var minimumIOSVersion: String { "16.0" }
    public static var description: String { "Showcase of native iOS Alert dialogs with different configurations" }
}

// MARK: - Convenience Methods

extension NativeAlertShowcase {
    public static func standard(
        label: String = "Native iOS Alerts"
    ) -> NativeAlertShowcase {
        NativeAlertShowcase(configuration: NativeAlertConfiguration(
            label: label
        ))
    }
    
    public static func withHelper(
        label: String = "Native iOS Alerts",
        helperText: String
    ) -> NativeAlertShowcase {
        NativeAlertShowcase(configuration: NativeAlertConfiguration(
            label: label,
            helperText: helperText
        ))
    }
}

// MARK: - SwiftUI Preview

#Preview("Native Alert Showcase") {
    NavigationStack {
        ScrollView {
            VStack(spacing: 24) {
                NativeAlertShowcase.standard()
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle("Native Alert Styles")
    }
} 