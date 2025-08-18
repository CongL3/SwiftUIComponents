import SwiftUI

// MARK: - Custom Tab Bar Component

public struct CustomTabBar: SwiftUIComponent {
    public let configuration: CustomTabBarConfiguration
    @State private var selectedIndex: Int = 0
    
    public init(configuration: CustomTabBarConfiguration) {
        self.configuration = configuration
        self._selectedIndex = State(initialValue: configuration.selectedIndex)
    }
    
    public init() {
        self.configuration = CustomTabBarConfiguration()
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Tab Bar
            tabBarView
            
            // Content View
            if configuration.showContent {
                contentView
            }
        }
        .disabled(configuration.isDisabled)
        .opacity(configuration.isDisabled ? 0.6 : 1.0)
    }
    
    @ViewBuilder
    private var tabBarView: some View {
        switch configuration.style {
        case .segmented:
            segmentedTabBar
        case .floating:
            floatingTabBar
        case .minimal:
            minimalTabBar
        case .pills:
            pillsTabBar
        }
    }
    
    // MARK: - Segmented Style (Default)
    
    private var segmentedTabBar: some View {
        HStack(spacing: 0) {
            ForEach(Array(configuration.tabs.enumerated()), id: \.offset) { index, tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        selectedIndex = index
                        configuration.onTabChange(index)
                    }
                }) {
                    tabContent(tab: tab, index: index, isSelected: selectedIndex == index)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, configuration.verticalPadding)
                        .background(
                            selectedIndex == index ? 
                            configuration.selectedBackgroundColor : 
                            Color.clear
                        )
                        .foregroundStyle(
                            selectedIndex == index ? 
                            configuration.selectedTextColor : 
                            configuration.textColor
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(configuration.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .stroke(configuration.borderColor, lineWidth: configuration.borderWidth)
        )
        .padding(.horizontal, configuration.horizontalPadding)
        .padding(.bottom, configuration.bottomPadding)
    }
    
    // MARK: - Floating Style
    
    private var floatingTabBar: some View {
        HStack(spacing: configuration.tabSpacing) {
            ForEach(Array(configuration.tabs.enumerated()), id: \.offset) { index, tab in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedIndex = index
                        configuration.onTabChange(index)
                    }
                }) {
                    tabContent(tab: tab, index: index, isSelected: selectedIndex == index)
                        .padding(.horizontal, configuration.tabHorizontalPadding)
                        .padding(.vertical, configuration.verticalPadding)
                        .background(
                            selectedIndex == index ? 
                            configuration.selectedBackgroundColor : 
                            configuration.backgroundColor
                        )
                        .foregroundStyle(
                            selectedIndex == index ? 
                            configuration.selectedTextColor : 
                            configuration.textColor
                        )
                        .clipShape(Capsule())
                        .shadow(
                            color: selectedIndex == index ? configuration.shadowColor : Color.clear,
                            radius: configuration.shadowRadius,
                            x: 0, y: configuration.shadowOffset.height
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, configuration.horizontalPadding)
        .padding(.bottom, configuration.bottomPadding)
    }
    
    // MARK: - Minimal Style
    
    private var minimalTabBar: some View {
        VStack(spacing: 0) {
            HStack(spacing: configuration.tabSpacing) {
                ForEach(Array(configuration.tabs.enumerated()), id: \.offset) { index, tab in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedIndex = index
                            configuration.onTabChange(index)
                        }
                    }) {
                        tabContent(tab: tab, index: index, isSelected: selectedIndex == index)
                            .padding(.vertical, configuration.verticalPadding)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(
                                selectedIndex == index ? 
                                configuration.selectedTextColor : 
                                configuration.textColor
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, configuration.horizontalPadding)
            
            // Underline indicator
            HStack(spacing: configuration.tabSpacing) {
                ForEach(Array(configuration.tabs.enumerated()), id: \.offset) { index, _ in
                    Rectangle()
                        .fill(selectedIndex == index ? configuration.selectedBackgroundColor : Color.clear)
                        .frame(height: configuration.underlineHeight)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, configuration.horizontalPadding)
            .padding(.bottom, configuration.bottomPadding)
        }
    }
    
    // MARK: - Pills Style
    
    private var pillsTabBar: some View {
        HStack(spacing: configuration.tabSpacing) {
            ForEach(Array(configuration.tabs.enumerated()), id: \.offset) { index, tab in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedIndex = index
                        configuration.onTabChange(index)
                    }
                }) {
                    tabContent(tab: tab, index: index, isSelected: selectedIndex == index)
                        .padding(.horizontal, configuration.tabHorizontalPadding)
                        .padding(.vertical, configuration.verticalPadding)
                        .background(
                            selectedIndex == index ? 
                            configuration.selectedBackgroundColor : 
                            configuration.backgroundColor
                        )
                        .foregroundStyle(
                            selectedIndex == index ? 
                            configuration.selectedTextColor : 
                            configuration.textColor
                        )
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(
                                    selectedIndex == index ? 
                                    configuration.selectedBorderColor : 
                                    configuration.borderColor, 
                                    lineWidth: configuration.borderWidth
                                )
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, configuration.horizontalPadding)
        .padding(.bottom, configuration.bottomPadding)
    }
    
    // MARK: - Tab Content
    
    @ViewBuilder
    private func tabContent(tab: TabItem, index: Int, isSelected: Bool) -> some View {
        VStack(spacing: configuration.iconTextSpacing) {
            // Icon
            if let icon = tab.icon {
                Image(systemName: icon)
                    .font(.system(size: configuration.iconSize, weight: isSelected ? .semibold : .regular))
                    .symbolEffect(.bounce, value: isSelected)
            }
            
            // Text
            if configuration.showLabels {
                Text(tab.title)
                    .font(.system(size: configuration.fontSize, weight: isSelected ? .semibold : .regular))
                    .lineLimit(1)
            }
            
            // Badge
            if let badge = tab.badge, badge > 0 {
                Text("\(badge)")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(configuration.badgeColor)
                    .clipShape(Capsule())
                    .offset(x: configuration.showLabels ? 0 : 8, y: configuration.showLabels ? -4 : -8)
            }
        }
    }
    
    // MARK: - Content View
    
    @ViewBuilder
    private var contentView: some View {
        if selectedIndex < configuration.tabs.count {
            let tab = configuration.tabs[selectedIndex]
            if let content = tab.content {
                content
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            } else {
                Text("Content for \(tab.title)")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
            }
        }
    }
    
    // MARK: - Convenience Initializers
    
    /// Segmented tab bar style
    public static func segmented(
        tabs: [String],
        selectedIndex: Int = 0,
        onTabChange: @escaping (Int) -> Void = { _ in }
    ) -> CustomTabBar {
        CustomTabBar(configuration: CustomTabBarConfiguration(
            tabs: tabs.map { TabItem(title: $0) },
            selectedIndex: selectedIndex,
            style: .segmented,
            onTabChange: onTabChange
        ))
    }
    
    /// Floating tab bar style
    public static func floating(
        tabs: [String],
        selectedIndex: Int = 0,
        onTabChange: @escaping (Int) -> Void = { _ in }
    ) -> CustomTabBar {
        CustomTabBar(configuration: CustomTabBarConfiguration(
            tabs: tabs.map { TabItem(title: $0) },
            selectedIndex: selectedIndex,
            style: .floating,
            onTabChange: onTabChange
        ))
    }
    
    /// Minimal tab bar style
    public static func minimal(
        tabs: [String],
        selectedIndex: Int = 0,
        onTabChange: @escaping (Int) -> Void = { _ in }
    ) -> CustomTabBar {
        CustomTabBar(configuration: CustomTabBarConfiguration(
            tabs: tabs.map { TabItem(title: $0) },
            selectedIndex: selectedIndex,
            style: .minimal,
            onTabChange: onTabChange
        ))
    }
    
    /// Pills tab bar style
    public static func pills(
        tabs: [String],
        selectedIndex: Int = 0,
        onTabChange: @escaping (Int) -> Void = { _ in }
    ) -> CustomTabBar {
        CustomTabBar(configuration: CustomTabBarConfiguration(
            tabs: tabs.map { TabItem(title: $0) },
            selectedIndex: selectedIndex,
            style: .pills,
            onTabChange: onTabChange
        ))
    }
}

