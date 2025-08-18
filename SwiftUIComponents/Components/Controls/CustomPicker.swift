import SwiftUI

// MARK: - Native Apple Picker Styles Showcase
// This component demonstrates ALL built-in SwiftUI picker styles
// NO custom implementations - pure native Apple UI only

public struct NativePickerShowcase: SwiftUIComponent {
    public let configuration: NativePickerConfiguration
    @State private var selectedValue: String = ""
    
    public init(configuration: NativePickerConfiguration) {
        self.configuration = configuration
        self._selectedValue = State(initialValue: configuration.selectedValue)
    }
    
    public init() {
        self.configuration = NativePickerConfiguration()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: configuration.spacing) {
            // Label
            if !configuration.label.isEmpty {
                Text(configuration.label)
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            // Native SwiftUI Picker with specified style
            nativePicker
            
            // Helper text
            if !configuration.helperText.isEmpty {
                Text(configuration.helperText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .onChange(of: selectedValue) { oldValue, newValue in
            configuration.onSelectionChange?(newValue)
        }
    }
    
    @ViewBuilder
    private var nativePicker: some View {
        switch configuration.style {
        case .defaultStyle:
            Picker(configuration.label, selection: $selectedValue) {
                ForEach(configuration.options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.automatic) // Default picker style
            
        case .inline:
            Picker(configuration.label, selection: $selectedValue) {
                ForEach(configuration.options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.inline) // Inline picker style
            
        case .menu:
            Picker(configuration.label, selection: $selectedValue) {
                ForEach(configuration.options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu) // Menu picker style
            
        case .navigationLink:
            Picker(configuration.label, selection: $selectedValue) {
                ForEach(configuration.options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.navigationLink) // Navigation link picker style
            
        case .palette:
            Picker(configuration.label, selection: $selectedValue) {
                ForEach(configuration.options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.palette) // Palette picker style
            
        case .radioGroup:
            // Note: .radioGroup is only available on macOS
            Picker(configuration.label, selection: $selectedValue) {
                ForEach(configuration.options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu) // Fallback to menu on iOS
            
        case .wheel:
            Picker(configuration.label, selection: $selectedValue) {
                ForEach(configuration.options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.wheel) // Wheel picker style
            .frame(height: 120)
            
        case .segmented:
            Picker(configuration.label, selection: $selectedValue) {
                ForEach(configuration.options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.segmented) // Segmented picker style
        }
    }
}

// MARK: - Configuration

public struct NativePickerConfiguration: ComponentConfiguration {
    public static let displayName = "Native Picker Showcase"
    public static let category: ComponentCategory = .controls
    public static let minimumIOSVersion = "16.0"
    public static let description = "Showcase of all native Apple picker styles"
    
    // Content
    public let label: String
    public let options: [String]
    public let selectedValue: String
    public let helperText: String
    
    // Native Style Selection
    public let style: NativePickerStyle
    
    // Layout
    public let spacing: CGFloat
    
    // Behavior
    public let onSelectionChange: ((String) -> Void)?
    
    public init(
        label: String = "Select Option",
        options: [String] = ["Option 1", "Option 2", "Option 3"],
        selectedValue: String = "",
        helperText: String = "",
        style: NativePickerStyle = .defaultStyle,
        spacing: CGFloat = 8,
        onSelectionChange: ((String) -> Void)? = nil
    ) {
        self.label = label
        self.options = options
        self.selectedValue = selectedValue.isEmpty ? (options.first ?? "") : selectedValue
        self.helperText = helperText
        self.style = style
        self.spacing = spacing
        self.onSelectionChange = onSelectionChange
    }
}

// MARK: - Native Picker Styles

public enum NativePickerStyle: CaseIterable {
    case defaultStyle    // DefaultPickerStyle (.automatic)
    case inline         // InlinePickerStyle
    case menu           // MenuPickerStyle  
    case navigationLink // NavigationLinkPickerStyle
    case palette        // PalettePickerStyle
    case radioGroup     // RadioGroupPickerStyle
    case wheel          // WheelPickerStyle
    case segmented      // SegmentedPickerStyle
    
    public var displayName: String {
        switch self {
        case .defaultStyle: return "Default (.automatic)"
        case .inline: return "Inline"
        case .menu: return "Menu"
        case .navigationLink: return "Navigation Link"
        case .palette: return "Palette"
        case .radioGroup: return "Radio Group"
        case .wheel: return "Wheel"
        case .segmented: return "Segmented"
        }
    }
    
    public var description: String {
        switch self {
        case .defaultStyle: return "Default picker style, based on context"
        case .inline: return "Each option displayed inline with other views"
        case .menu: return "Options presented as a menu when button pressed"
        case .navigationLink: return "Navigation link that pushes List-style picker"
        case .palette: return "Options as a row of compact elements"
        case .radioGroup: return "Options as a group of radio buttons"
        case .wheel: return "Scrollable wheel showing selected and neighboring options"
        case .segmented: return "Options as segmented control buttons"
        }
    }
}

// MARK: - Convenience Initializers

extension NativePickerShowcase {
    public static func defaultStyle(
        label: String,
        options: [String],
        selectedValue: String = ""
    ) -> NativePickerShowcase {
        NativePickerShowcase(configuration: NativePickerConfiguration(
            label: label,
            options: options,
            selectedValue: selectedValue,
            helperText: "Default picker style based on context",
            style: .defaultStyle
        ))
    }
    
    public static func inline(
        label: String,
        options: [String],
        selectedValue: String = ""
    ) -> NativePickerShowcase {
        NativePickerShowcase(configuration: NativePickerConfiguration(
            label: label,
            options: options,
            selectedValue: selectedValue,
            helperText: "Each option displayed inline",
            style: .inline
        ))
    }
    
    public static func menu(
        label: String,
        options: [String],
        selectedValue: String = ""
    ) -> NativePickerShowcase {
        NativePickerShowcase(configuration: NativePickerConfiguration(
            label: label,
            options: options,
            selectedValue: selectedValue,
            helperText: "Options presented as a menu",
            style: .menu
        ))
    }
    
    public static func navigationLink(
        label: String,
        options: [String],
        selectedValue: String = ""
    ) -> NativePickerShowcase {
        NativePickerShowcase(configuration: NativePickerConfiguration(
            label: label,
            options: options,
            selectedValue: selectedValue,
            helperText: "Navigation link to picker view",
            style: .navigationLink
        ))
    }
    
    public static func palette(
        label: String,
        options: [String],
        selectedValue: String = ""
    ) -> NativePickerShowcase {
        NativePickerShowcase(configuration: NativePickerConfiguration(
            label: label,
            options: options,
            selectedValue: selectedValue,
            helperText: "Compact row of elements",
            style: .palette
        ))
    }
    
    public static func radioGroup(
        label: String,
        options: [String],
        selectedValue: String = ""
    ) -> NativePickerShowcase {
        NativePickerShowcase(configuration: NativePickerConfiguration(
            label: label,
            options: options,
            selectedValue: selectedValue,
            helperText: "Radio button group selection",
            style: .radioGroup
        ))
    }
    
    public static func wheel(
        label: String,
        options: [String],
        selectedValue: String = ""
    ) -> NativePickerShowcase {
        NativePickerShowcase(configuration: NativePickerConfiguration(
            label: label,
            options: options,
            selectedValue: selectedValue,
            helperText: "Scrollable wheel picker",
            style: .wheel
        ))
    }
    
    public static func segmented(
        label: String,
        options: [String],
        selectedValue: String = ""
    ) -> NativePickerShowcase {
        NativePickerShowcase(configuration: NativePickerConfiguration(
            label: label,
            options: options,
            selectedValue: selectedValue,
            helperText: "Segmented control picker",
            style: .segmented
        ))
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        ScrollView {
            LazyVStack(spacing: 30) {
                // All Native Picker Styles
                Group {
                    Text("Native Apple Picker Styles")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Default Style
                    NativePickerShowcase.defaultStyle(
                        label: "Default Style",
                        options: ["Apple", "Orange", "Banana"]
                    )
                    
                    Divider()
                    
                    // Segmented Style
                    NativePickerShowcase.segmented(
                        label: "Segmented Style",
                        options: ["Small", "Medium", "Large"]
                    )
                    
                    Divider()
                    
                    // Menu Style
                    NativePickerShowcase.menu(
                        label: "Menu Style",
                        options: ["Red", "Green", "Blue", "Yellow"]
                    )
                    
                    Divider()
                    
                    // Wheel Style
                    NativePickerShowcase.wheel(
                        label: "Wheel Style",
                        options: Array(1...20).map { "Item \($0)" }
                    )
                    
                    Divider()
                    
                    // Navigation Link Style
                    NativePickerShowcase.navigationLink(
                        label: "Navigation Link Style",
                        options: ["Option A", "Option B", "Option C", "Option D"]
                    )
                }
                
                Group {
                    Divider()
                    
                    // Inline Style
                    NativePickerShowcase.inline(
                        label: "Inline Style",
                        options: ["First", "Second", "Third"]
                    )
                    
                    Divider()
                    
                    // Palette Style
                    NativePickerShowcase.palette(
                        label: "Palette Style",
                        options: ["🔴", "🟢", "🔵", "🟡", "🟣"]
                    )
                    
                    Divider()
                    
                    // Radio Group Style
                    NativePickerShowcase.radioGroup(
                        label: "Radio Group Style",
                        options: ["Option 1", "Option 2", "Option 3"]
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Native Picker Styles")
        .navigationBarTitleDisplayMode(.large)
    }
} 