import SwiftUI

// MARK: - Badge Component

public struct Badge: SwiftUIComponent {
    public let configuration: BadgeConfiguration
    
    public init(configuration: BadgeConfiguration) {
        self.configuration = configuration
    }
    
    public init() {
        self.configuration = BadgeConfiguration()
    }
    
    public var body: some View {
        badgeView
    }
    
    @ViewBuilder
    private var badgeView: some View {
        switch configuration.style {
        case .filled:
            filledBadge
        case .outlined:
            outlinedBadge
        case .dot:
            dotBadge
        case .minimal:
            minimalBadge
        }
    }
    
    private var filledBadge: some View {
        HStack(spacing: configuration.contentSpacing) {
            if let icon = configuration.icon {
                Image(systemName: icon)
                    .font(configuration.iconFont)
                    .foregroundStyle(configuration.textColor)
            }
            
            if !configuration.text.isEmpty {
                Text(configuration.text)
                    .font(configuration.textFont)
                    .foregroundStyle(configuration.textColor)
            }
        }
        .padding(.horizontal, configuration.horizontalPadding)
        .padding(.vertical, configuration.verticalPadding)
        .background(configuration.backgroundColor)
        .clipShape(
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
        )
    }
    
    private var outlinedBadge: some View {
        HStack(spacing: configuration.contentSpacing) {
            if let icon = configuration.icon {
                Image(systemName: icon)
                    .font(configuration.iconFont)
                    .foregroundStyle(configuration.borderColor)
            }
            
            if !configuration.text.isEmpty {
                Text(configuration.text)
                    .font(configuration.textFont)
                    .foregroundStyle(configuration.borderColor)
            }
        }
        .padding(.horizontal, configuration.horizontalPadding)
        .padding(.vertical, configuration.verticalPadding)
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .stroke(configuration.borderColor, lineWidth: configuration.borderWidth)
        )
    }
    
    private var dotBadge: some View {
        Circle()
            .fill(configuration.backgroundColor)
            .frame(width: configuration.dotSize, height: configuration.dotSize)
    }
    
    private var minimalBadge: some View {
        HStack(spacing: configuration.contentSpacing) {
            if let icon = configuration.icon {
                Image(systemName: icon)
                    .font(configuration.iconFont)
                    .foregroundStyle(configuration.backgroundColor)
            }
            
            if !configuration.text.isEmpty {
                Text(configuration.text)
                    .font(configuration.textFont)
                    .foregroundStyle(configuration.backgroundColor)
            }
        }
        .padding(.horizontal, configuration.horizontalPadding)
        .padding(.vertical, configuration.verticalPadding)
        .background(configuration.backgroundColor.opacity(0.1))
        .clipShape(
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
        )
    }
}

// MARK: - Configuration

public struct BadgeConfiguration: ComponentConfiguration {
    public static let displayName = "Badge"
    public static let category = ComponentCategory.feedback
    public static let minimumIOSVersion = "16.0"
    public static let description = "Small status indicators and counters"
    
    // Content
    public let text: String
    public let icon: String?
    
    // Style
    public let style: BadgeStyle
    public let size: BadgeSize
    
    // Layout
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat
    public let contentSpacing: CGFloat
    public let cornerRadius: CGFloat
    public let dotSize: CGFloat
    public let borderWidth: CGFloat
    
    // Colors
    public let backgroundColor: Color
    public let textColor: Color
    public let borderColor: Color
    
    // Typography
    public let textFont: Font
    public let iconFont: Font
    
    public init(
        text: String = "",
        icon: String? = nil,
        style: BadgeStyle = .filled,
        size: BadgeSize = .medium,
        horizontalPadding: CGFloat = 8,
        verticalPadding: CGFloat = 4,
        contentSpacing: CGFloat = 4,
        cornerRadius: CGFloat = 12,
        dotSize: CGFloat = 8,
        borderWidth: CGFloat = 1,
        backgroundColor: Color = .blue,
        textColor: Color = .white,
        borderColor: Color = .blue,
        textFont: Font = .caption,
        iconFont: Font = .caption
    ) {
        self.text = text
        self.icon = icon
        self.style = style
        self.size = size
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.contentSpacing = contentSpacing
        self.cornerRadius = cornerRadius
        self.dotSize = dotSize
        self.borderWidth = borderWidth
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.borderColor = borderColor
        self.textFont = textFont
        self.iconFont = iconFont
    }
}

