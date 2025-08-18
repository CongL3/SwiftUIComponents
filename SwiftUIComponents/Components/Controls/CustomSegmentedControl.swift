import SwiftUI

// MARK: - Native Apple Segmented Control Showcase
// This component demonstrates native SwiftUI Picker with .segmented style
// NO custom implementations - pure native Apple UI only

public struct NativeSegmentedControlShowcase: SwiftUIComponent {
    public let configuration: NativeSegmentedControlConfiguration
    @State private var selectedIndex: Int = 0
    
    public init(configuration: NativeSegmentedControlConfiguration) {
        self.configuration = configuration
        self._selectedIndex = State(initialValue: configuration.selectedIndex)
    }
    
    public init() {
        self.configuration = NativeSegmentedControlConfiguration()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: configuration.spacing) {
            // Label
            if !configuration.label.isEmpty {
                Text(configuration.label)
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            // Native SwiftUI Picker with .segmented style
            nativeSegmentedPicker
            
            // Helper text
            if !configuration.helperText.isEmpty {
                Text(configuration.helperText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .onChange(of: selectedIndex) { oldValue, newValue in
            configuration.onSelectionChange?(newValue)
        }
    }
    
    @ViewBuilder
    private var nativeSegmentedPicker: some View {
        Picker(configuration.label, selection: $selectedIndex) {
            ForEach(Array(configuration.segments.enumerated()), id: \.offset) { index, segment in
                if let icon = segment.icon {
                    Label(segment.title, systemImage: icon)
                        .tag(index)
                } else {
                    Text(segment.title)
                        .tag(index)
                }
            }
        }
        .pickerStyle(.segmented) // Native segmented picker style
        .disabled(configuration.isDisabled)
    }
}

// MARK: - Configuration

public struct NativeSegmentedControlConfiguration: ComponentConfiguration {
    public static let displayName = "Native Segmented Control"
    public static let category: ComponentCategory = .controls
    public static let minimumIOSVersion = "16.0"
    public static let description = "Native Apple segmented control using Picker"
    
    // Content
    public let label: String
    public let segments: [SegmentItem]
    public let selectedIndex: Int
    public let helperText: String
    
    // Layout
    public let spacing: CGFloat
    
    // Behavior
    public let isDisabled: Bool
    public let onSelectionChange: ((Int) -> Void)?
    
    public init(
        label: String = "Select Option",
        segments: [SegmentItem] = [
            SegmentItem(title: "First", icon: nil),
            SegmentItem(title: "Second", icon: nil),
            SegmentItem(title: "Third", icon: nil)
        ],
        selectedIndex: Int = 0,
        helperText: String = "",
        spacing: CGFloat = 8,
        isDisabled: Bool = false,
        onSelectionChange: ((Int) -> Void)? = nil
    ) {
        self.label = label
        self.segments = segments
        self.selectedIndex = selectedIndex
        self.helperText = helperText
        self.spacing = spacing
        self.isDisabled = isDisabled
        self.onSelectionChange = onSelectionChange
    }
}

// MARK: - Segment Item

public struct SegmentItem {
    public let title: String
    public let icon: String?
    
    public init(title: String, icon: String? = nil) {
        self.title = title
        self.icon = icon
    }
}

// MARK: - Convenience Initializers

extension NativeSegmentedControlShowcase {
    public static func textOnly(
        label: String,
        segments: [String],
        selectedIndex: Int = 0
    ) -> NativeSegmentedControlShowcase {
        let segmentItems = segments.map { SegmentItem(title: $0, icon: nil) }
        return NativeSegmentedControlShowcase(configuration: NativeSegmentedControlConfiguration(
            label: label,
            segments: segmentItems,
            selectedIndex: selectedIndex,
            helperText: "Native segmented control with text only"
        ))
    }
    
    public static func withIcons(
        label: String,
        segments: [(title: String, icon: String)],
        selectedIndex: Int = 0
    ) -> NativeSegmentedControlShowcase {
        let segmentItems = segments.map { SegmentItem(title: $0.title, icon: $0.icon) }
        return NativeSegmentedControlShowcase(configuration: NativeSegmentedControlConfiguration(
            label: label,
            segments: segmentItems,
            selectedIndex: selectedIndex,
            helperText: "Native segmented control with icons"
        ))
    }
    
    public static func iconsOnly(
        label: String,
        icons: [String],
        selectedIndex: Int = 0
    ) -> NativeSegmentedControlShowcase {
        let segmentItems = icons.map { SegmentItem(title: "", icon: $0) }
        return NativeSegmentedControlShowcase(configuration: NativeSegmentedControlConfiguration(
            label: label,
            segments: segmentItems,
            selectedIndex: selectedIndex,
            helperText: "Native segmented control with icons only"
        ))
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        ScrollView {
            LazyVStack(spacing: 30) {
                // All Native Segmented Control Variations
                Group {
                    Text("Native Apple Segmented Control")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Text Only
                    NativeSegmentedControlShowcase.textOnly(
                        label: "View Mode",
                        segments: ["List", "Grid", "Card"],
                        selectedIndex: 0
                    )
                    
                    Divider()
                    
                    // With Icons
                    NativeSegmentedControlShowcase.withIcons(
                        label: "Layout",
                        segments: [
                            (title: "List", icon: "list.bullet"),
                            (title: "Grid", icon: "square.grid.2x2"),
                            (title: "Detail", icon: "doc.text")
                        ],
                        selectedIndex: 1
                    )
                    
                    Divider()
                    
                    // Icons Only
                    NativeSegmentedControlShowcase.iconsOnly(
                        label: "Alignment",
                        icons: ["text.alignleft", "text.aligncenter", "text.alignright"],
                        selectedIndex: 2
                    )
                    
                    Divider()
                    
                    // Size Options
                    NativeSegmentedControlShowcase.textOnly(
                        label: "Size",
                        segments: ["S", "M", "L", "XL"],
                        selectedIndex: 1
                    )
                    
                    Divider()
                    
                    // Map Style
                    NativeSegmentedControlShowcase.textOnly(
                        label: "Map Type",
                        segments: ["Standard", "Satellite", "Hybrid"],
                        selectedIndex: 0
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Native Segmented Control")
        .navigationBarTitleDisplayMode(.large)
    }
} 