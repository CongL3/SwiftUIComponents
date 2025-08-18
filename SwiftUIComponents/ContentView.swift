//
//  ContentView.swift
//  SwiftUIComponents
//
//  Created by Cong Le on 18/08/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var componentRegistry = ComponentRegistry.shared
    
    var body: some View {
        NavigationView {
            ComponentCategoryListView()
                .navigationTitle("SwiftUI Components")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ComponentCategoryListView: View {
    @StateObject private var componentRegistry = ComponentRegistry.shared
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Header
                headerView
                
                // Component Categories
                ForEach(ComponentCategory.allCases, id: \.self) { category in
                    NavigationLink(destination: ComponentListView(category: category)) {
                        CategoryCardView(category: category)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            Image(systemName: "rectangle.3.group.bubble")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
            
            Text("SwiftUI Components")
                .font(.title)
                .fontWeight(.bold)
            
            Text("A showcase of reusable SwiftUI components")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            // Stats
            HStack(spacing: 24) {
                StatView(title: "Categories", value: "\(ComponentCategory.allCases.count)")
                StatView(title: "Components", value: "\(componentRegistry.totalComponentCount)")
                StatView(title: "Complete", value: "\(componentRegistry.completeComponentCount)")
            }
            .padding(.top, 8)
        }
        .padding(.vertical, 20)
    }
}

struct CategoryCardView: View {
    let category: ComponentCategory
    @StateObject private var componentRegistry = ComponentRegistry.shared
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: category.icon)
                .font(.title2)
                .foregroundStyle(category.color)
                .frame(width: 44, height: 44)
                .background(category.color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(category.rawValue)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    // Component count badge
                    Text("\(componentRegistry.componentCount(for: category))")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(category.color)
                        .clipShape(Capsule())
                }
                
                Text(categoryDescription(for: category))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            // Arrow
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private func categoryDescription(for category: ComponentCategory) -> String {
        switch category {
        case .buttons: return "Interactive buttons and action controls"
        case .inputs: return "Text fields, forms, and user input"
        case .layout: return "Containers and layout components"
        case .feedback: return "Progress indicators and notifications"
        case .navigation: return "Navigation bars and routing"
        case .media: return "Images, videos, and media content"
        case .advanced: return "Complex and specialized components"
        }
    }
}

struct ComponentListView: View {
    let category: ComponentCategory
    @StateObject private var componentRegistry = ComponentRegistry.shared
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if componentRegistry.components(for: category).isEmpty {
                    EmptyStateView(category: category)
                } else {
                    ForEach(componentRegistry.components(for: category)) { component in
                        NavigationLink(destination: ComponentDetailView(component: component)) {
                            ComponentRowView(component: component)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding()
        }
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemGroupedBackground))
    }
}

struct ComponentRowView: View {
    let component: ComponentModel
    
    var body: some View {
        HStack(spacing: 16) {
            // Status indicator
            Circle()
                .fill(component.isImplemented ? .green : .orange)
                .frame(width: 8, height: 8)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(component.displayName)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    // iOS version badge
                    Text("iOS \(component.minimumIOSVersion)+")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray5))
                        .clipShape(Capsule())
                }
                
                Text(component.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            // Arrow
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct ComponentDetailView: View {
    let component: ComponentModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: component.category.icon)
                        .font(.system(size: 60))
                        .foregroundStyle(component.category.color)
                    
                    Text(component.displayName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(component.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 20)
                
                // Implementation Status
                HStack {
                    Label(
                        component.isImplemented ? "Implemented" : "Coming Soon",
                        systemImage: component.isImplemented ? "checkmark.circle.fill" : "clock.fill"
                    )
                    .foregroundStyle(component.isImplemented ? .green : .orange)
                    
                    Spacer()
                    
                    Text("iOS \(component.minimumIOSVersion)+")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Live Preview (if implemented)
                if component.isImplemented {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Live Preview")
                            .font(.headline)
                        
                        componentPreview
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(component.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
    
    @ViewBuilder
    private var componentPreview: some View {
        switch component.id {
        case "CustomButton":
            buttonPreviewSection
        default:
            Text("Preview coming soon...")
                .foregroundStyle(.secondary)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var buttonPreviewSection: some View {
        VStack(spacing: 16) {
            // Primary Button
            CustomButton(configuration: CustomButtonConfiguration(
                title: "Primary Button",
                systemImage: "checkmark",
                style: .primary,
                action: { print("Primary tapped") }
            ))
            
            // Secondary Button
            CustomButton(configuration: CustomButtonConfiguration(
                title: "Secondary Button",
                systemImage: "arrow.right",
                style: .secondary,
                action: { print("Secondary tapped") }
            ))
            
            // Destructive Button
            CustomButton(configuration: CustomButtonConfiguration(
                title: "Delete Item",
                systemImage: "trash",
                style: .destructive,
                action: { print("Delete tapped") }
            ))
            
            // Custom Style Button
            CustomButton(configuration: CustomButtonConfiguration(
                title: "Custom Style",
                systemImage: "star.fill",
                backgroundColor: .purple,
                foregroundColor: .white,
                cornerRadius: 20,
                horizontalPadding: 24,
                verticalPadding: 16,
                action: { print("Custom tapped") }
            ))
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct EmptyStateView: View {
    let category: ComponentCategory
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "hammer.fill")
                .font(.system(size: 60))
                .foregroundStyle(.orange)
            
            Text("Components Coming Soon")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("\(category.rawValue) components are currently in development. Check back soon!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.vertical, 40)
    }
}

struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ContentView()
}