// MARK: - Tab Item

public struct TabItem {
    public let title: String
    public let icon: String?
    public let badge: Int?
    public let content: AnyView?
    
    public init(title: String, icon: String? = nil, badge: Int? = nil, content: AnyView? = nil) {
        self.title = title
        self.icon = icon
        self.badge = badge
        self.content = content
    }
    
    public init<Content: View>(title: String, icon: String? = nil, badge: Int? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.badge = badge
        self.content = AnyView(content())
    }
}

// MARK: - Tab Bar Style

public enum CustomTabBarStyle {
    case segmented
    case floating
    case minimal
    case pills
}

// MARK: - Configuration

public struct CustomTabBarConfiguration: ComponentConfiguration {
    public let tabs: [TabItem]
    public let selectedIndex: Int
    public let style: CustomTabBarStyle
    public let showLabels: Bool
    public let showContent: Bool
    
    // Appearance
    public let backgroundColor: Color
    public let selectedBackgroundColor: Color
    public let textColor: Color
    public let selectedTextColor: Color
    public let borderColor: Color
    public let selectedBorderColor: Color
    public let badgeColor: Color
    public let shadowColor: Color
    public let borderWidth: CGFloat
    public let cornerRadius: CGFloat
    public let underlineHeight: CGFloat
    public let shadowRadius: CGFloat
    public let shadowOffset: CGSize
    
