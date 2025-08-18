import SwiftUI

// MARK: - Toast Component

public struct Toast: SwiftUIComponent {
    public let configuration: ToastConfiguration
    @State private var isPresented = false
    @State private var offsetY: CGFloat = -100
    @State private var opacity: Double = 0
    
    public init(configuration: ToastConfiguration) {
        self.configuration = configuration
    }
    
    public init() {
        self.configuration = ToastConfiguration()
    }
    
    public var body: some View {
        if isPresented {
            toastView
                .offset(y: offsetY)
                .opacity(opacity)
                .onAppear {
                    showToast()
                }
                .onTapGesture {
                    if configuration.dismissOnTap {
                        hideToast()
                    }
                }
        }
    }
    
    @ViewBuilder
    private var toastView: some View {
        switch configuration.style {
        case .standard:
            standardToast
        case .success:
            successToast
        case .error:
            errorToast
        case .warning:
            warningToast
        case .info:
            infoToast
        }
    }
    
    private var standardToast: some View {
        HStack(spacing: configuration.contentSpacing) {
            if let icon = configuration.icon {
                Image(systemName: icon)
                    .font(configuration.iconFont)
                    .foregroundStyle(configuration.iconColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if !configuration.title.isEmpty {
                    Text(configuration.title)
                        .font(configuration.titleFont)
                        .foregroundStyle(configuration.titleColor)
                }
                
                if !configuration.message.isEmpty {
                    Text(configuration.message)
                        .font(configuration.messageFont)
                        .foregroundStyle(configuration.messageColor)
                }
            }
            
            Spacer()
            
            if configuration.showCloseButton {
                Button(action: hideToast) {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundStyle(configuration.closeButtonColor)
                }
            }
        }
        .padding(configuration.padding)
        .background(configuration.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
        .shadow(
            color: configuration.shadowColor,
            radius: configuration.shadowRadius,
            x: configuration.shadowOffset.width,
            y: configuration.shadowOffset.height
        )
    }
    
    private var successToast: some View {
        standardToast
            .overlay(
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .stroke(.green, lineWidth: 2)
            )
    }
    
    private var errorToast: some View {
        standardToast
            .overlay(
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .stroke(.red, lineWidth: 2)
            )
    }
    
    private var warningToast: some View {
        standardToast
            .overlay(
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .stroke(.orange, lineWidth: 2)
            )
    }
    
    private var infoToast: some View {
        standardToast
            .overlay(
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .stroke(.blue, lineWidth: 2)
            )
    }
    
    private func showToast() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            offsetY = configuration.position == .top ? 20 : -20
            opacity = 1
        }
        
        if configuration.autoDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + configuration.duration) {
                hideToast()
            }
        }
    }
    
    private func hideToast() {
        withAnimation(.easeInOut(duration: 0.3)) {
            offsetY = configuration.position == .top ? -100 : 100
            opacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresented = false
            configuration.onDismiss?()
        }
    }
    
    public func present() {
        isPresented = true
    }
    
    public func dismiss() {
        hideToast()
    }
}

// MARK: - Configuration

public struct ToastConfiguration: ComponentConfiguration {
    public static let displayName = "Toast"
    public static let category = ComponentCategory.feedback
    public static let minimumIOSVersion = "16.0"
    public static let description = "Temporary notification messages"
    
    // Content
    public let title: String
    public let message: String
    public let icon: String?
    
    // Style
    public let style: ToastStyle
    public let position: ToastPosition
    
    // Layout
    public let padding: EdgeInsets
    public let contentSpacing: CGFloat
    public let cornerRadius: CGFloat
    
    // Colors
    public let backgroundColor: Color
    public let titleColor: Color
    public let messageColor: Color
    public let iconColor: Color
    public let closeButtonColor: Color
    public let shadowColor: Color
    
    // Typography
    public let titleFont: Font
    public let messageFont: Font
    public let iconFont: Font
    
    // Shadow
    public let shadowRadius: CGFloat
    public let shadowOffset: CGSize
    
