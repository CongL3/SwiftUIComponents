import SwiftUI

struct GaugeShowcase: View {
    @State private var currentValue: Double = 0.6
    @State private var batteryLevel: Double = 0.75
    @State private var temperature: Double = 22.5
    @State private var progress: Double = 0.4
    
    var body: some View {
        VStack(spacing: 0) {
            NativeGaugeExample(
                title: "Linear Capacity Gauge (Default)",
                description: "Native iOS Gauge with linear capacity style",
                value: currentValue,
                range: 0...1,
                style: .linearCapacity,
                label: "Progress"
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeGaugeExample(
                title: "Accessory Circular Gauge",
                description: "Circular gauge suitable for complications",
                value: batteryLevel,
                range: 0...1,
                style: .accessoryCircular,
                label: "Battery"
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeGaugeExample(
                title: "Accessory Linear Gauge",
                description: "Linear gauge for accessory views",
                value: temperature,
                range: 0...40,
                style: .accessoryLinear,
                label: "Temperature"
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeGaugeExample(
                title: "Accessory Circular Capacity",
                description: "Circular capacity gauge for accessories",
                value: progress,
                range: 0...1,
                style: .accessoryCircularCapacity,
                label: "Progress"
            )
            
            Divider()
                .padding(.horizontal)
            
            // Control section
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Gauge Controls")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("Adjust the gauge values")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                VStack(spacing: 12) {
                    VStack(spacing: 8) {
                        HStack {
                            Text("Progress:")
                            Spacer()
                            Text("\(Int(currentValue * 100))%")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $currentValue, in: 0...1)
                    }
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("Battery:")
                            Spacer()
                            Text("\(Int(batteryLevel * 100))%")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $batteryLevel, in: 0...1)
                    }
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("Temperature:")
                            Spacer()
                            Text(String(format: "%.1f°C", temperature))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $temperature, in: 0...40)
                    }
                }
                
                Text("Gauge is available on iOS 16.0+")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeGaugeStyle: CaseIterable {
    case linearCapacity
    case accessoryCircular
    case accessoryLinear
    case accessoryCircularCapacity
    
    var displayName: String {
        switch self {
        case .linearCapacity: return "Linear Capacity"
        case .accessoryCircular: return "Accessory Circular"
        case .accessoryLinear: return "Accessory Linear"
        case .accessoryCircularCapacity: return "Accessory Circular Capacity"
        }
    }
}

struct NativeGaugeExample: View {
    let title: String
    let description: String
    let value: Double
    let range: ClosedRange<Double>
    let style: NativeGaugeStyle
    let label: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                // Gauge examples
                HStack(spacing: 24) {
                    VStack(spacing: 8) {
                        gaugeView
                        
                        Text(formatValue(value))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    // Show multiple sizes for circular gauges
                    if style == .accessoryCircular || style == .accessoryCircularCapacity {
                        VStack(spacing: 8) {
                            gaugeView
                                .scaleEffect(0.8)
                            
                            Text("Smaller")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                        
                        VStack(spacing: 8) {
                            gaugeView
                                .scaleEffect(1.2)
                            
                            Text("Larger")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                
                Spacer()
            }
            
            Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: ""))")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
    
    @ViewBuilder
    private var gaugeView: some View {
        switch style {
        case .linearCapacity:
            Gauge(value: value, in: range) {
                Text(label)
            }
            .gaugeStyle(.linearCapacity)
            .tint(gradientForValue(value))
            
        case .accessoryCircular:
            Gauge(value: value, in: range) {
                Text(label)
            } currentValueLabel: {
                Text("\(Int((value / range.upperBound) * 100))%")
                    .font(.caption2)
            }
            .gaugeStyle(.accessoryCircular)
            .tint(gradientForValue(value))
            
        case .accessoryLinear:
            Gauge(value: value, in: range) {
                Text(label)
            }
            .gaugeStyle(.accessoryLinear)
            .tint(gradientForValue(value))
            
        case .accessoryCircularCapacity:
            Gauge(value: value, in: range) {
                Text(label)
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(gradientForValue(value))
        }
    }
    
    private func formatValue(_ value: Double) -> String {
        if range.upperBound <= 1.0 {
            return "\(Int(value * 100))%"
        } else {
            return String(format: "%.1f", value)
        }
    }
    
    private func gradientForValue(_ value: Double) -> LinearGradient {
        let normalizedValue = value / range.upperBound
        
        if normalizedValue < 0.3 {
            return LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
        } else if normalizedValue < 0.7 {
            return LinearGradient(colors: [.orange, .yellow], startPoint: .leading, endPoint: .trailing)
        } else {
            return LinearGradient(colors: [.yellow, .green], startPoint: .leading, endPoint: .trailing)
        }
    }
}

#Preview {
    ScrollView {
        GaugeShowcase()
            .padding()
    }
} 