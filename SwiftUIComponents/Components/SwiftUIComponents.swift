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
    case controls = "Controls & Selection"
    case layout = "Layout Containers"
    case feedback = "Feedback & Indicators"
    case navigation = "Navigation"
    case media = "Media & Content"
    case advanced = "Advanced"
    
    public var icon: String {
        switch self {
        case .buttons: return "button.programmable"
        case .inputs: return "textformat"
        case .controls: return "switch.2"
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
        case .controls: return .indigo
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
            // MARK: - Native Buttons & Actions (4/4 implemented)
            ComponentModel(
                id: "StandardButtons",
                displayName: "Standard Buttons",
                category: .buttons,
                description: "Native iOS button styles (.automatic, .bordered, .borderedProminent, .plain)",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "ButtonSizes",
                displayName: "Button Sizes",
                category: .buttons,
                description: "Native iOS button control sizes (.mini, .small, .regular, .large)",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "SpecialButtons",
                displayName: "Special Buttons",
                category: .buttons,
                description: "Destructive buttons, disabled states, and button roles",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "ButtonsWithIcons",
                displayName: "Buttons with Icons",
                category: .buttons,
                description: "Native iOS buttons with SF Symbols and labels",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            
            // MARK: - Native Text & Input (6/6 implemented)
            ComponentModel(
                id: "BasicTextFields",
                displayName: "Basic TextFields",
                category: .inputs,
                description: "Native iOS TextField styles (.plain, .roundedBorder)",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "KeyboardTypes",
                displayName: "Keyboard Types",
                category: .inputs,
                description: "TextField with different keyboard types (.emailAddress, .numberPad, .phonePad, .URL, etc.)",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "TextContentTypes",
                displayName: "Text Content Types",
                category: .inputs,
                description: "TextField with text content types for AutoFill (.username, .password, .creditCardNumber, etc.)",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "SecureFields",
                displayName: "Secure Fields",
                category: .inputs,
                description: "Native iOS SecureField for password input with visibility toggle",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "TextEditors",
                displayName: "Text Editors",
                category: .inputs,
                description: "Native iOS TextEditor for multiline text input",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "SearchFields",
                displayName: "Search Fields",
                category: .inputs,
                description: "Native iOS searchable modifier and search functionality",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            
            // MARK: - Controls & Selection (1/6 implemented)
            ComponentModel(
                id: "NativeSegmentedControlShowcase",
                displayName: "Native Segmented Control Showcase",
                category: .controls,
                description: "Showcase of native iOS Picker with .segmented style",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "NativeToggleShowcase",
                displayName: "Native Toggle Showcase",
                category: .controls,
                description: "Showcase of native iOS Toggle with all built-in styles",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "NativeSliderShowcase",
                displayName: "Native Slider Showcase",
                category: .controls,
                description: "Showcase of native iOS Slider component",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "NativeDatePickerShowcase",
                displayName: "Native DatePicker Showcase",
                category: .controls,
                description: "Showcase of native iOS DatePicker styles (.compact, .wheel, .graphical)",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "NativeStepperShowcase",
                displayName: "Native Stepper Showcase",
                category: .controls,
                description: "Showcase of native iOS Stepper component with different display styles",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "NativeTextEditorShowcase",
                displayName: "Native TextEditor Showcase",
                category: .inputs,
                description: "Showcase of native iOS TextEditor for multiline text input",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "NativeSecureFieldShowcase",
                displayName: "Native SecureField Showcase",
                category: .inputs,
                description: "Showcase of native iOS SecureField for password input",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "NativePickerShowcase",
                displayName: "Native Picker Showcase",
                category: .controls,
                description: "Showcase of native iOS Picker with all built-in styles (segmented, wheel, menu, automatic, navigationLink)",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "RangeSlider",
                displayName: "Range Slider",
                category: .controls,
                description: "Dual-handle slider for range selection",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            ComponentModel(
                id: "RatingControl",
                displayName: "Rating Control",
                category: .controls,
                description: "Star rating input component",
                minimumIOSVersion: "16.0",
                isImplemented: false
            ),
            
            // MARK: - Native Navigation (1/4 implemented)
            ComponentModel(
                id: "NativeTabViewShowcase",
                displayName: "Native TabView Showcase",
                category: .navigation,
                description: "Showcase of native iOS TabView with different styles (.automatic, .page)",
                minimumIOSVersion: "16.0",
                isImplemented: true
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
            
            // MARK: - Layout Containers (1/8 implemented)
            ComponentModel(
                id: "CustomCard",
                displayName: "Custom Card",
                category: .layout,
                description: "Versatile card container with multiple styles and content support",
                minimumIOSVersion: "16.0",
                isImplemented: true
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
            
            // MARK: - Feedback & Indicators (1/9 implemented)
            ComponentModel(
                id: "ProgressIndicator",
                displayName: "Progress Indicator",
                category: .feedback,
                description: "Progress indicators with multiple styles and animations",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "LoadingSpinner",
                displayName: "Loading Spinner",
                category: .feedback,
                description: "Activity indicators with custom animations",
                minimumIOSVersion: "16.0",
                isImplemented: true
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
                isImplemented: true
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
                isImplemented: true
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
            
            // MARK: - Navigation (0/5 implemented)
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