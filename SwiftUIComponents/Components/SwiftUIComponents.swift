import SwiftUI
import Foundation

// MARK: - Core Protocols

/// Protocol that all discoverable SwiftUI components must implement
public protocol SwiftUIComponent: View {
    associatedtype Configuration: ComponentConfiguration
    
    var configuration: Configuration { get }
    
    init(configuration: Configuration)
    init() // Default configuration
}

/// Configuration protocol for component property discovery and management
public protocol ComponentConfiguration {
    static var displayName: String { get }
    static var category: ComponentCategory { get }
    static var minimumIOSVersion: String { get }
    static var description: String { get }
}

// MARK: - Component Categories

public enum ComponentCategory: String, CaseIterable, Codable {
    case buttons = "Buttons & Actions"
    case inputs = "Text & Input"
    case layout = "Layout Containers"
    case feedback = "Feedback & Indicators"
    case navigation = "Navigation"
    case media = "Media & Content"
    case advanced = "Advanced"
    
    public var icon: String {
        switch self {
        case .buttons: return "button.programmable"
        case .inputs: return "textformat"
        case .layout: return "rectangle.3.group"
        case .feedback: return "exclamationmark.bubble"
        case .navigation: return "arrow.triangle.turn.up.right.diamond"
        case .media: return "photo"
        case .advanced: return "gearshape.2"
        }
    }
    
    public var color: Color {
        switch self {
        case .buttons: return .blue
        case .inputs: return .green
        case .layout: return .orange
        case .feedback: return .red
        case .navigation: return .purple
        case .media: return .pink
        case .advanced: return .gray
        }
    }
}

// MARK: - Component Discovery

@MainActor
public class ComponentRegistry: ObservableObject {
    @Published public private(set) var components: [ComponentModel] = []
    
    public static let shared = ComponentRegistry()
    
    private init() {
        registerComponents()
    }
    
