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
        case .controls: return "Segmented controls, toggles, and selection"
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
                // Compact Header
                HStack(spacing: 12) {
                    Image(systemName: component.category.icon)
                        .font(.title2)
                        .foregroundStyle(component.category.color)
                        .frame(width: 32, height: 32)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(component.displayName)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(component.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 8)
                
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
                    
                    // Code Snippet
                    CodeSnippetView(component: component)
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
        case "CustomTextField":
            textFieldPreviewSection
        case "NativeSegmentedControlShowcase":
            segmentedControlPreviewSection
        case "CustomTabBar":
            tabBarPreviewSection
        case "CustomCard":
            cardPreviewSection
        case "ProgressIndicator":
            progressIndicatorPreviewSection
        case "NativeToggleShowcase":
            togglePreviewSection
        case "NativePickerShowcase":
            segmentedControlPreviewSection
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
        VStack(spacing: 0) {
            // Automatic Button Style
            NativeButtonExample(
                title: "Automatic Button Style",
                description: "iOS decides the best button appearance for context",
                label: "Automatic Button",
                style: .automatic
            )
            
            Divider()
                .padding(.horizontal)
            
            // Bordered Button Style
            NativeButtonExample(
                title: "Bordered Button Style",
                description: "Button with visible border - good for secondary actions",
                label: "Bordered Button",
                style: .bordered
            )
            
            Divider()
                .padding(.horizontal)
            
            // Bordered Prominent Button Style
            NativeButtonExample(
                title: "Bordered Prominent Button Style",
                description: "Prominent button with filled background - for primary actions",
                label: "Primary Action",
                style: .borderedProminent
            )
            
            Divider()
                .padding(.horizontal)
            
            // Plain Button Style
            NativeButtonExample(
                title: "Plain Button Style",
                description: "Minimal button style without background or border",
                label: "Plain Button",
                style: .plain
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var textFieldPreviewSection: some View {
        VStack(spacing: 16) {
            // Standard Style
            CustomTextField.standard(
                label: "Standard Style",
                placeholder: "Enter your name"
            )
            
            // Outlined Style
            CustomTextField.outlined(
                label: "Outlined Style",
                placeholder: "Enter your email"
            )
            
            // Filled Style
            CustomTextField.filled(
                label: "Filled Style",
                placeholder: "Enter your message"
            )
            
            // Email Field with Validation
            CustomTextField(configuration: CustomTextFieldConfiguration(
                label: "Email Address",
                placeholder: "user@example.com",
                helperText: "Required",
                errorMessage: "Please enter a valid email",
                style: .outlined,
                leadingIcon: "envelope",
                isRequired: true,
                keyboardType: .emailAddress,
                autocapitalization: .never,
                validator: { text in
                    text.contains("@") && text.contains(".")
                }
            ))
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var segmentedControlPreviewSection: some View {
        VStack(spacing: 0) {
            // Segmented Picker Style
            NativePickerExample(
                title: "Segmented Picker Style",
                description: "Native iOS segmented control - the classic style",
                options: ["First", "Second", "Third"],
                selectedIndex: 0,
                style: .segmented
            )
            
            Divider()
                .padding(.horizontal)
            
            // Menu Picker Style
            NativePickerExample(
                title: "Menu Picker Style", 
                description: "Dropdown menu picker - tap to see options",
                options: ["Option A", "Option B", "Option C"],
                selectedIndex: 1,
                style: .menu
            )
            
            Divider()
                .padding(.horizontal)
            
            // Wheel Picker Style
            NativePickerExample(
                title: "Wheel Picker Style",
                description: "Scrollable wheel picker - iOS classic",
                options: ["Home", "Search", "Profile"],
                selectedIndex: 0,
                style: .wheel
            )
            
            Divider()
                .padding(.horizontal)
            
            // Palette Picker Style (with SF Symbols)
            NativePalettePickerExample(
                title: "Palette Picker Style",
                description: "Symbol-based picker for icons and reactions"
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var tabBarPreviewSection: some View {
        VStack(spacing: 16) {
            // Segmented Style
            CustomTabBar.segmented(
                tabs: ["Home", "Search", "Profile"],
                selectedIndex: 0
            )
            
            // Floating Style
            CustomTabBar.floating(
                tabs: ["Dashboard", "Analytics", "Settings"],
                selectedIndex: 1
            )
            
            // Minimal Style
            CustomTabBar.minimal(
                tabs: ["Overview", "Details", "History"],
                selectedIndex: 0
            )
            
            // Pills Style
            CustomTabBar.pills(
                tabs: ["All", "Active", "Done"],
                selectedIndex: 2
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var cardPreviewSection: some View {
        VStack(spacing: 16) {
            // Simple Card
            CustomCard(
                configuration: CustomCardConfiguration(
                    title: "Simple Card",
                    style: .elevated
                )
            ) {
                Text("This is a simple card with basic content.")
                    .padding(.vertical, 8)
            }
            
            // Outlined Card with Progress
            CustomCard(
                configuration: CustomCardConfiguration(
                    title: "Project Status",
                    subtitle: "Development Progress",
                    style: .outlined
                )
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("The new feature is 80% complete.")
                        .font(.caption)
                    ProgressView(value: 0.8)
                        .tint(.blue)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var progressIndicatorPreviewSection: some View {
        VStack(spacing: 20) {
            // Linear Progress
            ProgressIndicator.linear(progress: 0.7, label: "Download Progress")
            
            HStack(spacing: 30) {
                // Circular Progress
                ProgressIndicator.circular(progress: 0.6)
                
                // Ring Progress with Center Text
                ProgressIndicator.ring(progress: 0.8)
            }
            
            // Dots Progress (Indeterminate)
            ProgressIndicator.dots()
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var togglePreviewSection: some View {
        VStack(spacing: 0) {
            // Automatic Toggle Style
            NativeToggleExample(
                title: "Automatic Toggle Style",
                description: "iOS decides the best toggle appearance for context",
                label: "Enable Notifications",
                isOn: true,
                style: .automatic
            )
            
            Divider()
                .padding(.horizontal)
            
            // Switch Toggle Style
            NativeToggleExample(
                title: "Switch Toggle Style",
                description: "Classic iOS switch - the most common toggle",
                label: "Dark Mode",
                isOn: false,
                style: .switch
            )
            
            Divider()
                .padding(.horizontal)
            
            // Button Toggle Style
            NativeToggleExample(
                title: "Button Toggle Style",
                description: "Toggle that appears as a tappable button",
                label: "Remember Me",
                isOn: true,
                style: .button
            )
            
            Divider()
                .padding(.horizontal)
            
            // Checkbox Toggle Style (macOS style, falls back on iOS)
            NativeToggleExample(
                title: "Checkbox Toggle Style",
                description: "Checkbox-style toggle (macOS native, fallback on iOS)",
                label: "Auto-Save",
                isOn: false,
                style: .checkbox
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // Note: Picker preview is now handled by segmentedControlPreviewSection
    // which shows different native iOS picker styles (.segmented, .menu, .wheel, .palette)
}

struct NativePickerExample: View {
    let title: String
    let description: String
    let options: [String]
    @State var selectedIndex: Int
    let style: PickerStyleType
    
    enum PickerStyleType {
        case segmented, menu, wheel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title and Description
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Native Picker with Different Styles
            Group {
                switch style {
                case .segmented:
                    Picker("Options", selection: $selectedIndex) {
                        ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                            Text(option).tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                case .menu:
                    Picker("Options", selection: $selectedIndex) {
                        ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                            Text(option).tag(index)
                        }
                    }
                    .pickerStyle(.menu)
                    
                case .wheel:
                    Picker("Options", selection: $selectedIndex) {
                        ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                            Text(option).tag(index)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 80)
                }
            }
            
            // Current Selection Display
            Text("Selected: \(options[selectedIndex])")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

struct NativePalettePickerExample: View {
    let title: String
    let description: String
    @State private var selectedReaction: String = "heart"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title and Description
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Palette Picker with SF Symbols
            Menu("Reactions") {
                Picker("Reaction", selection: $selectedReaction) {
                    Label("Heart", systemImage: "heart")
                        .tag("heart")
                    Label("Thumbs Up", systemImage: "hand.thumbsup")
                        .tag("thumbsup")
                    Label("Star", systemImage: "star")
                        .tag("star")
                    Label("Smile", systemImage: "face.smiling")
                        .tag("smile")
                }
                .pickerStyle(.palette)
            }
            .buttonStyle(.bordered)
            
            // Current Selection Display
            Text("Selected: \(selectedReaction)")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

// MARK: - Code Snippet Helper

struct CodeSnippetView: View {
    let component: ComponentModel
    @State private var showingCode = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Code Example")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    showingCode.toggle()
                }) {
                    Image(systemName: showingCode ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.secondary)
                }
            }
            
            if showingCode {
                ScrollView(.horizontal, showsIndicators: false) {
                    Text(codeSnippet)
                        .font(.system(.caption, design: .monospaced))
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var codeSnippet: String {
        switch component.id {
        case "CustomButton":
            return """
// Standard Button
CustomButton.standard(
    title: "Click Me",
    systemImage: "star.fill"
) {
    print("Button tapped!")
}

// Custom Configuration
CustomButton(configuration: CustomButtonConfiguration(
    title: "Custom Style",
    backgroundColor: .purple,
    cornerRadius: 20
))
"""
        
        case "CustomTextField":
            return """
// Standard Text Field
CustomTextField.standard(
    label: "Email",
    placeholder: "Enter your email"
) { text in
    print("Text changed: \\(text)")
}

// With Validation
CustomTextField(configuration: CustomTextFieldConfiguration(
    label: "Email Address",
    placeholder: "user@example.com",
    leadingIcon: "envelope",
    keyboardType: .emailAddress,
    validator: { text in
        text.contains("@") && text.contains(".")
    }
))
"""
        
        case "NativeSegmentedControlShowcase":
            return """
// Native iOS Segmented Picker
Picker("Options", selection: $selectedValue) {
    Text("First").tag("first")
    Text("Second").tag("second")
    Text("Third").tag("third")
}
.pickerStyle(.segmented)

// Pills Style
CustomSegmentedControl.pills(
    segments: ["Option A", "Option B", "Option C"]
)

// With Icons and Badges
CustomSegmentedControl(configuration: CustomSegmentedControlConfiguration(
    segments: [
        SegmentItem(title: "Home", icon: "house"),
        SegmentItem(title: "Messages", icon: "message", badge: 3),
        SegmentItem(title: "Profile", icon: "person")
    ],
    style: .pills
))
"""
        
        case "CustomTabBar":
            return """
// Segmented Tab Bar
CustomTabBar.segmented(
    tabs: ["Home", "Search", "Profile"],
    selectedIndex: 0
) { index in
    print("Tab selected: \\(index)")
}

// Floating Style
CustomTabBar.floating(
    tabs: ["Dashboard", "Analytics", "Settings"]
)

// With Icons and Badges
CustomTabBar(configuration: CustomTabBarConfiguration(
    tabs: [
        TabItem(title: "Home", icon: "house"),
        TabItem(title: "Messages", icon: "message", badge: 5),
        TabItem(title: "Profile", icon: "person")
    ],
    style: .segmented,
    showLabels: true
))
"""
        
        case "CustomCard":
            return """
// Simple Card
CustomCard(
    configuration: CustomCardConfiguration(
        title: "Card Title",
        style: .elevated
    )
) {
    Text("Your content goes here")
        .padding(.vertical, 8)
}

// Outlined Card with Subtitle
CustomCard(
    configuration: CustomCardConfiguration(
        title: "Project Status",
        subtitle: "Development Progress",
        style: .outlined
    )
) {
    VStack(alignment: .leading, spacing: 8) {
        Text("Feature is 80% complete")
        ProgressView(value: 0.8)
    }
}
"""
        
        case "ProgressIndicator":
            return """
// Linear Progress with Label
ProgressIndicator.linear(
    progress: 0.7,
    label: "Download Progress"
)

// Circular Progress
ProgressIndicator.circular(progress: 0.6)

// Ring Progress with Center Text
ProgressIndicator.ring(progress: 0.8)

// Animated Dots (Indeterminate)
ProgressIndicator.dots()
"""
        
        case "NativeToggleShowcase":
            return """
// Native iOS Toggle (Automatic Style)
Toggle("Enable Notifications", isOn: $isEnabled)
    .toggleStyle(.automatic)

// Native iOS Switch Style
Toggle("Dark Mode", isOn: $isDarkMode)
    .toggleStyle(.switch)

// Native iOS Button Style
CustomToggle.checkbox(
    label: "Remember Me",
    isOn: true
)
"""
        
        case "NativePickerShowcase":
            return """
// Native Segmented Picker (like your example!)
Picker("Favorite Color", selection: $selectedColor) {
    Text("Red").tag("red")
    Text("Green").tag("green")
    Text("Blue").tag("blue")
}
.pickerStyle(.segmented)

// Native Menu Picker
Picker("Size", selection: $selectedSize) {
    Text("Small").tag("small")
    Text("Medium").tag("medium")
    Text("Large").tag("large")
}
.pickerStyle(.menu)

// Native Wheel Picker
Picker("Priority", selection: $selectedPriority) {
    options: ["Low", "Medium", "High", "Critical"]
)

// Native Wheel Picker
CustomPicker.wheel(
    label: "Age",
    options: Array(18...100).map { "\\($0)" }
)
"""
        
        default:
            return "// Code example coming soon..."
        }
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

// MARK: - Native Component Examples

struct NativeButtonExample: View {
    let title: String
    let description: String
    let label: String
    let style: ButtonStyleType
    @State private var tapCount: Int = 0
    
    enum ButtonStyleType {
        case automatic, bordered, borderedProminent, plain
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title and Description
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Native Button with Different Styles
            Group {
                switch style {
                case .automatic:
                    Button(label) {
                        tapCount += 1
                    }
                    .buttonStyle(.automatic)
                    
                case .bordered:
                    Button(label) {
                        tapCount += 1
                    }
                    .buttonStyle(.bordered)
                    
                case .borderedProminent:
                    Button(label) {
                        tapCount += 1
                    }
                    .buttonStyle(.borderedProminent)
                    
                case .plain:
                    Button(label) {
                        tapCount += 1
                    }
                    .buttonStyle(.plain)
                }
            }
            
            // Interaction Feedback
            Text("Tapped: \(tapCount) times")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

struct NativeToggleExample: View {
    let title: String
    let description: String
    let label: String
    @State var isOn: Bool
    let style: ToggleStyleType
    
    enum ToggleStyleType {
        case automatic, `switch`, button, checkbox
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title and Description
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Native Toggle with Different Styles
            Group {
                switch style {
                case .automatic:
                    Toggle(label, isOn: $isOn)
                        .toggleStyle(.automatic)
                        
                case .switch:
                    Toggle(label, isOn: $isOn)
                        .toggleStyle(.switch)
                        
                case .button:
                    Toggle(label, isOn: $isOn)
                        .toggleStyle(.button)
                        
                case .checkbox:
                    Toggle(label, isOn: $isOn)
                        .toggleStyle(.switch) // Fallback to switch on iOS
                }
            }
            
            // Current State Display
            Text("Status: \(isOn ? "ON" : "OFF")")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
