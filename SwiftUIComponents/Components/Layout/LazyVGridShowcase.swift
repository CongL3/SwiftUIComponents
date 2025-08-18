import SwiftUI

struct LazyVGridShowcase: View {
    let sampleItems = Array(1...20).map { "Item \($0)" }
    
    var body: some View {
        VStack(spacing: 0) {
            NativeLazyVGridExample(
                title: "Fixed Size Grid",
                description: "LazyVGrid with fixed column sizes",
                style: .fixed,
                items: sampleItems
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeLazyVGridExample(
                title: "Flexible Grid",
                description: "LazyVGrid with flexible column sizing",
                style: .flexible,
                items: sampleItems
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeLazyVGridExample(
                title: "Adaptive Grid",
                description: "LazyVGrid with adaptive column count",
                style: .adaptive,
                items: sampleItems
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeLazyVGridExample(
                title: "Mixed Grid",
                description: "LazyVGrid with mixed column types",
                style: .mixed,
                items: sampleItems
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeLazyVGridStyle: CaseIterable {
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
    
    var columns: [GridItem] {
        switch self {
        case .fixed:
            return [
                GridItem(.fixed(60)),
                GridItem(.fixed(80)),
                GridItem(.fixed(60))
            ]
        case .flexible:
            return [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
        case .adaptive:
            return [
                GridItem(.adaptive(minimum: 50))
            ]
        case .mixed:
            return [
                GridItem(.fixed(50)),
                GridItem(.flexible()),
                GridItem(.adaptive(minimum: 40))
            ]
        }
    }
}

struct NativeLazyVGridExample: View {
    let title: String
    let description: String
    let style: NativeLazyVGridStyle
    let items: [String]
    
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
            
            ScrollView {
                LazyVGrid(columns: style.columns, spacing: 8) {
                    ForEach(items.prefix(12), id: \.self) { item in
                        VStack(spacing: 4) {
                            Circle()
                                .fill(colorForItem(item))
                                .frame(width: 20, height: 20)
                            
                            Text(item)
                                .font(.caption2)
                                .lineLimit(1)
                        }
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal, 4)
            }
            .frame(height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
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
    
    private func colorForItem(_ item: String) -> Color {
        let colors: [Color] = [.blue, .green, .orange, .purple, .red, .pink]
        let index = abs(item.hashValue) % colors.count
        return colors[index]
    }
    
    private var gridDescription: String {
        switch style {
        case .fixed:
            return "Fixed widths: 60, 80, 60 points"
        case .flexible:
            return "3 flexible columns"
        case .adaptive:
            return "Adaptive minimum: 50 points"
        case .mixed:
            return "Fixed (50pt) + Flexible + Adaptive (40pt)"
        }
    }
}

#Preview {
    ScrollView {
        LazyVGridShowcase()
            .padding()
    }
} 