    private func registerComponents() {
        // Register all available components
        components = [
            // MARK: - Buttons & Actions (1/6 implemented)
            ComponentModel(
                id: "CustomButton",
                displayName: "Custom Button",
                category: .buttons,
                description: "Customizable button with multiple styles and icons",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "FloatingActionButton",
                displayName: "Floating Action Button",
                category: .buttons,
                description: "Circular floating action button with animations",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "ButtonGroup",
                displayName: "Button Group",
                category: .buttons,
                description: "Segmented control style button group",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "ToggleButton",
                displayName: "Toggle Button",
                category: .buttons,
                description: "Button that maintains pressed state",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "LinkButton",
                displayName: "Link Button",
                category: .buttons,
                description: "Text-style button for navigation",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "IconButton",
                displayName: "Icon Button",
                category: .buttons,
                description: "Icon-only button with various sizes",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            
            // MARK: - Text & Input (0/8 implemented)
            ComponentModel(
                id: "CustomTextField",
                displayName: "Custom Text Field",
                category: .inputs,
                description: "Enhanced text field with validation and styling",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "CustomTextEditor",
                displayName: "Custom Text Editor",
                category: .inputs,
                description: "Multi-line text input with formatting",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "SearchBar",
                displayName: "Search Bar",
                category: .inputs,
                description: "Search input with suggestions and filtering",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "NumberField",
                displayName: "Number Field",
                category: .inputs,
                description: "Numeric input with steppers and validation",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "PasswordField",
                displayName: "Password Field",
                category: .inputs,
                description: "Secure text field with visibility toggle",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "TagInput",
                displayName: "Tag Input",
                category: .inputs,
                description: "Input for creating tags and chips",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "AutoCompleteField",
                displayName: "AutoComplete Field",
                category: .inputs,
                description: "Text field with auto-completion",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "FormField",
                displayName: "Form Field",
                category: .inputs,
                description: "Wrapper for form inputs with labels",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            
            // MARK: - Layout Containers (0/8 implemented)
            ComponentModel(
                id: "CustomCard",
                displayName: "Custom Card",
                category: .layout,
                description: "Container with shadow, borders, and headers",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "CollapsibleSection",
                displayName: "Collapsible Section",
                category: .layout,
                description: "Expandable/collapsible content sections",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "SplitView",
                displayName: "Split View",
                category: .layout,
                description: "Resizable split pane layout",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "GridLayout",
                displayName: "Grid Layout",
                category: .layout,
                description: "Flexible grid container",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "FlowLayout",
                displayName: "Flow Layout",
                category: .layout,
                description: "Auto-wrapping layout for tags and chips",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "StickyHeader",
                displayName: "Sticky Header",
                category: .layout,
                description: "Header that sticks to top when scrolling",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "TabContainer",
                displayName: "Tab Container",
                category: .layout,
                description: "Custom tab interface",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "Sidebar",
                displayName: "Sidebar",
                category: .layout,
                description: "Collapsible sidebar navigation",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            
            // MARK: - Feedback & Indicators (0/9 implemented)
            ComponentModel(
                id: "ProgressIndicator",
                displayName: "Progress Indicator",
                category: .feedback,
                description: "Linear and circular progress bars",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "LoadingSpinner",
                displayName: "Loading Spinner",
                category: .feedback,
                description: "Various loading animations",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "SkeletonLoader",
                displayName: "Skeleton Loader",
                category: .feedback,
                description: "Placeholder content while loading",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "Toast",
                displayName: "Toast",
                category: .feedback,
                description: "Temporary notification messages",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "Banner",
                displayName: "Banner",
                category: .feedback,
                description: "Persistent notification bar",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "Badge",
                displayName: "Badge",
                category: .feedback,
                description: "Small status indicators and counters",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "StatusIndicator",
                displayName: "Status Indicator",
                category: .feedback,
                description: "Connection and health status dots",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "Tooltip",
                displayName: "Tooltip",
                category: .feedback,
                description: "Hover information popover",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "EmptyState",
                displayName: "Empty State",
                category: .feedback,
                description: "Placeholder for empty content",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            
            // MARK: - Navigation (0/6 implemented)
            ComponentModel(
                id: "CustomTabBar",
                displayName: "Custom Tab Bar",
                category: .navigation,
                description: "Enhanced tab bar with animations",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "NavigationBar",
                displayName: "Navigation Bar",
                category: .navigation,
                description: "Custom navigation with breadcrumbs",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "Breadcrumbs",
                displayName: "Breadcrumbs",
                category: .navigation,
                description: "Navigation path indicator",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "Pagination",
                displayName: "Pagination",
                category: .navigation,
                description: "Page navigation controls",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "StepIndicator",
                displayName: "Step Indicator",
                category: .navigation,
                description: "Multi-step process indicator",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "MenuBar",
                displayName: "Menu Bar",
                category: .navigation,
                description: "Horizontal menu navigation",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            
            // MARK: - Media & Content (0/7 implemented)
            ComponentModel(
                id: "ImageViewer",
                displayName: "Image Viewer",
                category: .media,
                description: "Zoomable image display with gestures",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "Avatar",
                displayName: "Avatar",
                category: .media,
                description: "User profile images with fallbacks",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "AvatarGroup",
                displayName: "Avatar Group",
                category: .media,
                description: "Multiple overlapping avatars",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "MediaCarousel",
                displayName: "Media Carousel",
                category: .media,
                description: "Swipeable media gallery",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "VideoPlayer",
                displayName: "Video Player",
                category: .media,
                description: "Custom video player controls",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "AudioPlayer",
                displayName: "Audio Player",
                category: .media,
                description: "Audio playback controls",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "QRCodeView",
                displayName: "QR Code View",
                category: .media,
                description: "QR code generator and scanner",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            
            // MARK: - Advanced (0/6 implemented)
            ComponentModel(
                id: "ChartView",
                displayName: "Chart View",
                category: .advanced,
                description: "Data visualization charts",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "MapView",
                displayName: "Map View",
                category: .advanced,
                description: "Interactive map component",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "CameraView",
                displayName: "Camera View",
                category: .advanced,
                description: "Camera capture interface",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "DocumentPicker",
                displayName: "Document Picker",
                category: .advanced,
                description: "File selection interface",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "ShareSheet",
                displayName: "Share Sheet",
                category: .advanced,
                description: "Native sharing interface",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "NotificationBanner",
                displayName: "Notification Banner",
                category: .advanced,
                description: "System-style notifications",
                minimumIOSVersion: "16.0",
                isImplemented: false
            )
        ]
    }
    
    // MARK: - Public Methods
    
    public func components(for category: ComponentCategory) -> [ComponentModel] {
        components.filter { $0.category == category }
    }
    
    public func componentCount(for category: ComponentCategory) -> Int {
        components(for: category).count
    }
    
    public var totalComponentCount: Int {
        components.count
    }
    
    public var completeComponentCount: Int {
        components.filter { $0.isImplemented }.count
    }
    
    public func component(withId id: String) -> ComponentModel? {
        components.first { $0.id == id }
    }
}

public struct ComponentModel: Identifiable, Codable {
    public let id: String
    public let displayName: String
    public let category: ComponentCategory
    public let description: String
    public let minimumIOSVersion: String
    public let isImplemented: Bool
    
    public init(id: String, displayName: String, category: ComponentCategory, description: String, minimumIOSVersion: String, isImplemented: Bool = false) {
        self.id = id
        self.displayName = displayName
        self.category = category
        self.description = description
        self.minimumIOSVersion = minimumIOSVersion
        self.isImplemented = isImplemented
    }
} 