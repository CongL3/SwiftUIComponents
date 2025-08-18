import SwiftUI

struct NavigationSplitViewShowcase: View {
    @State private var selectedCategory: String? = "Documents"
    @State private var selectedItem: String? = "Document 1"
    
    let categories = ["Documents", "Images", "Videos", "Audio"]
    let items = [
        "Documents": ["Document 1", "Document 2", "Document 3"],
        "Images": ["Photo 1", "Photo 2", "Photo 3"],
        "Videos": ["Video 1", "Video 2", "Video 3"],
        "Audio": ["Song 1", "Song 2", "Song 3"]
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            NativeNavigationSplitViewExample(
                title: "Three Column Split",
                description: "NavigationSplitView with three columns for iPad/Mac",
                style: .threeColumn,
                selectedCategory: $selectedCategory,
                selectedItem: $selectedItem,
                categories: categories,
                items: items
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeNavigationSplitViewExample(
                title: "Two Column Split",
                description: "NavigationSplitView with sidebar and detail",
                style: .twoColumn,
                selectedCategory: $selectedCategory,
                selectedItem: $selectedItem,
                categories: categories,
                items: items
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeNavigationSplitViewExample(
                title: "Compact Layout",
                description: "NavigationSplitView in compact size class",
                style: .compact,
                selectedCategory: $selectedCategory,
                selectedItem: $selectedItem,
                categories: categories,
                items: items
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeNavigationSplitViewExample(
                title: "Customized Split",
                description: "NavigationSplitView with custom styling",
                style: .customized,
                selectedCategory: $selectedCategory,
                selectedItem: $selectedItem,
                categories: categories,
                items: items
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeNavigationSplitViewStyle: CaseIterable {
    case threeColumn
    case twoColumn
    case compact
    case customized
    
    var displayName: String {
        switch self {
        case .threeColumn: return "Three Column"
        case .twoColumn: return "Two Column"
        case .compact: return "Compact"
        case .customized: return "Customized"
        }
    }
}

struct NativeNavigationSplitViewExample: View {
    let title: String
    let description: String
    let style: NativeNavigationSplitViewStyle
    @Binding var selectedCategory: String?
    @Binding var selectedItem: String?
    let categories: [String]
    let items: [String: [String]]
    
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
            
            // NavigationSplitView preview
            Group {
                switch style {
                case .threeColumn:
                    if #available(iOS 16.0, *) {
                        NavigationSplitView {
                            SidebarView(categories: categories, selectedCategory: $selectedCategory)
                        } content: {
                            SplitViewContentView(
                                category: selectedCategory,
                                items: items[selectedCategory ?? ""] ?? [],
                                selectedItem: $selectedItem
                            )
                        } detail: {
                            DetailView(item: selectedItem)
                        }
                        .frame(height: 120)
                    } else {
                        FallbackView()
                    }
                    
                case .twoColumn:
                    if #available(iOS 16.0, *) {
                        NavigationSplitView {
                            SidebarView(categories: categories, selectedCategory: $selectedCategory)
                        } detail: {
                            DetailView(item: selectedItem)
                        }
                        .frame(height: 120)
                    } else {
                        FallbackView()
                    }
                    
                case .compact:
                    if #available(iOS 16.0, *) {
                        NavigationSplitView {
                            SidebarView(categories: categories, selectedCategory: $selectedCategory)
                        } detail: {
                            DetailView(item: selectedItem)
                        }
                        .navigationSplitViewStyle(.balanced)
                        .frame(height: 120)
                    } else {
                        FallbackView()
                    }
                    
                case .customized:
                    if #available(iOS 16.0, *) {
                        NavigationSplitView {
                            SidebarView(categories: categories, selectedCategory: $selectedCategory)
                                .navigationSplitViewColumnWidth(min: 150, ideal: 200, max: 250)
                        } detail: {
                            DetailView(item: selectedItem)
                        }
                        .navigationSplitViewStyle(.prominentDetail)
                        .frame(height: 120)
                    } else {
                        FallbackView()
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: ""))")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                
                Text(splitViewDescription)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    private var splitViewDescription: String {
        switch style {
        case .threeColumn:
            return "NavigationSplitView with sidebar, content, detail"
        case .twoColumn:
            return "NavigationSplitView with sidebar and detail"
        case .compact:
            return "NavigationSplitView with .balanced style"
        case .customized:
            return "NavigationSplitView with custom column widths"
        }
    }
}

struct SidebarView: View {
    let categories: [String]
    @Binding var selectedCategory: String?
    
    var body: some View {
        List(categories, id: \.self, selection: $selectedCategory) { category in
            NavigationLink(category, value: category)
        }
        .navigationTitle("Categories")
    }
}

struct SplitViewContentView: View {
    let category: String?
    let items: [String]
    @Binding var selectedItem: String?
    
    var body: some View {
        List(items, id: \.self, selection: $selectedItem) { item in
            NavigationLink(item, value: item)
        }
        .navigationTitle(category ?? "Items")
    }
}

struct DetailView: View {
    let item: String?
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: iconForItem(item))
                .font(.largeTitle)
                .foregroundStyle(.blue)
            
            Text(item ?? "Select an item")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Details for \(item ?? "no item")")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func iconForItem(_ item: String?) -> String {
        guard let item = item else { return "questionmark" }
        
        if item.contains("Document") { return "doc.fill" }
        if item.contains("Photo") { return "photo.fill" }
        if item.contains("Video") { return "video.fill" }
        if item.contains("Song") { return "music.note" }
        
        return "star.fill"
    }
}

struct FallbackView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "sidebar.left")
                .font(.title2)
                .foregroundStyle(.blue)
            
            Text("NavigationSplitView")
                .font(.headline)
            
            Text("Available in iOS 16+")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(height: 120)
        .background(Color(.secondarySystemBackground))
    }
}

#Preview {
    ScrollView {
        NavigationSplitViewShowcase()
            .padding()
    }
} 