    // Layout
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat
    public let bottomPadding: CGFloat
    public let tabSpacing: CGFloat
    public let tabHorizontalPadding: CGFloat
    public let iconTextSpacing: CGFloat
    
    // Typography
    public let fontSize: CGFloat
    public let iconSize: CGFloat
    
    // Behavior
    public let isDisabled: Bool
    public let onTabChange: (Int) -> Void
    
    public init(
        tabs: [TabItem] = [
            TabItem(title: "Home", icon: "house"),
            TabItem(title: "Search", icon: "magnifyingglass"),
            TabItem(title: "Profile", icon: "person")
        ],
        selectedIndex: Int = 0,
        style: CustomTabBarStyle = .segmented,
        showLabels: Bool = true,
        showContent: Bool = false,
        backgroundColor: Color = Color(.systemGray6),
        selectedBackgroundColor: Color = .blue,
        textColor: Color = .primary,
        selectedTextColor: Color = .white,
        borderColor: Color = Color(.systemGray4),
        selectedBorderColor: Color = .blue,
        badgeColor: Color = .red,
        shadowColor: Color = Color.black.opacity(0.1),
        borderWidth: CGFloat = 1,
        cornerRadius: CGFloat = 12,
        underlineHeight: CGFloat = 3,
        shadowRadius: CGFloat = 4,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        horizontalPadding: CGFloat = 16,
        verticalPadding: CGFloat = 12,
        bottomPadding: CGFloat = 8,
        tabSpacing: CGFloat = 8,
        tabHorizontalPadding: CGFloat = 16,
        iconTextSpacing: CGFloat = 4,
        fontSize: CGFloat = 12,
        iconSize: CGFloat = 20,
        isDisabled: Bool = false,
        onTabChange: @escaping (Int) -> Void = { _ in }
    ) {
        self.tabs = tabs
        self.selectedIndex = selectedIndex
        self.style = style
        self.showLabels = showLabels
        self.showContent = showContent
        self.backgroundColor = backgroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.textColor = textColor
        self.selectedTextColor = selectedTextColor
        self.borderColor = borderColor
        self.selectedBorderColor = selectedBorderColor
        self.badgeColor = badgeColor
        self.shadowColor = shadowColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.underlineHeight = underlineHeight
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.bottomPadding = bottomPadding
        self.tabSpacing = tabSpacing
        self.tabHorizontalPadding = tabHorizontalPadding
        self.iconTextSpacing = iconTextSpacing
        self.fontSize = fontSize
        self.iconSize = iconSize
        self.isDisabled = isDisabled
        self.onTabChange = onTabChange
    }
    
    // MARK: - ComponentConfiguration
    
    public static var displayName: String { "Custom Tab Bar" }
    public static var category: ComponentCategory { .navigation }
    public static var minimumIOSVersion: String { "16.0" }
    public static var description: String { "Enhanced tab bar with multiple styles and smooth animations" }
}

#Preview {
    ScrollView {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Tab Bar Styles")
                    .font(.headline)
                
                // Segmented Style
                VStack(alignment: .leading, spacing: 8) {
                    Text("Segmented Style")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    CustomTabBar.segmented(
                        tabs: ["Home", "Search", "Profile"],
                        selectedIndex: 0
                    )
                }
                
                // Floating Style
                VStack(alignment: .leading, spacing: 8) {
                    Text("Floating Style")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    CustomTabBar.floating(
                        tabs: ["Dashboard", "Analytics", "Settings"],
                        selectedIndex: 1
                    )
                }
                
                // Minimal Style
                VStack(alignment: .leading, spacing: 8) {
                    Text("Minimal Style")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    CustomTabBar.minimal(
                        tabs: ["Overview", "Details", "History"],
                        selectedIndex: 0
                    )
                }
                
                // Pills Style
                VStack(alignment: .leading, spacing: 8) {
                    Text("Pills Style")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    CustomTabBar.pills(
                        tabs: ["All", "Active", "Completed"],
                        selectedIndex: 2
                    )
                }
                
                // With Icons and Badges
                VStack(alignment: .leading, spacing: 8) {
                    Text("With Icons & Badges")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    CustomTabBar(configuration: CustomTabBarConfiguration(
                        tabs: [
                            TabItem(title: "Home", icon: "house", badge: nil),
                            TabItem(title: "Messages", icon: "message", badge: 5),
                            TabItem(title: "Notifications", icon: "bell", badge: 12),
                            TabItem(title: "Profile", icon: "person", badge: nil)
                        ],
                        selectedIndex: 1,
                        style: .segmented,
                        selectedBackgroundColor: .blue
                    ))
                }
            }
        }
        .padding()
    }
} 