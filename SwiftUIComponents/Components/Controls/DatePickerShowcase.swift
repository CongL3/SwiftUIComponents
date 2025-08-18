import SwiftUI

// MARK: - Native iOS DatePicker Styles Showcase
// This component demonstrates ALL built-in SwiftUI DatePicker styles
// NO custom implementations - pure native Apple UI only

public struct NativeDatePickerShowcase: SwiftUIComponent {
    public let configuration: NativeDatePickerConfiguration
    @State private var selectedDate: Date = Date()
    
    public init(configuration: NativeDatePickerConfiguration) {
        self.configuration = configuration
        self._selectedDate = State(initialValue: configuration.selectedDate)
    }
    
    public init() {
        self.configuration = NativeDatePickerConfiguration()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: configuration.spacing) {
            // Label
            if !configuration.label.isEmpty {
                Text(configuration.label)
                    .font(configuration.labelFont)
                    .foregroundStyle(configuration.labelColor)
            }
            
            // Native iOS DatePicker with different styles
            datePickerView
            
            // Current Selection Display
            if configuration.showCurrentSelection {
                Text("Selected: \(selectedDate, formatter: configuration.dateFormatter)")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .padding(.top, 4)
            }
        }
        .onChange(of: selectedDate) { oldValue, newValue in
            configuration.onDateChange?(newValue)
        }
    }
    
    @ViewBuilder
    private var datePickerView: some View {
        switch configuration.style {
        case .compact:
            compactDatePicker
        case .wheel:
            wheelDatePicker
        case .graphical:
            graphicalDatePicker
        }
    }
    
    private var compactDatePicker: some View {
        DatePicker(
            configuration.label,
            selection: $selectedDate,
            in: configuration.dateRange,
            displayedComponents: configuration.displayedComponents
        )
        .datePickerStyle(.compact)
        .labelsHidden()
    }
    
    private var wheelDatePicker: some View {
        DatePicker(
            configuration.label,
            selection: $selectedDate,
            in: configuration.dateRange,
            displayedComponents: configuration.displayedComponents
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .frame(height: configuration.wheelHeight)
    }
    
    private var graphicalDatePicker: some View {
        DatePicker(
            configuration.label,
            selection: $selectedDate,
            in: configuration.dateRange,
            displayedComponents: configuration.displayedComponents
        )
        .datePickerStyle(.graphical)
        .labelsHidden()
    }
}

// MARK: - Configuration

public struct NativeDatePickerConfiguration: ComponentConfiguration {
    public let label: String
    public let selectedDate: Date
    public let dateRange: ClosedRange<Date>
    public let displayedComponents: DatePicker.Components
    public let style: NativeDatePickerStyle
    public let showCurrentSelection: Bool
    public let spacing: CGFloat
    public let wheelHeight: CGFloat
    public let labelFont: Font
    public let labelColor: Color
    public let dateFormatter: DateFormatter
    public let onDateChange: ((Date) -> Void)?
    
    public init(
        label: String = "Select Date",
        selectedDate: Date = Date(),
        dateRange: ClosedRange<Date> = Date()...Calendar.current.date(byAdding: .year, value: 10, to: Date())!,
        displayedComponents: DatePicker.Components = [.date],
        style: NativeDatePickerStyle = .compact,
        showCurrentSelection: Bool = true,
        spacing: CGFloat = 8,
        wheelHeight: CGFloat = 120,
        labelFont: Font = .headline,
        labelColor: Color = .primary,
        dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter
        }(),
        onDateChange: ((Date) -> Void)? = nil
    ) {
        self.label = label
        self.selectedDate = selectedDate
        self.dateRange = dateRange
        self.displayedComponents = displayedComponents
        self.style = style
        self.showCurrentSelection = showCurrentSelection
        self.spacing = spacing
        self.wheelHeight = wheelHeight
        self.labelFont = labelFont
        self.labelColor = labelColor
        self.dateFormatter = dateFormatter
        self.onDateChange = onDateChange
    }
    
    // ComponentConfiguration requirements
    public static var displayName: String { "Native DatePicker Showcase" }
    public static var category: ComponentCategory { .controls }
    public static var minimumIOSVersion: String { "16.0" }
    public static var description: String { "Showcase of native iOS DatePicker styles (.compact, .wheel, .graphical)" }
}

// MARK: - Convenience Methods

extension NativeDatePickerShowcase {
    public static func compact(
        label: String,
        selectedDate: Date = Date(),
        displayedComponents: DatePicker.Components = [.date]
    ) -> NativeDatePickerShowcase {
        NativeDatePickerShowcase(configuration: NativeDatePickerConfiguration(
            label: label,
            selectedDate: selectedDate,
            displayedComponents: displayedComponents,
            style: .compact
        ))
    }
    
    public static func wheel(
        label: String,
        selectedDate: Date = Date(),
        displayedComponents: DatePicker.Components = [.date]
    ) -> NativeDatePickerShowcase {
        NativeDatePickerShowcase(configuration: NativeDatePickerConfiguration(
            label: label,
            selectedDate: selectedDate,
            displayedComponents: displayedComponents,
            style: .wheel
        ))
    }
    
    public static func graphical(
        label: String,
        selectedDate: Date = Date(),
        displayedComponents: DatePicker.Components = [.date]
    ) -> NativeDatePickerShowcase {
        NativeDatePickerShowcase(configuration: NativeDatePickerConfiguration(
            label: label,
            selectedDate: selectedDate,
            displayedComponents: displayedComponents,
            style: .graphical
        ))
    }
}

// MARK: - SwiftUI Preview

#Preview("Native DatePicker Showcase") {
    NavigationStack {
        ScrollView {
            VStack(spacing: 24) {
                // Compact DatePicker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Compact Style")
                        .font(.headline)
                    NativeDatePickerShowcase.compact(
                        label: "Event Date",
                        displayedComponents: [.date]
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Wheel DatePicker  
                VStack(alignment: .leading, spacing: 8) {
                    Text("Wheel Style")
                        .font(.headline)
                    NativeDatePickerShowcase.wheel(
                        label: "Appointment Time",
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Graphical DatePicker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Graphical Style")
                        .font(.headline)
                    NativeDatePickerShowcase.graphical(
                        label: "Calendar Date",
                        displayedComponents: [.date]
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle("Native DatePicker Styles")
    }
} 