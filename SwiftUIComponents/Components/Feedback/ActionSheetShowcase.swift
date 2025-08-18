import SwiftUI

// MARK: - Native iOS ActionSheet/ConfirmationDialog Showcase
// This component demonstrates native SwiftUI ConfirmationDialog functionality
// NO custom implementations - pure native Apple UI only

public struct NativeActionSheetShowcase: SwiftUIComponent {
    public let configuration: NativeActionSheetConfiguration
    @State private var showingBasicSheet = false
    @State private var showingDestructiveSheet = false
    @State private var showingComplexSheet = false
    @State private var showingTitleMessageSheet = false
    
    public init(configuration: NativeActionSheetConfiguration) {
        self.configuration = configuration
    }
    
    public init() {
        self.configuration = NativeActionSheetConfiguration()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: configuration.spacing) {
            // Label
            if !configuration.label.isEmpty {
                Text(configuration.label)
                    .font(configuration.labelFont)
                    .foregroundStyle(configuration.labelColor)
            }
            
            // Action Sheet Trigger Buttons
            VStack(spacing: 12) {
                // Basic Action Sheet
                Button("Show Basic Action Sheet") {
                    showingBasicSheet = true
                }
                .buttonStyle(.bordered)
                .confirmationDialog("Choose an Option", isPresented: $showingBasicSheet) {
                    Button("Option 1") {
                        // Handle option 1
                    }
                    Button("Option 2") {
                        // Handle option 2
                    }
                    Button("Cancel", role: .cancel) { }
                }
                
                // Destructive Action Sheet
                Button("Show Destructive Action Sheet") {
                    showingDestructiveSheet = true
                }
                .buttonStyle(.bordered)
                .confirmationDialog("Delete Item", isPresented: $showingDestructiveSheet) {
                    Button("Delete", role: .destructive) {
                        // Handle destructive action
                    }
                    Button("Cancel", role: .cancel) { }
                }
                
                // Complex Action Sheet
                Button("Show Complex Action Sheet") {
                    showingComplexSheet = true
                }
                .buttonStyle(.bordered)
                .confirmationDialog("Select Action", isPresented: $showingComplexSheet) {
                    Button("Edit") {
                        // Handle edit
                    }
                    Button("Share") {
                        // Handle share
                    }
                    Button("Duplicate") {
                        // Handle duplicate
                    }
                    Button("Delete", role: .destructive) {
                        // Handle delete
                    }
                    Button("Cancel", role: .cancel) { }
                }
                
                // Action Sheet with Title and Message
                Button("Show Action Sheet with Message") {
                    showingTitleMessageSheet = true
                }
                .buttonStyle(.bordered)
                .confirmationDialog(
                    "Photo Options",
                    isPresented: $showingTitleMessageSheet,
                    titleVisibility: .visible
                ) {
                    Button("Take Photo") {
                        // Handle take photo
                    }
                    Button("Choose from Library") {
                        // Handle photo library
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Select how you'd like to add a photo")
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

public struct NativeActionSheetConfiguration: ComponentConfiguration {
    public let label: String
    public let helperText: String
    public let spacing: CGFloat
    public let labelFont: Font
    public let labelColor: Color
    
    public init(
        label: String = "Native iOS Action Sheets",
        helperText: String = "Tap buttons to see different native action sheet styles",
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
    public static var displayName: String { "Native ActionSheet Showcase" }
    public static var category: ComponentCategory { .feedback }
    public static var minimumIOSVersion: String { "16.0" }
    public static var description: String { "Showcase of native iOS Action Sheets (ConfirmationDialog) with different configurations" }
}

// MARK: - Convenience Methods

extension NativeActionSheetShowcase {
    public static func standard(
        label: String = "Native iOS Action Sheets"
    ) -> NativeActionSheetShowcase {
        NativeActionSheetShowcase(configuration: NativeActionSheetConfiguration(
            label: label
        ))
    }
    
    public static func withHelper(
        label: String = "Native iOS Action Sheets",
        helperText: String
    ) -> NativeActionSheetShowcase {
        NativeActionSheetShowcase(configuration: NativeActionSheetConfiguration(
            label: label,
            helperText: helperText
        ))
    }
}

// MARK: - SwiftUI Preview

#Preview("Native ActionSheet Showcase") {
    NavigationStack {
        ScrollView {
            VStack(spacing: 24) {
                NativeActionSheetShowcase.standard()
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle("Native ActionSheet Styles")
    }
} 