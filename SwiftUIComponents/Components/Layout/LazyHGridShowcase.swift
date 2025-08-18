import SwiftUI

struct LazyHGridShowcase: View {
    var body: some View {
        VStack(spacing: 0) {
            NativeLazyHGridExample(
                title: "Fixed Rows Grid",
                description: "LazyHGrid with fixed row heights",
                style: .fixed
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeLazyHGridExample(
                title: "Flexible Rows Grid",
                description: "LazyHGrid with flexible row sizing",
                style: .flexible
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeLazyHGridExample(
                title: "Adaptive Rows Grid",
                description: "LazyHGrid with adaptive row count",
                style: .adaptive
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeLazyHGridExample(
                title: "Mixed Rows Grid",
                description: "LazyHGrid with mixed row configurations",
                style: .mixed
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeLazyHGridStyle: CaseIterable {
    case fixed
    case flexible
    case adaptive
    case mixed
    
    var displayName: String {
        switch self {
        case .fixed: return "Fixed"
        case .flexible: return "Flexible"
        case .adaptive: return "Adaptive"
        case .mixed: return "Mixed"
        }
    }
}

struct NativeLazyHGridExample: View {
    let title: String
    let description: String
    let style: NativeLazyHGridStyle
    
    private let items = Array(1...20).map { "Item \($0)" }
    private let colors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .yellow, .cyan]
    
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
            
            // LazyHGrid examples
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: gridRows, spacing: 8) {
                    ForEach(items.indices, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(colors[index % colors.count].opacity(0.7))
                            .frame(width: 80)
                            .overlay(
                                Text(items[index])
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white)
                            )
                    }
                }
                .padding(.horizontal, 8)
            }
            .frame(height: gridHeight)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Style: .\(style.displayName.lowercased())")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                
                Text(gridDescription)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    private var gridRows: [GridItem] {
        switch style {
        case .fixed:
            return [
                GridItem(.fixed(40)),
                GridItem(.fixed(40)),
                GridItem(.fixed(40))
            ]
        case .flexible:
            return [
                GridItem(.flexible(minimum: 30)),
                GridItem(.flexible(minimum: 30))
            ]
        case .adaptive:
            return [
                GridItem(.adaptive(minimum: 35))
            ]
        case .mixed:
            return [
                GridItem(.fixed(30)),
                GridItem(.flexible(minimum: 25)),
                GridItem(.adaptive(minimum: 35))
            ]
        }
    }
    
    private var gridHeight: CGFloat {
        switch style {
        case .fixed: return 140
        case .flexible: return 80
        case .adaptive: return 120
        case .mixed: return 120
        }
    }
    
    private var gridDescription: String {
        switch style {
        case .fixed:
            return "GridItem(.fixed(40)) × 3 rows"
        case .flexible:
            return "GridItem(.flexible(minimum: 30)) × 2 rows"
        case .adaptive:
            return "GridItem(.adaptive(minimum: 35))"
        case .mixed:
            return "Mixed: .fixed, .flexible, .adaptive"
        }
    }
}

#Preview {
    ScrollView {
        LazyHGridShowcase()
            .padding()
    }
} 