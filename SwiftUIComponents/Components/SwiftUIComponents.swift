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

public enum ComponentCategory: String, CaseIterable {
    case creators = "Creators"
    case buttons = "Buttons & Actions"
    case controls = "Controls & Selection"
    case inputs = "Text & Input"
    case feedback = "Feedback & Indicators"
    case navigation = "Navigation & Presentation"
    case layout = "Layout & Data"
    case media = "Media & Graphics"
    case system = "System Integration"
    
    public var icon: String {
        switch self {
        case .buttons: return "button.programmable"
        case .controls: return "slider.horizontal.3"
        case .inputs: return "textformat"
        case .feedback: return "exclamationmark.triangle"
        case .navigation: return "rectangle.stack"
        case .layout: return "rectangle.3.group"
        case .media: return "photo"
        case .system: return "gear"
        case .creators: return "plus.square.on.square"
        }
    }
    
    public var color: Color {
        switch self {
        case .buttons: return .blue
        case .controls: return .purple
        case .inputs: return .green
        case .feedback: return .orange
        case .navigation: return .indigo
        case .layout: return .cyan
        case .media: return .pink
        case .system: return .gray
        case .creators: return .red
        }
    }
}

// MARK: - Component Model

public struct ComponentModel: Identifiable, Hashable {
    public let id: String
    public let displayName: String
    public let category: ComponentCategory
    public let description: String
    public let minimumIOSVersion: String
    public let isImplemented: Bool
    