public enum BadgeStyle: CaseIterable {
    case filled
    case outlined
    case dot
    case minimal
}

public enum BadgeSize: CaseIterable {
    case small
    case medium
    case large
    
    var textFont: Font {
        switch self {
        case .small: return .caption2
        case .medium: return .caption
        case .large: return .footnote
        }
    }
    
    var iconFont: Font {
        switch self {
        case .small: return .caption2
        case .medium: return .caption
        case .large: return .footnote
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 8
        case .large: return 10
        }
    }
    
    var verticalPadding: CGFloat {
        switch self {
        case .small: return 2
        case .medium: return 4
        case .large: return 6
        }
    }
    
    var dotSize: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 8
        case .large: return 10
        }
    }
}

// MARK: - Convenience Initializers

extension Badge {
    public static func success(
        text: String,
        size: BadgeSize = .medium
    ) -> Badge {
        Badge(configuration: BadgeConfiguration(
            text: text,
            icon: "checkmark",
            style: .filled,
            size: size,
            backgroundColor: .green,
            textColor: .white,
            textFont: size.textFont,
            iconFont: size.iconFont
        ))
    }
    
    public static func error(
        text: String,
        size: BadgeSize = .medium
    ) -> Badge {
        Badge(configuration: BadgeConfiguration(
            text: text,
            icon: "xmark",
            style: .filled,
            size: size,
            backgroundColor: .red,
            textColor: .white,
            textFont: size.textFont,
            iconFont: size.iconFont
        ))
    }
    
    public static func warning(
        text: String,
        size: BadgeSize = .medium
    ) -> Badge {
        Badge(configuration: BadgeConfiguration(
            text: text,
            icon: "exclamationmark",
            style: .filled,
            size: size,
            backgroundColor: .orange,
            textColor: .white,
            textFont: size.textFont,
            iconFont: size.iconFont
        ))
    }
    
    public static func info(
        text: String,
        size: BadgeSize = .medium
    ) -> Badge {
        Badge(configuration: BadgeConfiguration(
            text: text,
            icon: "info",
            style: .filled,
            size: size,
            backgroundColor: .blue,
            textColor: .white,
            textFont: size.textFont,
            iconFont: size.iconFont
        ))
    }
    
    public static func count(
        _ count: Int,
        size: BadgeSize = .medium
    ) -> Badge {
        Badge(configuration: BadgeConfiguration(
            text: "\(count)",
            style: .filled,
            size: size,
            cornerRadius: size == .small ? 8 : (size == .medium ? 10 : 12),
            backgroundColor: .red,
            textColor: .white,
            textFont: size.textFont
        ))
    }
    
    public static func dot(
        color: Color = .red,
        size: BadgeSize = .medium
    ) -> Badge {
        Badge(configuration: BadgeConfiguration(
            style: .dot,
            size: size,
            dotSize: size.dotSize,
            backgroundColor: color
        ))
    }
    
    public static func outlined(
        text: String,
        color: Color = .blue,
        size: BadgeSize = .medium
    ) -> Badge {
        Badge(configuration: BadgeConfiguration(
            text: text,
            style: .outlined,
            size: size,
            horizontalPadding: size.horizontalPadding,
            verticalPadding: size.verticalPadding,
            borderColor: color,
            textFont: size.textFont
        ))
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        // Success Badges
        HStack(spacing: 12) {
            Badge.success(text: "Success", size: .small)
            Badge.success(text: "Success", size: .medium)
            Badge.success(text: "Success", size: .large)
        }
        
        // Error Badges
        HStack(spacing: 12) {
            Badge.error(text: "Error", size: .small)
            Badge.error(text: "Error", size: .medium)
            Badge.error(text: "Error", size: .large)
        }
        
        // Count Badges
        HStack(spacing: 12) {
            Badge.count(3, size: .small)
            Badge.count(15, size: .medium)
            Badge.count(99, size: .large)
        }
        
        // Dot Badges
        HStack(spacing: 12) {
            Badge.dot(color: .red, size: .small)
            Badge.dot(color: .green, size: .medium)
            Badge.dot(color: .blue, size: .large)
        }
        
        // Outlined Badges
        HStack(spacing: 12) {
            Badge.outlined(text: "Outlined", color: .purple, size: .small)
            Badge.outlined(text: "Outlined", color: .purple, size: .medium)
            Badge.outlined(text: "Outlined", color: .purple, size: .large)
        }
        
        Spacer()
    }
    .padding()
} 