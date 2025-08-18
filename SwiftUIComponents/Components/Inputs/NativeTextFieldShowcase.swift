import SwiftUI

// MARK: - Native iOS TextField Showcase
// This component demonstrates native SwiftUI TextField
// NO custom implementations - pure native Apple UI only

public struct NativeTextFieldShowcase: SwiftUIComponent {
    public let configuration: NativeTextFieldConfiguration
    @State private var text: String = ""
    @State private var emailText: String = ""
    @State private var numberText: String = ""
    @State private var searchText: String = ""
    @FocusState private var isFocused: Bool
    
    public init(configuration: NativeTextFieldConfiguration) {
        self.configuration = configuration
        self._text = State(initialValue: configuration.text)
    }
    
    public init() {
        self.configuration = NativeTextFieldConfiguration()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: configuration.spacing) {
            // Label
            if !configuration.label.isEmpty {
                Text(configuration.label)
                    .font(configuration.labelFont)
                    .foregroundStyle(configuration.labelColor)
            }
            
            // Native iOS TextField Examples
            VStack(spacing: 16) {
                // Standard TextField
                VStack(alignment: .leading, spacing: 4) {
                    Text("Standard TextField")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Enter text", text: $text)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Text("Plain text field with system background")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                // Rounded Border TextField
                VStack(alignment: .leading, spacing: 4) {
                    Text("Rounded Border TextField")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Enter email", text: $emailText)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                    
                    Text("Rounded border style with email keyboard")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                // Number TextField
                VStack(alignment: .leading, spacing: 4) {
                    Text("Number TextField")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Enter number", text: $numberText)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                    
                    Text("Number pad keyboard for numeric input")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                // Search TextField
                VStack(alignment: .leading, spacing: 4) {
                    Text("Search TextField")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Search", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.none)
                        .overlay(
                            HStack {
                                Spacer()
                                if !searchText.isEmpty {
                                    Button(action: {
                                        searchText = ""
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(.trailing, 8)
                                }
                            }
                        )
                    
                    Text("Search field with clear button")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                // Focused TextField with custom styling
                VStack(alignment: .leading, spacing: 4) {
                    Text("Focused TextField")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Focus example", text: $text)
                        .focused($isFocused)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isFocused ? .blue : Color(.systemGray4), lineWidth: 1)
                        )
                        .onTapGesture {
                            isFocused = true
                        }
                    
                    Text("Custom focus styling with native TextField")
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
        .onChange(of: text) { oldValue, newValue in
            configuration.onTextChange?(newValue)
        }
    }
}

// MARK: - Configuration

public struct NativeTextFieldConfiguration: ComponentConfiguration {
    public let label: String
    public let text: String
    public let helperText: String
    public let spacing: CGFloat
    public let labelFont: Font
    public let labelColor: Color
    public let onTextChange: ((String) -> Void)?
    
    public init(
        label: String = "Native iOS TextFields",
        text: String = "",
        helperText: String = "Different native TextField styles and configurations",
        spacing: CGFloat = 8,
        labelFont: Font = .headline,
        labelColor: Color = .primary,
        onTextChange: ((String) -> Void)? = nil
    ) {
        self.label = label
        self.text = text
        self.helperText = helperText
        self.spacing = spacing
        self.labelFont = labelFont
        self.labelColor = labelColor
        self.onTextChange = onTextChange
    }
    
    // ComponentConfiguration requirements
    public static var displayName: String { "Native TextField Showcase" }
    public static var category: ComponentCategory { .inputs }
    public static var minimumIOSVersion: String { "16.0" }
    public static var description: String { "Showcase of native iOS TextField with different styles and configurations" }
}

// MARK: - Convenience Methods

extension NativeTextFieldShowcase {
    public static func standard(
        label: String = "Native iOS TextFields"
    ) -> NativeTextFieldShowcase {
        NativeTextFieldShowcase(configuration: NativeTextFieldConfiguration(
            label: label
        ))
    }
    
    public static func withHelper(
        label: String = "Native iOS TextFields",
        helperText: String
    ) -> NativeTextFieldShowcase {
        NativeTextFieldShowcase(configuration: NativeTextFieldConfiguration(
            label: label,
            helperText: helperText
        ))
    }
}

// MARK: - SwiftUI Preview

#Preview("Native TextField Showcase") {
    NavigationStack {
        ScrollView {
            VStack(spacing: 24) {
                NativeTextFieldShowcase.standard()
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle("Native TextField Styles")
    }
} 