import SwiftUI

struct ScrollViewShowcase: View {
    var body: some View {
        VStack(spacing: 0) {
            NativeScrollViewExample(
                title: "Vertical ScrollView",
                description: "Native SwiftUI ScrollView with vertical scrolling",
                style: .vertical
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeScrollViewExample(
                title: "Horizontal ScrollView",
                description: "ScrollView with horizontal scrolling content",
                style: .horizontal
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeScrollViewExample(
                title: "ScrollView with Indicators",
                description: "ScrollView with custom scroll indicators",
                style: .withIndicators
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeScrollViewExample(
                title: "Refreshable ScrollView",
                description: "ScrollView with pull-to-refresh functionality",
                style: .refreshable
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeScrollViewStyle: CaseIterable {
    case vertical
    case horizontal
    case withIndicators
    case refreshable
    
    var displayName: String {
        switch self {
        case .vertical: return "Vertical"
        case .horizontal: return "Horizontal"
        case .withIndicators: return "With Indicators"
        case .refreshable: return "Refreshable"
        }
    }
}

struct NativeScrollViewExample: View {
    let title: String
    let description: String
    let style: NativeScrollViewStyle
    
    @State private var isRefreshing = false
    @State private var refreshCount = 0
    
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
            
            Group {
                switch style {
                case .vertical:
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 8) {
                            ForEach(1...10, id: \.self) { index in
                                HStack {
                                    Image(systemName: "\(index).circle.fill")
                                        .foregroundStyle(.blue)
                                    Text("Vertical Item \(index)")
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    
                case .horizontal:
                    ScrollView(.horizontal, showsIndicators: true) {
                        LazyHStack(spacing: 12) {
                            ForEach(1...10, id: \.self) { index in
                                VStack(spacing: 8) {
                                    Image(systemName: "photo")
                                        .font(.title)
                                        .foregroundStyle(.blue)
                                    Text("Item \(index)")
                                        .font(.caption)
                                }
                                .frame(width: 80, height: 80)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    
                case .withIndicators:
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVStack(spacing: 4) {
                            ForEach(1...8, id: \.self) { index in
                                HStack {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 12, height: 12)
                                    Text("Scrollable content \(index)")
                                        .font(.body)
                                    Spacer()
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(Color(.tertiarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    
                case .refreshable:
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 8) {
                            if refreshCount > 0 {
                                Text("Refreshed \(refreshCount) time\(refreshCount == 1 ? "" : "s")")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                                    .padding(.vertical, 4)
                            }
                            
                            ForEach(1...6, id: \.self) { index in
                                HStack {
                                    Image(systemName: "arrow.clockwise.circle")
                                        .foregroundStyle(.green)
                                    Text("Refreshable Item \(index)")
                                    Spacer()
                                    Text("Pull to refresh")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    .refreshable {
                        isRefreshing = true
                        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                        refreshCount += 1
                        isRefreshing = false
                    }
                }
            }
            .frame(height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: ""))")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

#Preview {
    ScrollView {
        ScrollViewShowcase()
            .padding()
    }
} 