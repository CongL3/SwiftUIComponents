import SwiftUI

struct ProgressViewShowcase: View {
    @State private var progressValue: Double = 0.6
    @State private var isIndeterminate = false
    
    var body: some View {
        VStack(spacing: 0) {
            NativeProgressViewExample(
                title: "Linear Progress",
                description: "Native iOS linear progress bar with determinate progress",
                style: .linear,
                value: progressValue,
                isIndeterminate: false
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeProgressViewExample(
                title: "Circular Progress",
                description: "Native iOS circular progress indicator",
                style: .circular,
                value: progressValue,
                isIndeterminate: false
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeProgressViewExample(
                title: "Indeterminate Linear",
                description: "Native iOS indeterminate linear progress (no specific progress value)",
                style: .linear,
                value: nil,
                isIndeterminate: true
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeProgressViewExample(
                title: "Indeterminate Circular",
                description: "Native iOS indeterminate circular activity indicator",
                style: .circular,
                value: nil,
                isIndeterminate: true
            )
            
            Divider()
                .padding(.horizontal)
            
            // Progress control section
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Progress Control")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("Adjust the progress value for determinate examples")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Progress:")
                        Spacer()
                        Text("\(Int(progressValue * 100))%")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Slider(value: $progressValue, in: 0...1)
                        .tint(.blue)
                }
                
                Text("Progress value: \(progressValue, specifier: "%.2f")")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeProgressViewStyle: CaseIterable {
    case linear
    case circular
    
    var displayName: String {
        switch self {
        case .linear: return "Linear"
        case .circular: return "Circular"
        }
    }
}

struct NativeProgressViewExample: View {
    let title: String
    let description: String
    let style: NativeProgressViewStyle
    let value: Double?
    let isIndeterminate: Bool
    
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
                // Progress view
                Group {
                    if isIndeterminate {
                        switch style {
                        case .linear:
                            ProgressView()
                                .progressViewStyle(.linear)
                        case .circular:
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                    } else {
                        switch style {
                        case .linear:
                            ProgressView(value: value ?? 0.0)
                                .progressViewStyle(.linear)
                        case .circular:
                            ProgressView(value: value ?? 0.0)
                                .progressViewStyle(.circular)
                        }
                    }
                }
                .frame(maxWidth: style == .circular ? 40 : .infinity)
                
                if style == .circular && !isIndeterminate {
                    Spacer()
                    Text("\(Int((value ?? 0) * 100))%")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("Style: .\(style == .linear ? "linear" : "circular")\(isIndeterminate ? " (indeterminate)" : "")")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

#Preview {
    ScrollView {
        ProgressViewShowcase()
            .padding()
    }
} 