import SwiftUI

// MARK: - Native iOS TextEditor Showcase
// This component demonstrates native SwiftUI TextEditor
// NO custom implementations - pure native Apple UI only

public struct NativeTextEditorShowcase: SwiftUIComponent {
    public let configuration: NativeTextEditorConfiguration
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    
    public init(configuration: NativeTextEditorConfiguration) {
        self.configuration = configuration
        self._text = State(initialValue: configuration.text)
    }
    
    public init() {
        self.configuration = NativeTextEditorConfiguration()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: configuration.spacing) {
            // Label
            if !configuration.label.isEmpty {
                Text(configuration.label)
                    .font(configuration.labelFont)
                    .foregroundStyle(configuration.labelColor)
            }
            
            // Native iOS TextEditor
            textEditorView
            
            // Character/Word Count
            if configuration.showCharacterCount {
                HStack {
                    Spacer()
                    Text("\(text.count) characters")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
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
    
    @ViewBuilder
    private var textEditorView: some View {
        switch configuration.style {
        case .standard:
            standardTextEditor
        case .bordered:
            borderedTextEditor
        case .backgrounded:
            backgroundedTextEditor
        case .minimal:
            minimalTextEditor
        }
    }
    
    private var standardTextEditor: some View {
        TextEditor(text: $text)
            .frame(height: configuration.height)
            .focused($isFocused)
            .font(configuration.textFont)
            .scrollContentBackground(.hidden)
            .background(Color(.systemBackground))
    }
    
    private var borderedTextEditor: some View {
        TextEditor(text: $text)
            .frame(height: configuration.height)
            .focused($isFocused)
            .font(configuration.textFont)
            .padding(8)
            .scrollContentBackground(.hidden)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isFocused ? .blue : Color(.systemGray4), lineWidth: 1)
            )
    }
    
    private var backgroundedTextEditor: some View {
        TextEditor(text: $text)
            .frame(height: configuration.height)
            .focused($isFocused)
            .font(configuration.textFont)
            .padding(12)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var minimalTextEditor: some View {
        TextEditor(text: $text)
            .frame(height: configuration.height)
            .focused($isFocused)
            .font(configuration.textFont)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
    }
}

// MARK: - Configuration

public struct NativeTextEditorConfiguration: ComponentConfiguration {
    public let label: String
    public let text: String
    public let helperText: String
    public let style: NativeTextEditorStyle
    public let height: CGFloat
    public let showCharacterCount: Bool
    public let spacing: CGFloat
    public let labelFont: Font
    public let labelColor: Color
    public let textFont: Font
    public let onTextChange: ((String) -> Void)?
    
    public init(
        label: String = "Notes",
        text: String = "",
        helperText: String = "",
        style: NativeTextEditorStyle = .standard,
        height: CGFloat = 120,
        showCharacterCount: Bool = false,
        spacing: CGFloat = 8,
        labelFont: Font = .headline,
        labelColor: Color = .primary,
        textFont: Font = .body,
        onTextChange: ((String) -> Void)? = nil
    ) {
        self.label = label
        self.text = text
        self.helperText = helperText
        self.style = style
        self.height = height
        self.showCharacterCount = showCharacterCount
        self.spacing = spacing
        self.labelFont = labelFont
        self.labelColor = labelColor
        self.textFont = textFont
        self.onTextChange = onTextChange
    }
    
    // ComponentConfiguration requirements
    public static var displayName: String { "Native TextEditor Showcase" }
    public static var category: ComponentCategory { .inputs }
    public static var minimumIOSVersion: String { "16.0" }
    public static var description: String { "Showcase of native iOS TextEditor for multiline text input" }
}

public enum NativeTextEditorStyle: CaseIterable {
    case standard       // Standard TextEditor
    case bordered       // TextEditor with border
    case backgrounded   // TextEditor with background
    case minimal        // Minimal TextEditor without background
    
    public var displayName: String {
        switch self {
        case .standard: return "Standard"
        case .bordered: return "Bordered"
        case .backgrounded: return "Backgrounded"
        case .minimal: return "Minimal"
        }
    }
    
    public var description: String {
        switch self {
        case .standard: return "Standard TextEditor with system background"
        case .bordered: return "TextEditor with focus-aware border"
        case .backgrounded: return "TextEditor with colored background"
        case .minimal: return "Minimal TextEditor without background styling"
        }
    }
}

// MARK: - Convenience Methods

extension NativeTextEditorShowcase {
    public static func standard(
        label: String,
        text: String = "",
        height: CGFloat = 120
    ) -> NativeTextEditorShowcase {
        NativeTextEditorShowcase(configuration: NativeTextEditorConfiguration(
            label: label,
            text: text,
            style: .standard,
            height: height
        ))
    }
    
    public static func bordered(
        label: String,
        text: String = "",
        height: CGFloat = 120
    ) -> NativeTextEditorShowcase {
        NativeTextEditorShowcase(configuration: NativeTextEditorConfiguration(
            label: label,
            text: text,
            style: .bordered,
            height: height
        ))
    }
    
    public static func backgrounded(
        label: String,
        text: String = "",
        height: CGFloat = 120
    ) -> NativeTextEditorShowcase {
        NativeTextEditorShowcase(configuration: NativeTextEditorConfiguration(
            label: label,
            text: text,
            style: .backgrounded,
            height: height
        ))
    }
    
    public static func withCharacterCount(
        label: String,
        text: String = "",
        height: CGFloat = 120
    ) -> NativeTextEditorShowcase {
        NativeTextEditorShowcase(configuration: NativeTextEditorConfiguration(
            label: label,
            text: text,
            style: .bordered,
            height: height,
            showCharacterCount: true
        ))
    }
}

// MARK: - SwiftUI Preview

#Preview("Native TextEditor Showcase") {
    NavigationStack {
        ScrollView {
            VStack(spacing: 24) {
                // Standard TextEditor
                VStack(alignment: .leading, spacing: 8) {
                    Text("Standard Style")
                        .font(.headline)
                    NativeTextEditorShowcase.standard(
                        label: "Description",
                        text: "Enter your description here...",
                        height: 100
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Bordered TextEditor
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bordered Style")
                        .font(.headline)
                    NativeTextEditorShowcase.bordered(
                        label: "Comments",
                        text: "Add your comments...",
                        height: 120
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Backgrounded TextEditor
                VStack(alignment: .leading, spacing: 8) {
                    Text("Backgrounded Style")
                        .font(.headline)
                    NativeTextEditorShowcase.backgrounded(
                        label: "Notes",
                        text: "Take notes here...",
                        height: 100
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // With Character Count
                VStack(alignment: .leading, spacing: 8) {
                    Text("With Character Count")
                        .font(.headline)
                    NativeTextEditorShowcase.withCharacterCount(
                        label: "Review",
                        text: "Write your review...",
                        height: 120
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle("Native TextEditor Styles")
    }
} 