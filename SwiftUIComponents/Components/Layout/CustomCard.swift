import SwiftUI

// MARK: - Custom Card Component

public struct CustomCard<Content: View>: View {
    public let configuration: CustomCardConfiguration
    public let content: Content
    
    public init(configuration: CustomCardConfiguration, @ViewBuilder content: () -> Content) {
        self.configuration = configuration
        self.content = content()
    }
    
    public var body: some View {
        VStack(alignment: configuration.alignment, spacing: configuration.contentSpacing) {
            // Header
            if !configuration.title.isEmpty || !configuration.subtitle.isEmpty {
                headerView
            }
            
            // Content
            content
            
            // Footer
            if let footerAction = configuration.footerAction {
                footerView(action: footerAction)
            }
        }
        .padding(configuration.padding)
        .background(backgroundView)
        .overlay(borderView)
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
        .shadow(
            color: configuration.shadowColor.opacity(configuration.shadowOpacity),
            radius: configuration.shadowRadius,
            x: configuration.shadowOffset.width,
            y: configuration.shadowOffset.height
        )
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
    
    @ViewBuilder
    private var headerView: some View {
        VStack(alignment: configuration.alignment, spacing: 4) {
            if !configuration.title.isEmpty {
                HStack {
                    Text(configuration.title)
                        .font(configuration.titleFont)
                        .foregroundStyle(configuration.titleColor)
                    
                    Spacer()
                    
                    if let headerIcon = configuration.headerIcon {
                        Image(systemName: headerIcon)
                            .foregroundStyle(configuration.accentColor)
                            .font(.title3)
                    }
                }
            }
            
            if !configuration.subtitle.isEmpty {
                HStack {
                    Text(configuration.subtitle)
                        .font(configuration.subtitleFont)
                        .foregroundStyle(configuration.subtitleColor)
                    
                    Spacer()
                }
            }
        }
        .padding(.bottom, configuration.headerSpacing)
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch configuration.style {
        case .elevated:
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .fill(configuration.backgroundColor)
        case .outlined:
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .fill(configuration.backgroundColor)
        case .filled:
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .fill(configuration.backgroundColor)
        case .minimal:
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .fill(Color.clear)
        }
    }
    
    @ViewBuilder
    private var borderView: some View {
        if configuration.style == .outlined {
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .stroke(configuration.borderColor, lineWidth: configuration.borderWidth)
        }
    }
    
    @ViewBuilder
    private func footerView(action: CustomCardConfiguration.FooterAction) -> some View {
        HStack {
            Spacer()
            
            Button(action: action.action) {
                HStack(spacing: 6) {
                    if let icon = action.icon {
                        Image(systemName: icon)
                            .font(.caption)
                    }
                    Text(action.title)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundStyle(configuration.accentColor)
            }
        }
        .padding(.top, configuration.footerSpacing)
    }
}

// MARK: - Configuration

public struct CustomCardConfiguration {
    public let title: String
    public let subtitle: String
    public let style: CustomCardStyle
    public let backgroundColor: Color
    public let borderColor: Color
    public let borderWidth: CGFloat
    public let cornerRadius: CGFloat
    public let padding: EdgeInsets
    public let shadowColor: Color
    public let shadowRadius: CGFloat
    public let shadowOffset: CGSize
    public let shadowOpacity: Double
    public let titleFont: Font
    public let subtitleFont: Font
    public let titleColor: Color
    public let subtitleColor: Color
    public let accentColor: Color
    public let alignment: HorizontalAlignment
    public let contentSpacing: CGFloat
    public let headerSpacing: CGFloat
    public let footerSpacing: CGFloat
    public let headerIcon: String?
    public let footerAction: FooterAction?
    public let isPressed: Bool
    
    public struct FooterAction {
        public let title: String
        public let icon: String?
        public let action: () -> Void
        
        public init(title: String, icon: String? = nil, action: @escaping () -> Void) {
            self.title = title
            self.icon = icon
            self.action = action
        }
    }
    
    public init(
        title: String = "",
        subtitle: String = "",
        style: CustomCardStyle = .elevated,
        backgroundColor: Color = Color(.systemBackground),
        borderColor: Color = Color(.separator),
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = 12,
        padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        shadowColor: Color = .black,
        shadowRadius: CGFloat = 8,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        shadowOpacity: Double = 0.1,
        titleFont: Font = .headline,
        subtitleFont: Font = .subheadline,
        titleColor: Color = .primary,
        subtitleColor: Color = .secondary,
        accentColor: Color = .blue,
        alignment: HorizontalAlignment = .leading,
        contentSpacing: CGFloat = 12,
        headerSpacing: CGFloat = 8,
        footerSpacing: CGFloat = 8,
        headerIcon: String? = nil,
        footerAction: FooterAction? = nil,
        isPressed: Bool = false
    ) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.shadowOpacity = shadowOpacity
        self.titleFont = titleFont
        self.subtitleFont = subtitleFont
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.accentColor = accentColor
        self.alignment = alignment
        self.contentSpacing = contentSpacing
        self.headerSpacing = headerSpacing
        self.footerSpacing = footerSpacing
        self.headerIcon = headerIcon
        self.footerAction = footerAction
        self.isPressed = isPressed
    }
}

public enum CustomCardStyle: CaseIterable {
    case elevated
    case outlined
    case filled
    case minimal
}



// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        // Simple Card
        CustomCard(
            configuration: CustomCardConfiguration(
                title: "Simple Card",
                style: .elevated
            )
        ) {
            Text("This is a simple card with basic content.")
                .padding(.vertical, 8)
        }
        
        // Outlined Card
        CustomCard(
            configuration: CustomCardConfiguration(
                title: "Project Update",
                subtitle: "Development Progress",
                style: .outlined
            )
        ) {
            VStack(alignment: .leading, spacing: 8) {
                Text("The new feature is 80% complete.")
                ProgressView(value: 0.8)
                    .tint(.blue)
            }
        }
        
        Spacer()
    }
    .padding()
} 