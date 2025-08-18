import SwiftUI

struct ListShowcase: View {
    @State private var selectedItems = Set<String>()
    
    let sampleItems = [
        ListItem(id: "1", title: "First Item", subtitle: "This is the first item", icon: "1.circle.fill"),
        ListItem(id: "2", title: "Second Item", subtitle: "This is the second item", icon: "2.circle.fill"),
        ListItem(id: "3", title: "Third Item", subtitle: "This is the third item", icon: "3.circle.fill"),
        ListItem(id: "4", title: "Fourth Item", subtitle: "This is the fourth item", icon: "4.circle.fill"),
        ListItem(id: "5", title: "Fifth Item", subtitle: "This is the fifth item", icon: "5.circle.fill")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            NativeListExample(
                title: "Plain List Style",
                description: "Native iOS List with .plain style",
                style: .plain,
                items: sampleItems
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeListExample(
                title: "Grouped List Style",
                description: "Native iOS List with .grouped style",
                style: .grouped,
                items: sampleItems
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeListExample(
                title: "Inset Grouped List Style",
                description: "Native iOS List with .insetGrouped style",
                style: .insetGrouped,
                items: sampleItems
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeListExample(
                title: "Sidebar List Style",
                description: "Native iOS List with .sidebar style",
                style: .sidebar,
                items: sampleItems
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ListItem: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
}

public enum NativeListStyle: CaseIterable {
    case plain
    case grouped
    case insetGrouped
    case sidebar
    
    var displayName: String {
        switch self {
        case .plain: return "Plain"
        case .grouped: return "Grouped"
        case .insetGrouped: return "Inset Grouped"
        case .sidebar: return "Sidebar"
        }
    }
}

struct NativeListExample: View {
    let title: String
    let description: String
    let style: NativeListStyle
    let items: [ListItem]
    @State private var selectedItem: String? = nil
    
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
            
            // List preview with limited height
            Group {
                switch style {
                case .plain:
                    List(items.prefix(3), id: \.id) { item in
                        ListRowView(item: item, selectedItem: $selectedItem)
                    }
                    .listStyle(.plain)
                    
                case .grouped:
                    List {
                        Section("Sample Items") {
                            ForEach(items.prefix(3), id: \.id) { item in
                                ListRowView(item: item, selectedItem: $selectedItem)
                            }
                        }
                    }
                    .listStyle(.grouped)
                    
                case .insetGrouped:
                    List {
                        Section("Sample Items") {
                            ForEach(items.prefix(3), id: \.id) { item in
                                ListRowView(item: item, selectedItem: $selectedItem)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    
                case .sidebar:
                    List(items.prefix(3), id: \.id, selection: $selectedItem) { item in
                        ListRowView(item: item, selectedItem: $selectedItem)
                    }
                    .listStyle(.sidebar)
                }
            }
            .frame(height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: ""))")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                
                if let selectedItem = selectedItem {
                    Text("Selected: \(selectedItem)")
                        .font(.caption2)
                        .foregroundStyle(.blue)
                }
            }
        }
        .padding()
    }
}

struct ListRowView: View {
    let item: ListItem
    @Binding var selectedItem: String?
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.body)
                    .foregroundStyle(.primary)
                
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            if selectedItem == item.id {
                Image(systemName: "checkmark")
                    .font(.caption)
                    .foregroundStyle(.blue)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            selectedItem = selectedItem == item.id ? nil : item.id
        }
    }
}

#Preview {
    ScrollView {
        ListShowcase()
            .padding()
    }
} 