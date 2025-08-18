import SwiftUI

// MARK: - Native iOS SecureField Showcase
// This component demonstrates native SwiftUI SecureField
// NO custom implementations - pure native Apple UI only

public struct NativeSecureFieldShowcase: SwiftUIComponent {
    public let configuration: NativeSecureFieldConfiguration
    @State private var text: String = ""
    @State private var isPasswordVisible: Bool = false
    @FocusState private var isFocused: Bool
    
    public init(configuration: NativeSecureFieldConfiguration) {
        self.configuration = configuration
        self._text = State(initialValue: configuration.text)
    }
    
    public init() {
        self.configuration = NativeSecureFieldConfiguration()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: configuration.spacing) {
            // Label
            if !configuration.label.isEmpty {
                Text(configuration.label)
                    .font(configuration.labelFont)
                    .foregroundStyle(configuration.labelColor)
            }
            
            // Native iOS SecureField
            secureFieldView
            
            // Helper Text
            if !configuration.helperText.isEmpty {
                Text(configuration.helperText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Password Strength Indicator (if enabled)
            if configuration.showPasswordStrength {
                passwordStrengthView
            }
        }
        .onChange(of: text) { oldValue, newValue in
            configuration.onTextChange?(newValue)
        }
    }
    
    @ViewBuilder
    private var secureFieldView: some View {
        switch configuration.style {
        case .standard:
            standardSecureField
        case .bordered:
            borderedSecureField
        case .backgrounded:
            backgroundedSecureField
        case .withVisibilityToggle:
            secureFieldWithToggle
        }
    }
    
    private var standardSecureField: some View {
        SecureField(configuration.placeholder, text: $text)
            .focused($isFocused)
            .font(configuration.textFont)
            .textFieldStyle(.plain)
    }
    
    private var borderedSecureField: some View {
        SecureField(configuration.placeholder, text: $text)
            .focused($isFocused)
            .font(configuration.textFont)
            .padding(12)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isFocused ? .blue : Color(.systemGray4), lineWidth: 1)
            )
    }
    
    private var backgroundedSecureField: some View {
        SecureField(configuration.placeholder, text: $text)
            .focused($isFocused)
            .font(configuration.textFont)
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var secureFieldWithToggle: some View {
        HStack {
            if isPasswordVisible {
                TextField(configuration.placeholder, text: $text)
                    .focused($isFocused)
                    .font(configuration.textFont)
            } else {
                SecureField(configuration.placeholder, text: $text)
                    .focused($isFocused)
                    .font(configuration.textFont)
            }
            
            Button(action: {
                isPasswordVisible.toggle()
            }) {
                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isFocused ? .blue : Color(.systemGray4), lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private var passwordStrengthView: some View {
        let strength = calculatePasswordStrength(text)
        
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Password Strength:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(strength.description)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(strength.color)
            }
            
            // Strength indicator bars
            HStack(spacing: 2) {
                ForEach(0..<4, id: \.self) { index in
                    Rectangle()
                        .fill(index < strength.level ? strength.color : Color(.systemGray5))
                        .frame(height: 3)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 1.5))
        }
    }
    
    private func calculatePasswordStrength(_ password: String) -> PasswordStrength {
        let length = password.count
        let hasLowercase = password.rangeOfCharacter(from: .lowercaseLetters) != nil
        let hasUppercase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasDigits = password.rangeOfCharacter(from: .decimalDigits) != nil
        let hasSpecialChars = password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:,.<>?")) != nil
        
        var score = 0
        if length >= 8 { score += 1 }
        if hasLowercase { score += 1 }
        if hasUppercase { score += 1 }
        if hasDigits { score += 1 }
        if hasSpecialChars { score += 1 }
        if length >= 12 { score += 1 }
        
        switch score {
        case 0...1: return PasswordStrength(level: 0, description: "Very Weak", color: .red)
        case 2...3: return PasswordStrength(level: 1, description: "Weak", color: .orange)
        case 4...5: return PasswordStrength(level: 2, description: "Good", color: .yellow)
        case 6: return PasswordStrength(level: 3, description: "Strong", color: .green)
        default: return PasswordStrength(level: 4, description: "Very Strong", color: .green)
        }
    }
}

private struct PasswordStrength {
    let level: Int
    let description: String
    let color: Color
}

// MARK: - Configuration

public struct NativeSecureFieldConfiguration: ComponentConfiguration {
    public let label: String
    public let text: String
    public let placeholder: String
    public let helperText: String
    public let style: NativeSecureFieldStyle
    public let showPasswordStrength: Bool
    public let spacing: CGFloat
    public let labelFont: Font
    public let labelColor: Color
    public let textFont: Font
    public let onTextChange: ((String) -> Void)?
    
    public init(
        label: String = "Password",
        text: String = "",
        placeholder: String = "Enter password",
        helperText: String = "",
        style: NativeSecureFieldStyle = .standard,
        showPasswordStrength: Bool = false,
        spacing: CGFloat = 8,
        labelFont: Font = .headline,
        labelColor: Color = .primary,
        textFont: Font = .body,
        onTextChange: ((String) -> Void)? = nil
    ) {
        self.label = label
        self.text = text
        self.placeholder = placeholder
        self.helperText = helperText
        self.style = style
        self.showPasswordStrength = showPasswordStrength
        self.spacing = spacing
        self.labelFont = labelFont
        self.labelColor = labelColor
        self.textFont = textFont
        self.onTextChange = onTextChange
    }
    
    // ComponentConfiguration requirements
    public static var displayName: String { "Native SecureField Showcase" }
    public static var category: ComponentCategory { .inputs }
    public static var minimumIOSVersion: String { "16.0" }
    public static var description: String { "Showcase of native iOS SecureField for password input" }
}

public enum NativeSecureFieldStyle: CaseIterable {
    case standard               // Standard SecureField
    case bordered              // SecureField with border
    case backgrounded          // SecureField with background
    case withVisibilityToggle  // SecureField with show/hide toggle
    
    public var displayName: String {
        switch self {
        case .standard: return "Standard"
        case .bordered: return "Bordered"
        case .backgrounded: return "Backgrounded"
        case .withVisibilityToggle: return "With Visibility Toggle"
        }
    }
    
    public var description: String {
        switch self {
        case .standard: return "Standard SecureField with plain styling"
        case .bordered: return "SecureField with focus-aware border"
        case .backgrounded: return "SecureField with colored background"
        case .withVisibilityToggle: return "SecureField with show/hide password toggle"
        }
    }
}

// MARK: - Convenience Methods

extension NativeSecureFieldShowcase {
    public static func standard(
        label: String,
        placeholder: String = "Enter password"
    ) -> NativeSecureFieldShowcase {
        NativeSecureFieldShowcase(configuration: NativeSecureFieldConfiguration(
            label: label,
            placeholder: placeholder,
            style: .standard
        ))
    }
    
    public static func bordered(
        label: String,
        placeholder: String = "Enter password"
    ) -> NativeSecureFieldShowcase {
        NativeSecureFieldShowcase(configuration: NativeSecureFieldConfiguration(
            label: label,
            placeholder: placeholder,
            style: .bordered
        ))
    }
    
    public static func withVisibilityToggle(
        label: String,
        placeholder: String = "Enter password"
    ) -> NativeSecureFieldShowcase {
        NativeSecureFieldShowcase(configuration: NativeSecureFieldConfiguration(
            label: label,
            placeholder: placeholder,
            style: .withVisibilityToggle
        ))
    }
    
    public static func withPasswordStrength(
        label: String,
        placeholder: String = "Create password"
    ) -> NativeSecureFieldShowcase {
        NativeSecureFieldShowcase(configuration: NativeSecureFieldConfiguration(
            label: label,
            placeholder: placeholder,
            helperText: "Use 8+ characters with mix of letters, numbers & symbols",
            style: .bordered,
            showPasswordStrength: true
        ))
    }
}

// MARK: - SwiftUI Preview

#Preview("Native SecureField Showcase") {
    NavigationStack {
        ScrollView {
            VStack(spacing: 24) {
                // Standard SecureField
                VStack(alignment: .leading, spacing: 8) {
                    Text("Standard Style")
                        .font(.headline)
                    NativeSecureFieldShowcase.standard(
                        label: "Password",
                        placeholder: "Enter your password"
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Bordered SecureField
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bordered Style")
                        .font(.headline)
                    NativeSecureFieldShowcase.bordered(
                        label: "Current Password",
                        placeholder: "Enter current password"
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // With Visibility Toggle
                VStack(alignment: .leading, spacing: 8) {
                    Text("With Visibility Toggle")
                        .font(.headline)
                    NativeSecureFieldShowcase.withVisibilityToggle(
                        label: "New Password",
                        placeholder: "Create new password"
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // With Password Strength
                VStack(alignment: .leading, spacing: 8) {
                    Text("With Password Strength")
                        .font(.headline)
                    NativeSecureFieldShowcase.withPasswordStrength(
                        label: "Create Password",
                        placeholder: "Enter a strong password"
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle("Native SecureField Styles")
    }
} 