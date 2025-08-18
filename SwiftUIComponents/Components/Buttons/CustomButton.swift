import SwiftUI

// MARK: - Custom Button Component

public struct CustomButton: SwiftUIComponent {
    public let configuration: CustomButtonConfiguration
    
    public init(configuration: CustomButtonConfiguration) {
        self.configuration = configuration
    }
    
    public init() {
        self.configuration = CustomButtonConfiguration()
    }
    
    public var body: some View {
        Button(action: configuration.action) {
            HStack(spacing: configuration.iconSpacing) {
                if let systemImage = configuration.systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: configuration.iconSize))
                }
                
                if !configuration.title.isEmpty {
                    Text(configuration.title)
                        .font(.system(size: configuration.fontSize, weight: configuration.fontWeight))
                }
            }
            .foregroundStyle(configuration.foregroundColor)
            .padding(.horizontal, configuration.horizontalPadding)
            .padding(.vertical, configuration.verticalPadding)
        }
        .background(
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .foregroundStyle(configuration.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: configuration.cornerRadius)
                        .stroke(configuration.borderColor, lineWidth: configuration.borderWidth)
                )
        )
        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
        .disabled(configuration.isDisabled)
        .opacity(configuration.isDisabled ? 0.6 : 1.0)
    }
    
    // MARK: - Convenience Initializers
    
    /// Primary button style
    public static func primary(
        title: String,
        systemImage: String? = nil,
        action: @escaping () -> Void = {}
    ) -> CustomButton {
        CustomButton(configuration: CustomButtonConfiguration(
            title: title,
            systemImage: systemImage,
            backgroundColor: .blue,
            foregroundColor: .white,
            action: action
        ))
    }
    
    /// Secondary button style
    public static func secondary(
        title: String,
        systemImage: String? = nil,
        action: @escaping () -> Void = {}
    ) -> CustomButton {
        CustomButton(configuration: CustomButtonConfiguration(
            title: title,
            systemImage: systemImage,
            backgroundColor: .clear,
            foregroundColor: .blue,
            borderColor: .blue,
            borderWidth: 1,
            action: action
        ))
    }
    
    /// Destructive button style
    public static func destructive(
        title: String,
        systemImage: String? = nil,
        action: @escaping () -> Void = {}
    ) -> CustomButton {
        CustomButton(configuration: CustomButtonConfiguration(
            title: title,
            systemImage: systemImage,
            backgroundColor: .red,
            foregroundColor: .white,
            action: action
        ))
    }
}

// MARK: - Button Style

public enum CustomButtonStyle {
    case primary
    case secondary
    case destructive
    case custom
}

// MARK: - Configuration

public struct CustomButtonConfiguration: ComponentConfiguration {
    public let title: String
    public let systemImage: String?
    public let style: CustomButtonStyle
    public let backgroundColor: Color
    public let foregroundColor: Color
    public let borderColor: Color
    public let borderWidth: CGFloat
    public let cornerRadius: CGFloat
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat
    public let fontSize: CGFloat
    public let fontWeight: Font.Weight
    public let iconSize: CGFloat
    public let iconSpacing: CGFloat
    public let isPressed: Bool
    public let isDisabled: Bool
    public let action: () -> Void
    
    public init(
        title: String = "Button",
        systemImage: String? = nil,
        style: CustomButtonStyle = .primary,
        backgroundColor: Color? = nil,
        foregroundColor: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat? = nil,
        cornerRadius: CGFloat = 8,
        horizontalPadding: CGFloat = 16,
        verticalPadding: CGFloat = 12,
        fontSize: CGFloat = 16,
        fontWeight: Font.Weight = .medium,
        iconSize: CGFloat = 16,
        iconSpacing: CGFloat = 8,
        isPressed: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.systemImage = systemImage
        self.style = style
        
        // Apply style-based defaults
        switch style {
        case .primary:
            self.backgroundColor = backgroundColor ?? .blue
            self.foregroundColor = foregroundColor ?? .white
            self.borderColor = borderColor ?? .clear
            self.borderWidth = borderWidth ?? 0
        case .secondary:
            self.backgroundColor = backgroundColor ?? .clear
            self.foregroundColor = foregroundColor ?? .blue
            self.borderColor = borderColor ?? .blue
            self.borderWidth = borderWidth ?? 1
        case .destructive:
            self.backgroundColor = backgroundColor ?? .red
            self.foregroundColor = foregroundColor ?? .white
            self.borderColor = borderColor ?? .clear
            self.borderWidth = borderWidth ?? 0
        case .custom:
            self.backgroundColor = backgroundColor ?? .blue
            self.foregroundColor = foregroundColor ?? .white
            self.borderColor = borderColor ?? .clear
            self.borderWidth = borderWidth ?? 0
        }
        
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.iconSize = iconSize
        self.iconSpacing = iconSpacing
        self.isPressed = isPressed
        self.isDisabled = isDisabled
        self.action = action
    }
    
    // MARK: - ComponentConfiguration
    
    public static var displayName: String { "Custom Button" }
    public static var category: ComponentCategory { .buttons }
    public static var minimumIOSVersion: String { "16.0" }
    public static var description: String { "A customizable button with multiple styles and configurations" }
}

// MARK: - Preview

#Preview("Button Styles") {
    VStack(spacing: 16) {
        CustomButton.primary(title: "Primary Button", systemImage: "checkmark") {
            print("Primary tapped")
        }
        
        CustomButton.secondary(title: "Secondary Button", systemImage: "arrow.right") {
            print("Secondary tapped")
        }
        
        CustomButton.destructive(title: "Delete", systemImage: "trash") {
            print("Delete tapped")
        }
        
        CustomButton(configuration: CustomButtonConfiguration(
            title: "Custom Style",
            systemImage: "star.fill",
            backgroundColor: .purple,
            foregroundColor: .white,
            cornerRadius: 20,
            horizontalPadding: 24,
            verticalPadding: 16,
            action: {
                print("Custom tapped")
            }
        ))
    }
    .padding()
} 