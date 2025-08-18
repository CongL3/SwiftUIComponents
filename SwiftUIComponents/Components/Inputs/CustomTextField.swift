import SwiftUI

// MARK: - Custom TextField Component

public struct CustomTextField: SwiftUIComponent {
    public let configuration: CustomTextFieldConfiguration
    @State private var text: String = ""
    @State private var isValid: Bool = true
    @State private var showError: Bool = false
    @FocusState private var isFocused: Bool
    
    public init(configuration: CustomTextFieldConfiguration) {
        self.configuration = configuration
        self._text = State(initialValue: configuration.text)
    }
    
    public init() {
        self.configuration = CustomTextFieldConfiguration()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: configuration.labelSpacing) {
            // Label
            if !configuration.label.isEmpty {
                HStack {
                    Text(configuration.label)
                        .font(.system(size: configuration.labelFontSize, weight: configuration.labelFontWeight))
                        .foregroundStyle(labelColor)
                    
                    if configuration.isRequired {
                        Text("*")
                            .foregroundStyle(.red)
                    }
                    
                    Spacer()
                    
                    if !configuration.helperText.isEmpty {
                        Text(configuration.helperText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            // Text Field Container
            HStack(spacing: configuration.iconSpacing) {
                // Leading Icon
                if let leadingIcon = configuration.leadingIcon {
                    Image(systemName: leadingIcon)
                        .font(.system(size: configuration.iconSize))
                        .foregroundStyle(iconColor)
                        .frame(width: configuration.iconSize, height: configuration.iconSize)
                }
                
                // Text Field
                TextField(configuration.placeholder, text: $text)
                    .font(.system(size: configuration.fontSize, weight: configuration.fontWeight))
                    .foregroundStyle(textColor)
                    .focused($isFocused)
                    .textInputAutocapitalization(configuration.autocapitalization)
                    .keyboardType(configuration.keyboardType)
                    .autocorrectionDisabled(configuration.disableAutocorrection)
                    .onChange(of: text) { _, newValue in
                        handleTextChange(newValue)
                    }
                    .onChange(of: isFocused) { _, focused in
                        if !focused && configuration.validateOnBlur {
                            validateInput()
                        }
                    }
                
                // Trailing Icon
                if let trailingIcon = configuration.trailingIcon {
                    Button(action: configuration.trailingAction) {
                        Image(systemName: trailingIcon)
                            .font(.system(size: configuration.iconSize))
                            .foregroundStyle(iconColor)
                            .frame(width: configuration.iconSize, height: configuration.iconSize)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Clear Button
                if configuration.showClearButton && !text.isEmpty && isFocused {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: configuration.iconSize))
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, configuration.horizontalPadding)
            .padding(.vertical, configuration.verticalPadding)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            .animation(.easeInOut(duration: 0.2), value: showError)
            
            // Error Message
            if showError && !configuration.errorMessage.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundStyle(.red)
                    
                    Text(configuration.errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                    
                    Spacer()
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            // Character Count
            if configuration.showCharacterCount {
                HStack {
                    Spacer()
                    Text("\(text.count)/\(configuration.maxCharacters)")
                        .font(.caption)
                        .foregroundStyle(characterCountColor)
                }
            }
        }
        .disabled(configuration.isDisabled)
        .opacity(configuration.isDisabled ? 0.6 : 1.0)
    }
    
    // MARK: - Private Methods
    
    private func handleTextChange(_ newValue: String) {
        // Character limit
        if newValue.count > configuration.maxCharacters {
            text = String(newValue.prefix(configuration.maxCharacters))
            return
        }
        
        // Real-time validation
        if configuration.validateOnChange {
            validateInput()
        }
        
        // Call onChange handler
        configuration.onTextChange(text)
    }
    
    private func validateInput() {
        isValid = configuration.validator(text)
        showError = !isValid && !text.isEmpty
    }
    
    // MARK: - Computed Properties
    
    private var labelColor: Color {
        if showError {
            return .red
        }
        return configuration.labelColor
    }
    
    private var textColor: Color {
        if configuration.isDisabled {
            return .secondary
        }
        if showError {
            return .red
        }
        return configuration.textColor
    }
    
    private var iconColor: Color {
        if showError {
            return .red
        }
        if isFocused {
            return configuration.focusedIconColor
        }
        return configuration.iconColor
    }
    
    private var backgroundColor: Color {
        if configuration.isDisabled {
            return configuration.disabledBackgroundColor
        }
        if isFocused {
            return configuration.focusedBackgroundColor
        }
        return configuration.backgroundColor
    }
    
    private var borderColor: Color {
        if showError {
            return .red
        }
        if isFocused {
            return configuration.focusedBorderColor
        }
        return configuration.borderColor
    }
    
    private var borderWidth: CGFloat {
        if showError || isFocused {
            return configuration.focusedBorderWidth
        }
        return configuration.borderWidth
    }
    
    private var characterCountColor: Color {
        let ratio = Double(text.count) / Double(configuration.maxCharacters)
        if ratio >= 0.9 {
            return .red
        } else if ratio >= 0.8 {
            return .orange
        }
        return .secondary
    }
    
    // MARK: - Convenience Initializers
    
    /// Standard text field style
    public static func standard(
        label: String = "",
        placeholder: String = "Enter text",
        text: String = "",
        onTextChange: @escaping (String) -> Void = { _ in }
    ) -> CustomTextField {
        CustomTextField(configuration: CustomTextFieldConfiguration(
            label: label,
            placeholder: placeholder,
            text: text,
            style: .standard,
            onTextChange: onTextChange
        ))
    }
    
    /// Outlined text field style
    public static func outlined(
        label: String = "",
        placeholder: String = "Enter text",
        text: String = "",
        onTextChange: @escaping (String) -> Void = { _ in }
    ) -> CustomTextField {
        CustomTextField(configuration: CustomTextFieldConfiguration(
            label: label,
            placeholder: placeholder,
            text: text,
            style: .outlined,
            onTextChange: onTextChange
        ))
    }
    
    /// Filled text field style
    public static func filled(
        label: String = "",
        placeholder: String = "Enter text",
        text: String = "",
        onTextChange: @escaping (String) -> Void = { _ in }
    ) -> CustomTextField {
        CustomTextField(configuration: CustomTextFieldConfiguration(
            label: label,
            placeholder: placeholder,
            text: text,
            style: .filled,
            onTextChange: onTextChange
        ))
    }
}

// MARK: - Text Field Style

public enum CustomTextFieldStyle {
    case standard
    case outlined
    case filled
    case minimal
}

// MARK: - Configuration

public struct CustomTextFieldConfiguration: ComponentConfiguration {
    public let label: String
    public let placeholder: String
    public let text: String
    public let helperText: String
    public let errorMessage: String
    public let style: CustomTextFieldStyle
    
    // Appearance
    public let backgroundColor: Color
    public let focusedBackgroundColor: Color
    public let disabledBackgroundColor: Color
    public let textColor: Color
    public let labelColor: Color
    public let borderColor: Color
    public let focusedBorderColor: Color
    public let borderWidth: CGFloat
    public let focusedBorderWidth: CGFloat
    public let cornerRadius: CGFloat
    
    // Layout
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat
    public let labelSpacing: CGFloat
    public let iconSpacing: CGFloat
    
    // Typography
    public let fontSize: CGFloat
    public let fontWeight: Font.Weight
    public let labelFontSize: CGFloat
    public let labelFontWeight: Font.Weight
    
    // Icons
    public let leadingIcon: String?
    public let trailingIcon: String?
    public let iconSize: CGFloat
    public let iconColor: Color
    public let focusedIconColor: Color
    public let showClearButton: Bool
    
    // Behavior
    public let isRequired: Bool
    public let isDisabled: Bool
    public let maxCharacters: Int
    public let showCharacterCount: Bool
    public let validateOnChange: Bool
    public let validateOnBlur: Bool
    public let keyboardType: UIKeyboardType
    public let autocapitalization: TextInputAutocapitalization
    public let disableAutocorrection: Bool
    
    // Callbacks
    public let validator: (String) -> Bool
    public let onTextChange: (String) -> Void
    public let trailingAction: () -> Void
    
    public init(
        label: String = "",
        placeholder: String = "Enter text",
        text: String = "",
        helperText: String = "",
        errorMessage: String = "Invalid input",
        style: CustomTextFieldStyle = .standard,
        backgroundColor: Color? = nil,
        focusedBackgroundColor: Color? = nil,
        disabledBackgroundColor: Color? = nil,
        textColor: Color = .primary,
        labelColor: Color = .primary,
        borderColor: Color? = nil,
        focusedBorderColor: Color? = nil,
        borderWidth: CGFloat? = nil,
        focusedBorderWidth: CGFloat = 2,
        cornerRadius: CGFloat = 8,
        horizontalPadding: CGFloat = 16,
        verticalPadding: CGFloat = 12,
        labelSpacing: CGFloat = 8,
        iconSpacing: CGFloat = 12,
        fontSize: CGFloat = 16,
        fontWeight: Font.Weight = .regular,
        labelFontSize: CGFloat = 14,
        labelFontWeight: Font.Weight = .medium,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        iconSize: CGFloat = 16,
        iconColor: Color = .secondary,
        focusedIconColor: Color = .blue,
        showClearButton: Bool = true,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        maxCharacters: Int = 1000,
        showCharacterCount: Bool = false,
        validateOnChange: Bool = false,
        validateOnBlur: Bool = true,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: TextInputAutocapitalization = .sentences,
        disableAutocorrection: Bool = false,
        validator: @escaping (String) -> Bool = { _ in true },
        onTextChange: @escaping (String) -> Void = { _ in },
        trailingAction: @escaping () -> Void = {}
    ) {
        self.label = label
        self.placeholder = placeholder
        self.text = text
        self.helperText = helperText
        self.errorMessage = errorMessage
        self.style = style
        self.textColor = textColor
        self.labelColor = labelColor
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.labelSpacing = labelSpacing
        self.iconSpacing = iconSpacing
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.labelFontSize = labelFontSize
        self.labelFontWeight = labelFontWeight
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.iconSize = iconSize
        self.iconColor = iconColor
        self.focusedIconColor = focusedIconColor
        self.showClearButton = showClearButton
        self.isRequired = isRequired
        self.isDisabled = isDisabled
        self.maxCharacters = maxCharacters
        self.showCharacterCount = showCharacterCount
        self.validateOnChange = validateOnChange
        self.validateOnBlur = validateOnBlur
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
        self.disableAutocorrection = disableAutocorrection
        self.validator = validator
        self.onTextChange = onTextChange
        self.trailingAction = trailingAction
        
        // Apply style-based defaults
        switch style {
        case .standard:
            self.backgroundColor = backgroundColor ?? Color(.systemBackground)
            self.focusedBackgroundColor = focusedBackgroundColor ?? Color(.systemBackground)
            self.disabledBackgroundColor = disabledBackgroundColor ?? Color(.systemGray6)
            self.borderColor = borderColor ?? Color(.systemGray4)
            self.focusedBorderColor = focusedBorderColor ?? .blue
            self.borderWidth = borderWidth ?? 1
            self.focusedBorderWidth = focusedBorderWidth
            
        case .outlined:
            self.backgroundColor = backgroundColor ?? .clear
            self.focusedBackgroundColor = focusedBackgroundColor ?? .clear
            self.disabledBackgroundColor = disabledBackgroundColor ?? Color(.systemGray6)
            self.borderColor = borderColor ?? Color(.systemGray3)
            self.focusedBorderColor = focusedBorderColor ?? .blue
            self.borderWidth = borderWidth ?? 2
            self.focusedBorderWidth = focusedBorderWidth
            
        case .filled:
            self.backgroundColor = backgroundColor ?? Color(.systemGray6)
            self.focusedBackgroundColor = focusedBackgroundColor ?? Color(.systemGray5)
            self.disabledBackgroundColor = disabledBackgroundColor ?? Color(.systemGray6)
            self.borderColor = borderColor ?? .clear
            self.focusedBorderColor = focusedBorderColor ?? .blue
            self.borderWidth = borderWidth ?? 0
            self.focusedBorderWidth = focusedBorderWidth
            
        case .minimal:
            self.backgroundColor = backgroundColor ?? .clear
            self.focusedBackgroundColor = focusedBackgroundColor ?? .clear
            self.disabledBackgroundColor = disabledBackgroundColor ?? .clear
            self.borderColor = borderColor ?? .clear
            self.focusedBorderColor = focusedBorderColor ?? Color(.systemGray4)
            self.borderWidth = borderWidth ?? 0
            self.focusedBorderWidth = 1
        }
    }
    
    // MARK: - ComponentConfiguration
    
    public static var displayName: String { "Custom Text Field" }
    public static var category: ComponentCategory { .inputs }
    public static var minimumIOSVersion: String { "16.0" }
    public static var description: String { "Enhanced text field with validation, icons, and multiple styles" }
}

#Preview {
    ScrollView {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Text Field Styles")
                    .font(.headline)
                
                // Standard Style
                CustomTextField.standard(
                    label: "Standard Style",
                    placeholder: "Enter your name",
                    onTextChange: { text in
                        print("Standard text changed: \(text)")
                    }
                )
                
                // Outlined Style
                CustomTextField.outlined(
                    label: "Outlined Style",
                    placeholder: "Enter your email",
                    onTextChange: { text in
                        print("Outlined text changed: \(text)")
                    }
                )
                
                // Filled Style
                CustomTextField.filled(
                    label: "Filled Style",
                    placeholder: "Enter your message",
                    onTextChange: { text in
                        print("Filled text changed: \(text)")
                    }
                )
                
                // With Icons and Validation
                CustomTextField(configuration: CustomTextFieldConfiguration(
                    label: "Email Address",
                    placeholder: "user@example.com",
                    helperText: "Required",
                    errorMessage: "Please enter a valid email address",
                    style: .outlined,
                    leadingIcon: "envelope",
                    isRequired: true,
                    keyboardType: .emailAddress,
                    autocapitalization: .never,
                    disableAutocorrection: true,
                    validator: { text in
                        text.contains("@") && text.contains(".")
                    }
                ))
                
                // Password Field
                CustomTextField(configuration: CustomTextFieldConfiguration(
                    label: "Password",
                    placeholder: "Enter password",
                    style: .filled,
                    leadingIcon: "lock",
                    trailingIcon: "eye",
                    isRequired: true,
                    maxCharacters: 50,
                    showCharacterCount: true,
                    trailingAction: {
                        print("Toggle password visibility")
                    }
                ))
            }
        }
        .padding()
    }
} 