    public init(id: String, displayName: String, category: ComponentCategory, description: String, minimumIOSVersion: String, isImplemented: Bool) {
        self.id = id
        self.displayName = displayName
        self.category = category
        self.description = description
        self.minimumIOSVersion = minimumIOSVersion
        self.isImplemented = isImplemented
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
        // Register ONLY native iOS/SwiftUI components
        components = [
            // MARK: - Native Buttons & Actions (4/7 implemented)
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
            ComponentModel(
                id: "LinkShowcase",
                displayName: "Link",
                category: .buttons,
                description: "Native SwiftUI Link component for web URLs",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "MenuShowcase",
                displayName: "Menu",
                category: .buttons,
                description: "Native SwiftUI Menu with different presentations and styles",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "ShareLinkShowcase",
                displayName: "ShareLink",
                category: .buttons,
                description: "Native iOS 16+ ShareLink component for sharing content",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            
            // MARK: - Native Controls & Selection (5/7 implemented)
            ComponentModel(
                id: "NativePickerShowcase",
                displayName: "Picker Styles",
                category: .controls,
                description: "Native iOS picker styles (.segmented, .wheel, .menu, .palette, .navigationLink)",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "NativeToggleShowcase",
                displayName: "Toggle Styles",
                category: .controls,
                description: "Native iOS toggle styles (.automatic, .switch, .button, .checkbox)",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "NativeSliderShowcase",
                displayName: "Slider",
                category: .controls,
                description: "Native SwiftUI Slider component",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "NativeDatePickerShowcase",
                displayName: "DatePicker Styles",
                category: .controls,
                description: "Native iOS DatePicker styles (.compact, .wheel, .graphical)",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "NativeStepperShowcase",
                displayName: "Stepper",
                category: .controls,
                description: "Native SwiftUI Stepper component with different display styles",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "ColorPickerShowcase",
                displayName: "ColorPicker",
                category: .controls,
                description: "Native iOS 14+ ColorPicker component",
                minimumIOSVersion: "14.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "GaugeShowcase",
                displayName: "Gauge",
                category: .controls,
                description: "Native iOS 16+ Gauge component with different styles",
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
            
            // MARK: - Native Feedback & Indicators (2/4 implemented) 🚨 NEEDS EXPANSION
            ComponentModel(
                id: "NativeAlertShowcase",
                displayName: "Alert",
                category: .feedback,
                description: "Native SwiftUI Alert presentations (.basic, .confirmation, .destructive, .textInput)",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "NativeActionSheetShowcase",
                displayName: "ActionSheet",
                category: .feedback,
                description: "Native iOS ConfirmationDialog (ActionSheet) presentations",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "ProgressViewShowcase",
                displayName: "ProgressView",
                category: .feedback,
                description: "Native iOS ProgressView (.linear, .circular, .indeterminate)",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "HUDLoadingShowcase",
                displayName: "HUD/Loading",
                category: .feedback,
                description: "Native iOS loading indicators and activity views",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "AlertCreator",
                displayName: "Alert Creator",
                category: .creators,
                description: "Create and customize native SwiftUI Alerts",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "ActionSheetCreator",
                displayName: "Action Sheet Creator (Deprecated)",
                category: .creators,
                description: "Create and customize native SwiftUI Action Sheets. Deprecated in iOS 15.",
                minimumIOSVersion: "13.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "ConfirmationDialogCreator",
                displayName: "Confirmation Dialog Creator",
                category: .creators,
                description: "Create and customize native SwiftUI Confirmation Dialogs",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            
            // MARK: - Native Navigation & Presentation (1/8 implemented) 🚨 MAJOR GAPS
            ComponentModel(
                id: "NativeTabViewShowcase",
                displayName: "TabView",
                category: .navigation,
                description: "Native SwiftUI TabView (.automatic, .page) with tab styling",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "NavigationStackShowcase",
                displayName: "NavigationStack",
                category: .navigation,
                description: "Native iOS 16+ NavigationStack with path-based navigation",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "NavigationSplitViewShowcase",
                displayName: "NavigationSplitView",
                category: .navigation,
                description: "Native iOS 16+ NavigationSplitView for iPad/Mac",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "SheetPresentationShowcase",
                displayName: "Sheet Presentations",
                category: .navigation,
                description: "Native SwiftUI sheet modifiers and presentations",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "PopoverShowcase",
                displayName: "Popover",
                category: .navigation,
                description: "Native SwiftUI popover presentations",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "FullScreenCoverShowcase",
                displayName: "FullScreenCover",
                category: .navigation,
                description: "Native SwiftUI fullScreenCover presentations",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "ConfirmationDialogShowcase",
                displayName: "ConfirmationDialog",
                category: .navigation,
                description: "Native SwiftUI confirmation dialogs",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            
            // MARK: - Native Layout & Data (0/10 implemented) 🚨 MAJOR GAPS
            ComponentModel(
                id: "ListStylesShowcase",
                displayName: "List Styles",
                category: .layout,
                description: "Native SwiftUI List (.plain, .grouped, .inset, .sidebar)",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "FormShowcase",
                displayName: "Form",
                category: .layout,
                description: "Native SwiftUI Form with different section styles",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "SectionShowcase",
                displayName: "Section",
                category: .layout,
                description: "Native SwiftUI Section for grouping content",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "ScrollViewShowcase",
                displayName: "ScrollView",
                category: .layout,
                description: "Native SwiftUI ScrollView with different configurations",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "LazyVGridShowcase",
                displayName: "LazyVGrid",
                category: .layout,
                description: "Native SwiftUI LazyVGrid for vertical grids",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "LazyHGridShowcase",
                displayName: "LazyHGrid",
                category: .layout,
                description: "Native SwiftUI LazyHGrid for horizontal grids",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "GridShowcase",
                displayName: "Grid",
                category: .layout,
                description: "Native iOS 16+ Grid layout",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "DividerSpacerShowcase",
                displayName: "Divider & Spacer",
                category: .layout,
                description: "Native SwiftUI Divider and Spacer components",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "TableShowcase",
                displayName: "Table",
                category: .layout,
                description: "Native iOS 16+ Table component (iPad/Mac)",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            
            // MARK: - Native Media & Graphics (0/5 implemented) 🚨 MAJOR GAPS
            ComponentModel(
                id: "ImageShowcase",
                displayName: "Image",
                category: .media,
                description: "Native SwiftUI Image with different content modes and styling",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "AsyncImageShowcase",
                displayName: "AsyncImage",
                category: .media,
                description: "Native SwiftUI AsyncImage for loading remote images",
                minimumIOSVersion: "15.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "SymbolShowcase",
                displayName: "SF Symbols",
                category: .media,
                description: "Native SF Symbols with different rendering modes",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "VideoPlayerShowcase",
                displayName: "VideoPlayer",
                category: .media,
                description: "Native iOS 14+ VideoPlayer component",
                minimumIOSVersion: "14.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "CanvasShowcase",
                displayName: "Canvas",
                category: .media,
                description: "Native SwiftUI Canvas for custom drawing",
                minimumIOSVersion: "15.0",
                isImplemented: true
            ),
            
            // MARK: - Native System Integration (0/6 implemented) 🚨 MAJOR GAPS
            ComponentModel(
                id: "PhotosPickerShowcase",
                displayName: "PhotosPicker",
                category: .system,
                description: "Native iOS 16+ PhotosPicker component",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "DocumentPickerShowcase",
                displayName: "DocumentPicker",
                category: .system,
                description: "Native iOS document picker",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "MapKitShowcase",
                displayName: "MapKit",
                category: .system,
                description: "Native SwiftUI Map component",
                minimumIOSVersion: "17.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "SafariViewShowcase",
                displayName: "SafariView",
                category: .system,
                description: "Native Safari view controller",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "MessageUIShowcase",
                displayName: "MessageUI",
                category: .system,
                description: "Native iOS mail and message composers",
                minimumIOSVersion: "16.0",
                isImplemented: true
            ),
            ComponentModel(
                id: "StoreKitShowcase",
                displayName: "StoreKit",
                category: .system,
                description: "Native iOS in-app purchase views",
                minimumIOSVersion: "16.0",
                isImplemented: true
            )
        ]
    }
    
    public func components(for category: ComponentCategory) -> [ComponentModel] {
        return components.filter { $0.category == category }
    }
    
    public func component(withId id: String) -> ComponentModel? {
        return components.first { $0.id == id }
    }
} 