    // Behavior
    public let duration: TimeInterval
    public let autoDismiss: Bool
    public let dismissOnTap: Bool
    public let showCloseButton: Bool
    public let onDismiss: (() -> Void)?
    
    public init(
        title: String = "",
        message: String = "Toast message",
        icon: String? = nil,
        style: ToastStyle = .standard,
        position: ToastPosition = .top,
        padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        contentSpacing: CGFloat = 12,
        cornerRadius: CGFloat = 12,
        backgroundColor: Color = Color(.systemBackground),
        titleColor: Color = .primary,
        messageColor: Color = .secondary,
        iconColor: Color = .blue,
        closeButtonColor: Color = .secondary,
        shadowColor: Color = .black.opacity(0.1),
        titleFont: Font = .headline,
        messageFont: Font = .body,
        iconFont: Font = .title2,
        shadowRadius: CGFloat = 8,
        shadowOffset: CGSize = CGSize(width: 0, height: 4),
        duration: TimeInterval = 3.0,
        autoDismiss: Bool = true,
        dismissOnTap: Bool = true,
        showCloseButton: Bool = false,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.style = style
        self.position = position
        self.padding = padding
        self.contentSpacing = contentSpacing
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.messageColor = messageColor
        self.iconColor = iconColor
        self.closeButtonColor = closeButtonColor
        self.shadowColor = shadowColor
        self.titleFont = titleFont
        self.messageFont = messageFont
        self.iconFont = iconFont
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.duration = duration
        self.autoDismiss = autoDismiss
        self.dismissOnTap = dismissOnTap
        self.showCloseButton = showCloseButton
        self.onDismiss = onDismiss
    }
}

public enum ToastStyle: CaseIterable {
    case standard
    case success
    case error
    case warning
    case info
}

public enum ToastPosition: CaseIterable {
    case top
    case bottom
}

// MARK: - Convenience Initializers

extension Toast {
    public static func success(
        title: String = "Success",
        message: String,
        duration: TimeInterval = 3.0
    ) -> Toast {
        Toast(configuration: ToastConfiguration(
            title: title,
            message: message,
            icon: "checkmark.circle.fill",
            style: .success,
            iconColor: .green,
            duration: duration
        ))
    }
    
    public static func error(
        title: String = "Error",
        message: String,
        duration: TimeInterval = 4.0
    ) -> Toast {
        Toast(configuration: ToastConfiguration(
            title: title,
            message: message,
            icon: "xmark.circle.fill",
            style: .error,
            iconColor: .red,
            duration: duration
        ))
    }
    
    public static func warning(
        title: String = "Warning",
        message: String,
        duration: TimeInterval = 3.5
    ) -> Toast {
        Toast(configuration: ToastConfiguration(
            title: title,
            message: message,
            icon: "exclamationmark.triangle.fill",
            style: .warning,
            iconColor: .orange,
            duration: duration
        ))
    }
    
    public static func info(
        title: String = "Info",
        message: String,
        duration: TimeInterval = 3.0
    ) -> Toast {
        Toast(configuration: ToastConfiguration(
            title: title,
            message: message,
            icon: "info.circle.fill",
            style: .info,
            iconColor: .blue,
            duration: duration
        ))
    }
    
    public static func standard(
        message: String,
        duration: TimeInterval = 3.0
    ) -> Toast {
        Toast(configuration: ToastConfiguration(
            message: message,
            duration: duration
        ))
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        // Success Toast
        Toast.success(
            title: "Success",
            message: "Your action was completed successfully!"
        )
        
        // Error Toast
        Toast.error(
            title: "Error",
            message: "Something went wrong. Please try again."
        )
        
        // Warning Toast
        Toast.warning(
            title: "Warning",
            message: "Please check your internet connection."
        )
        
        // Info Toast
        Toast.info(
            title: "Info",
            message: "New features are now available!"
        )
        
        // Standard Toast
        Toast.standard(
            message: "This is a standard toast message."
        )
        
        Spacer()
    }
    .padding()
} 