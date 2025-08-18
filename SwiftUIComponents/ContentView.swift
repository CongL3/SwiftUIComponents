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
                // Compact Header - Keep only description
                VStack(alignment: .leading, spacing: 8) {
                    Text(component.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGroupedBackground))
                

                
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
        // Button Components
        case "StandardButtons":
            standardButtonsPreviewSection
        case "ButtonSizes":
            buttonSizesPreviewSection  
        case "SpecialButtons":
            specialButtonsPreviewSection
        case "ButtonsWithIcons":
            buttonsWithIconsPreviewSection
        
        // Text Input Components  
        case "BasicTextFields":
            basicTextFieldsPreviewSection
        case "KeyboardTypes":
            keyboardTypesPreviewSection
        case "TextContentTypes":
            textContentTypesPreviewSection
        case "SecureFields":
            secureFieldsPreviewSection
        case "TextEditors":
            textEditorsPreviewSection
        case "SearchFields":
            searchFieldsPreviewSection
            
        // Legacy components (to be removed)
        case "NativeButtonShowcase":
            standardButtonsPreviewSection
        case "NativeTextFieldShowcase":
            basicTextFieldsPreviewSection
        case "NativeTabViewShowcase":
            tabViewPreviewSection
        case "NativeSegmentedControlShowcase":
            segmentedControlPreviewSection

        case "CustomCard":
            cardPreviewSection
        case "ProgressIndicator":
            progressIndicatorPreviewSection
        case "NativeToggleShowcase":
            togglePreviewSection
        case "NativePickerShowcase":
            segmentedControlPreviewSection
        case "NativeDatePickerShowcase":
            datePickerPreviewSection
        case "NativeStepperShowcase":
            stepperPreviewSection
        case "NativeTextEditorShowcase":
            textEditorPreviewSection
        case "NativeSecureFieldShowcase":
            secureFieldPreviewSection
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
                description: "System default button style",
                style: .automatic,
                text: "Automatic Style"
            )
            
            Divider()
                .padding(.horizontal)
            
            // Bordered Button Style
            NativeButtonExample(
                title: "Bordered Button Style",
                description: "Button with border outline",
                style: .bordered,
                text: "Bordered Style"
            )
            
            Divider()
                .padding(.horizontal)
            
            // Bordered Prominent Button Style
            NativeButtonExample(
                title: "Bordered Prominent Button Style",
                description: "Prominent button with filled background",
                style: .borderedProminent,
                text: "Bordered Prominent"
            )
            
            Divider()
                .padding(.horizontal)
            
            // Plain Button Style
            NativeButtonExample(
                title: "Plain Button Style",
                description: "Minimal button without styling",
                style: .plain,
                text: "Plain Style"
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var textFieldPreviewSection: some View {
        VStack(spacing: 0) {
            // Standard TextField
            NativeTextFieldExample(
                title: "Standard TextField",
                description: "Plain text field with system background",
                style: .standard
            )
            
            Divider()
                .padding(.horizontal)
            
            // Rounded Border TextField
            NativeTextFieldExample(
                title: "Rounded Border TextField",
                description: "Text field with rounded border style",
                style: .roundedBorder
            )
            
            Divider()
                .padding(.horizontal)
            
            // Email TextField
            NativeTextFieldExample(
                title: "Email TextField",
                description: "Email input with appropriate keyboard",
                style: .email
            )
            
            Divider()
                .padding(.horizontal)
            
            // Search TextField
            NativeTextFieldExample(
                title: "Search TextField",
                description: "Search field with clear button",
                style: .search
            )
            
            Divider()
                .padding(.horizontal)
            
            // Number TextField
            NativeTextFieldExample(
                title: "Number TextField",
                description: "Numeric input with number pad",
                style: .number
            )
        }
    }
    
    // MARK: - Button Preview Sections
    
    private var standardButtonsPreviewSection: some View {
        VStack(spacing: 0) {
            NativeButtonExample(
                title: "Automatic Button Style",
                description: "System default button style",
                style: .automatic,
                text: "Automatic Style"
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeButtonExample(
                title: "Bordered Button Style", 
                description: "Button with border outline",
                style: .bordered,
                text: "Bordered Style"
            )
            
            Divider()
                .padding(.horizontal)
                
            NativeButtonExample(
                title: "Bordered Prominent Button Style",
                description: "Prominent button with filled background", 
                style: .borderedProminent,
                text: "Bordered Prominent"
            )
            
            Divider()
                .padding(.horizontal)
                
            NativeButtonExample(
                title: "Plain Button Style",
                description: "Minimal button without styling",
                style: .plain, 
                text: "Plain Style"
            )
        }
    }
    
    private var buttonSizesPreviewSection: some View {
        VStack(spacing: 0) {
            NativeButtonSizeExample(
                title: "Button Control Sizes",
                description: "Different native button sizes available in iOS"
            )
        }
    }
    
    private var specialButtonsPreviewSection: some View {
        VStack(spacing: 0) {
            NativeSpecialButtonExample(
                title: "Destructive Button",
                description: "Button with destructive role for dangerous actions",
                type: .destructive
            )
            
            Divider()
                .padding(.horizontal)
                
            NativeSpecialButtonExample(
                title: "Disabled Button", 
                description: "Button in disabled state",
                type: .disabled
            )
            
            Divider()
                .padding(.horizontal)
                
            NativeSpecialButtonExample(
                title: "Cancel Button Role",
                description: "Button with cancel role for dismissive actions",
                type: .cancel
            )
        }
    }
    
    private var buttonsWithIconsPreviewSection: some View {
        VStack(spacing: 0) {
            NativeIconButtonExample(
                title: "Button with Leading Icon",
                description: "Native button with SF Symbol on the left",
                iconPosition: .leading,
                icon: "arrow.down.circle",
                text: "Download"
            )
            
            Divider()
                .padding(.horizontal)
                
            NativeIconButtonExample(
                title: "Button with Trailing Icon",
                description: "Native button with SF Symbol on the right", 
                iconPosition: .trailing,
                icon: "arrow.right",
                text: "Continue"
            )
            
            Divider()
                .padding(.horizontal)
                
            NativeIconButtonExample(
                title: "Icon Only Button",
                description: "Native button with only SF Symbol",
                iconPosition: .iconOnly,
                icon: "heart.fill",
                text: ""
            )
        }
    }
    
    // MARK: - Text Input Preview Sections
    
    private var basicTextFieldsPreviewSection: some View {
        VStack(spacing: 0) {
            NativeTextFieldExample(
                title: "Plain TextField Style",
                description: "Plain text field with system background",
                style: .standard
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeTextFieldExample(
                title: "Rounded Border TextField Style", 
                description: "Text field with rounded border style",
                style: .roundedBorder
            )
        }
    }
    
    private var keyboardTypesPreviewSection: some View {
        VStack(spacing: 0) {
            NativeKeyboardTypeExample(
                title: "Email Address Keyboard",
                description: "Optimized keyboard for email input",
                keyboardType: .emailAddress,
                placeholder: "Enter email address"
            )
            
            Divider()
                .padding(.horizontal)
                
            NativeKeyboardTypeExample(
                title: "Number Pad Keyboard",
                description: "Numeric keypad for number input",
                keyboardType: .numberPad,
                placeholder: "Enter number"
            )
            
            Divider()
                .padding(.horizontal)
                
            NativeKeyboardTypeExample(
                title: "Phone Pad Keyboard", 
                description: "Phone number keypad with letters",
                keyboardType: .phonePad,
                placeholder: "Enter phone number"
            )
            
            Divider()
                .padding(.horizontal)
                
            NativeKeyboardTypeExample(
                title: "URL Keyboard",
                description: "Optimized keyboard for URL input",
                keyboardType: .URL,
                placeholder: "Enter website URL"
            )
            
            Divider()
                .padding(.horizontal)
                
            NativeKeyboardTypeExample(
                title: "Decimal Pad Keyboard",
                description: "Numeric keypad with decimal point",
                keyboardType: .decimalPad,
                placeholder: "Enter decimal number"
            )
        }
    }
    
    private var textContentTypesPreviewSection: some View {
        VStack(spacing: 0) {
            NativeTextContentTypeExample(
                title: "Username Content Type",
                description: "TextField optimized for username AutoFill",
                contentType: .username,
                placeholder: "Username"
            )
            
            Divider()
                .padding(.horizontal)
                
            NativeTextContentTypeExample(
                title: "Name Content Type",
                description: "TextField for full name with AutoFill",
                contentType: .name,
                placeholder: "Full Name"
            )
            
            Divider()
                .padding(.horizontal)
                
            NativeTextContentTypeExample(
                title: "Email Address Content Type",
                description: "TextField for email with AutoFill",
                contentType: .emailAddress,
                placeholder: "Email Address"
            )
            
            Divider()
                .padding(.horizontal)
                
            NativeTextContentTypeExample(
                title: "Street Address Content Type",
                description: "TextField for street address with AutoFill",
                contentType: .streetAddressLine1,
                placeholder: "Street Address"
            )
            
            Divider()
                .padding(.horizontal)
                
            NativeTextContentTypeExample(
                title: "Credit Card Number Content Type",
                description: "TextField for credit card with AutoFill",
                contentType: .creditCardNumber,
                placeholder: "Card Number"
            )
        }
    }
    
    private var secureFieldsPreviewSection: some View {
        VStack(spacing: 0) {
            NativeSecureFieldExample(
                title: "Basic Secure Field",
                description: "Standard password input field",
                hasToggle: false
            )
            
            Divider()
                .padding(.horizontal)
                
            NativeSecureFieldExample(
                title: "Secure Field with Visibility Toggle",
                description: "Password field with show/hide functionality",
                hasToggle: true
            )
        }
    }
    
    private var textEditorsPreviewSection: some View {
        VStack(spacing: 0) {
            NativeTextEditorExample(
                title: "Basic Text Editor",
                description: "Multiline text input for longer content",
                style: .basic
            )
            
            Divider()
                .padding(.horizontal)
                
            NativeTextEditorExample(
                title: "Text Editor with Placeholder",
                description: "Text editor with placeholder text",
                style: .withPlaceholder
            )
        }
    }
    
    private var searchFieldsPreviewSection: some View {
        VStack(spacing: 0) {
            NativeSearchFieldExample(
                title: "Searchable List",
                description: "Native iOS searchable functionality",
                style: .list
            )
            
            Divider()
                .padding(.horizontal)
                
            NativeSearchFieldExample(
                title: "Search with Suggestions",
                description: "Search field with autocomplete suggestions",
                style: .withSuggestions
            )
        }
    }
    
    private var tabViewPreviewSection: some View {
        VStack(spacing: 0) {
            // Standard TabView
            NativeTabViewExample(
                title: "Standard TabView",
                description: "Standard tab bar with icons and labels",
                style: .standard
            )
            
            Divider()
                .padding(.horizontal)
            
            // Page TabView
            NativeTabViewExample(
                title: "Page TabView Style",
                description: "Page-style TabView with page indicators",
                style: .page
            )
            
            Divider()
                .padding(.horizontal)
            
            // Page TabView with Always Visible Indicators
            NativeTabViewExample(
                title: "Page TabView with Always Visible Indicators",
                description: "Page indicators always visible",
                style: .pageAlwaysVisible
            )
        }
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
                style: .automatic
            )
            
            Divider()
                .padding(.horizontal)
            
            // Switch Toggle Style
            NativeToggleExample(
                title: "Switch Toggle Style",
                description: "Classic iOS switch - the most common toggle",
                style: .switch
            )
            
            Divider()
                .padding(.horizontal)
            
            // Button Toggle Style
            NativeToggleExample(
                title: "Button Toggle Style",
                description: "Toggle that appears as a tappable button",
                style: .button
            )
            
            Divider()
                .padding(.horizontal)
            
            // Checkbox Toggle Style (macOS style, falls back on iOS)
            NativeToggleExample(
                title: "Checkbox Toggle Style",
                description: "Checkbox-style toggle (macOS native, fallback on iOS)",
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
                
                if showingCode {
                    Button(action: {
                        copyToClipboard()
                    }) {
                        Label("Copy", systemImage: "doc.on.doc")
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
                
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
    
    private func copyToClipboard() {
        #if os(iOS)
        UIPasteboard.general.string = codeSnippet
        #endif
    }
    
    private var codeSnippet: String {
        switch component.id {
        case "NativeButtonShowcase":
            return """
// Native Button Styles
Button("Automatic Style") {
    // Action
}
.buttonStyle(.automatic)

Button("Bordered Style") {
    // Action
}
.buttonStyle(.bordered)

Button("Bordered Prominent") {
    // Action
}
.buttonStyle(.borderedProminent)

Button("Plain Style") {
    // Action
}
.buttonStyle(.plain)

// Button with Icon
Button(action: {
    // Action
}) {
    Label("Download", systemImage: "arrow.down.circle")
}
.buttonStyle(.borderedProminent)

// Destructive Button
Button("Delete", role: .destructive) {
    // Destructive action
}
.buttonStyle(.borderedProminent)
"""
        
        case "NativeTextFieldShowcase":
            return """
// Native TextField Styles
TextField("Enter text", text: $text)
    .textFieldStyle(.plain)

TextField("Enter email", text: $emailText)
    .textFieldStyle(.roundedBorder)
    .keyboardType(.emailAddress)
    .textContentType(.emailAddress)
    .autocapitalization(.none)

TextField("Enter number", text: $numberText)
    .textFieldStyle(.roundedBorder)
    .keyboardType(.numberPad)

// Search TextField with Clear Button
TextField("Search", text: $searchText)
    .textFieldStyle(.roundedBorder)
    .overlay(
        HStack {
            Spacer()
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                }
            }
        }
    )
"""
        
        case "NativeTabViewShowcase":
            return """
// Standard TabView
TabView(selection: $selectedTab) {
    Text("Home Content")
        .tabItem {
            Image(systemName: "house")
            Text("Home")
        }
        .tag(0)
    
    Text("Search Content")
        .tabItem {
            Image(systemName: "magnifyingglass")
            Text("Search")
        }
        .tag(1)
}

// Page TabView
TabView {
    Text("Page 1")
    Text("Page 2") 
    Text("Page 3")
}
.tabViewStyle(.page)

// Page TabView with Always Visible Indicators
TabView {
    Text("Card 1")
    Text("Card 2")
    Text("Card 3")
}
.tabViewStyle(.page(indexDisplayMode: .always))
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
        
        case "NativeDatePickerShowcase":
            return """
// Native Compact DatePicker
DatePicker(
    "Event Date",
    selection: $selectedDate,
    displayedComponents: [.date]
)
.datePickerStyle(.compact)

// Native Wheel DatePicker  
DatePicker(
    "Appointment Time",
    selection: $selectedDateTime,
    displayedComponents: [.date, .hourAndMinute]
)
.datePickerStyle(.wheel)
.frame(height: 120)

// Native Graphical DatePicker
DatePicker(
    "Calendar Date",
    selection: $selectedDate,
    displayedComponents: [.date]
)
.datePickerStyle(.graphical)
"""
        
        case "NativeStepperShowcase":
            return """
// Native Standard Stepper
Stepper("Quantity", value: $quantity, in: 0...20, step: 1)

// Native Stepper with Value Display
Stepper("Temperature: \\(temperature, specifier: "%.1f")", 
        value: $temperature, in: -10...40, step: 0.5)

// Native Stepper with Labels Hidden
Stepper("Volume", value: $volume, in: 0...100, step: 5)
    .labelsHidden()

// Native Custom Format Stepper
Stepper(value: $rating, in: 0...5, step: 0.5) {
    HStack {
        Text("Rating")
        Spacer()
        Text("\\(rating, specifier: "%.1f") ⭐")
    }
}
"""
        
        case "NativeTextEditorShowcase":
            return """
// Native Standard TextEditor
TextEditor(text: $notes)
    .frame(height: 120)

// Native Bordered TextEditor  
TextEditor(text: $comments)
    .padding(8)
    .background(Color(.systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .overlay(
        RoundedRectangle(cornerRadius: 8)
            .stroke(isFocused ? .blue : .gray, lineWidth: 1)
    )

// Native Backgrounded TextEditor
TextEditor(text: $description)
    .padding(12)
    .scrollContentBackground(.hidden)
    .background(Color(.systemGray6))
    .clipShape(RoundedRectangle(cornerRadius: 12))
"""
        
        case "NativeSecureFieldShowcase":
            return """
// Native Standard SecureField
SecureField("Enter password", text: $password)

// Native Bordered SecureField
SecureField("Current password", text: $currentPassword)
    .padding(12)
    .background(Color(.systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .overlay(
        RoundedRectangle(cornerRadius: 8)
            .stroke(isFocused ? .blue : .gray, lineWidth: 1)
    )

// Native SecureField with Visibility Toggle
HStack {
    if isVisible {
        TextField("New password", text: $newPassword)
    } else {
        SecureField("New password", text: $newPassword)
    }
    Button(action: { isVisible.toggle() }) {
        Image(systemName: isVisible ? "eye.slash" : "eye")
    }
}
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
    
    private var datePickerPreviewSection: some View {
        VStack(spacing: 0) {
            // Compact DatePicker Style
            NativeDatePickerExample(
                title: "Compact DatePicker Style",
                description: "Compact button that expands to show date picker - great for forms",
                label: "Event Date",
                displayedComponents: [.date],
                style: .compact
            )
            
            Divider()
                .padding(.horizontal)
            
            // Wheel DatePicker Style
            NativeDatePickerExample(
                title: "Wheel DatePicker Style",
                description: "Traditional iOS spinning wheel date picker",
                label: "Appointment Time",
                displayedComponents: [.date, .hourAndMinute],
                style: .wheel
            )
            
            Divider()
                .padding(.horizontal)
            
            // Graphical DatePicker Style
            NativeDatePickerExample(
                title: "Graphical DatePicker Style",
                description: "Calendar-style graphical date picker - perfect for date selection",
                label: "Calendar Date",
                displayedComponents: [.date],
                style: .graphical
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var stepperPreviewSection: some View {
        VStack(spacing: 0) {
            // Standard Stepper
            NativeStepperExample(
                title: "Standard Stepper Style",
                description: "Standard stepper with label - perfect for quantity selection",
                label: "Quantity",
                value: 5,
                range: 0...20,
                step: 1,
                displayStyle: .withLabel
            )
            
            Divider()
                .padding(.horizontal)
            
            // Value Display Stepper
            NativeStepperExample(
                title: "With Value Display",
                description: "Shows current value in the label - great for settings",
                label: "Temperature",
                value: 20,
                range: -10...40,
                step: 0.5,
                displayStyle: .withValue
            )
            
            Divider()
                .padding(.horizontal)
            
            // Labels Hidden Stepper
            NativeStepperExample(
                title: "Labels Hidden Style",
                description: "Compact stepper with hidden labels - space-efficient",
                label: "Volume",
                value: 50,
                range: 0...100,
                step: 5,
                displayStyle: .labelsHidden
            )
            
            Divider()
                .padding(.horizontal)
            
            // Custom Format Stepper
            NativeStepperExample(
                title: "Custom Format Style",
                description: "Custom formatted display with separate value - highly flexible",
                label: "Rating",
                value: 3.5,
                range: 0...5,
                step: 0.5,
                displayStyle: .customFormat
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var textEditorPreviewSection: some View {
        VStack(spacing: 0) {
            // Standard TextEditor
            NativeTextEditorExample(
                title: "Standard TextEditor Style",
                description: "Standard multiline text editor - perfect for notes and descriptions",
                style: .basic
            )
            
            Divider()
                .padding(.horizontal)
            
            // Bordered TextEditor
            NativeTextEditorExample(
                title: "TextEditor with Placeholder",
                description: "TextEditor with placeholder text when empty",
                style: .withPlaceholder
            )
            
            Divider()
                .padding(.horizontal)
            
            // Basic TextEditor
            NativeTextEditorExample(
                title: "Basic TextEditor Style",
                description: "Simple TextEditor with no special styling",
                style: .basic
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var secureFieldPreviewSection: some View {
        VStack(spacing: 0) {
            // Standard SecureField
            NativeSecureFieldExample(
                title: "Standard SecureField Style",
                description: "Standard password field with hidden text - basic security",
                hasToggle: false
            )
            
            Divider()
                .padding(.horizontal)
            
            // SecureField with Toggle
            NativeSecureFieldExample(
                title: "SecureField with Visibility Toggle",
                description: "SecureField with show/hide password toggle button",
                hasToggle: true
            )
            
            Divider()
                .padding(.horizontal)
            
            // Basic SecureField
            NativeSecureFieldExample(
                title: "Basic SecureField",
                description: "Simple SecureField without visibility toggle",
                hasToggle: false
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

// MARK: - Helper Example Structs for Native Components

// MARK: - Button Helper Structs

enum NativeButtonExampleStyle {
    case automatic, bordered, borderedProminent, plain
}

struct NativeButtonExample: View {
    let title: String
    let description: String
    let style: NativeButtonExampleStyle
    let text: String
    
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
            
            switch style {
            case .automatic:
                Button(text) {
                    // Action
                }
                .buttonStyle(.automatic)
            case .bordered:
                Button(text) {
                    // Action
                }
                .buttonStyle(.bordered)
            case .borderedProminent:
                Button(text) {
                    // Action
                }
                .buttonStyle(.borderedProminent)
            case .plain:
                Button(text) {
                    // Action
                }
                .buttonStyle(.plain)
            }
            
            Text("Tap to interact")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
    

}

struct NativeButtonSizeExample: View {
    let title: String
    let description: String
    
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
            
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    Button("Mini") { }
                        .buttonStyle(.bordered)
                        .controlSize(.mini)
                    
                    Button("Small") { }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    
                    Button("Regular") { }
                        .buttonStyle(.bordered)
                        .controlSize(.regular)
                    
                    Button("Large") { }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                }
                
                Text("All native iOS control sizes")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
    }
}

enum NativeSpecialButtonType {
    case destructive, disabled, cancel
}

struct NativeSpecialButtonExample: View {
    let title: String
    let description: String
    let type: NativeSpecialButtonType
    
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
            
            switch type {
            case .destructive:
                Button("Delete", role: .destructive) {
                    // Destructive action
                }
                .buttonStyle(.borderedProminent)
                
            case .disabled:
                Button("Disabled Button") {
                    // Action
                }
                .buttonStyle(.borderedProminent)
                .disabled(true)
                
            case .cancel:
                Button("Cancel", role: .cancel) {
                    // Cancel action
                }
                .buttonStyle(.bordered)
            }
            
            Text("Native button role and state")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

enum NativeIconButtonPosition {
    case leading, trailing, iconOnly
}

struct NativeIconButtonExample: View {
    let title: String
    let description: String
    let iconPosition: NativeIconButtonPosition
    let icon: String
    let text: String
    
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
            
            switch iconPosition {
            case .leading:
                Button(action: {}) {
                    Label(text, systemImage: icon)
                }
                .buttonStyle(.borderedProminent)
                
            case .trailing:
                Button(action: {}) {
                    HStack {
                        Text(text)
                        Image(systemName: icon)
                    }
                }
                .buttonStyle(.borderedProminent)
                
            case .iconOnly:
                Button(action: {}) {
                    Image(systemName: icon)
                }
                .buttonStyle(.borderedProminent)
            }
            
            Text("Native button with SF Symbols")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

// MARK: - Text Input Helper Structs

struct NativeKeyboardTypeExample: View {
    let title: String
    let description: String
    let keyboardType: UIKeyboardType
    let placeholder: String
    @State private var text: String = ""
    
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
            
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .keyboardType(keyboardType)
            
            Text("Keyboard type: \(keyboardTypeString)")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
    
    private var keyboardTypeString: String {
        switch keyboardType {
        case .emailAddress: return ".emailAddress"
        case .numberPad: return ".numberPad"
        case .phonePad: return ".phonePad"
        case .URL: return ".URL"
        case .decimalPad: return ".decimalPad"
        default: return ".default"
        }
    }
}

struct NativeTextContentTypeExample: View {
    let title: String
    let description: String
    let contentType: UITextContentType
    let placeholder: String
    @State private var text: String = ""
    
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
            
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .textContentType(contentType)
                .autocapitalization(autocapitalization)
            
            Text("Content type: \(contentTypeString)")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
    
    private var contentTypeString: String {
        switch contentType {
        case .username: return ".username"
        case .name: return ".name"
        case .emailAddress: return ".emailAddress"
        case .streetAddressLine1: return ".streetAddressLine1"
        case .creditCardNumber: return ".creditCardNumber"
        default: return "custom"
        }
    }
    
    private var autocapitalization: UITextAutocapitalizationType {
        switch contentType {
        case .emailAddress, .username: return .none
        case .name: return .words
        default: return .sentences
        }
    }
}

struct NativeSecureFieldExample: View {
    let title: String
    let description: String
    let hasToggle: Bool
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
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
            
            if hasToggle {
                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                    } else {
                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            
            Text("Native SecureField component")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

enum NativeTextEditorExampleStyle {
    case basic, withPlaceholder
}

struct NativeTextEditorExample: View {
    let title: String
    let description: String
    let style: NativeTextEditorExampleStyle
    @State private var text: String = ""
    
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
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .frame(height: 100)
                    .padding(4)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                if style == .withPlaceholder && text.isEmpty {
                    Text("Enter your thoughts here...")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                        .allowsHitTesting(false)
                }
            }
            
            Text("Native TextEditor for multiline input")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

enum NativeSearchFieldExampleStyle {
    case list, withSuggestions
}

struct NativeSearchFieldExample: View {
    let title: String
    let description: String
    let style: NativeSearchFieldExampleStyle
    @State private var searchText: String = ""
    @State private var items = ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape"]
    
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
            
            VStack {
                switch style {
                case .list:
                    List(filteredItems, id: \.self) { item in
                        Text(item)
                    }
                    .searchable(text: $searchText, prompt: "Search items")
                    .frame(height: 150)
                    
                case .withSuggestions:
                    VStack {
                        TextField("Search with suggestions", text: $searchText)
                            .textFieldStyle(.roundedBorder)
                        
                        if !searchText.isEmpty {
                            ScrollView {
                                LazyVStack(alignment: .leading, spacing: 4) {
                                    ForEach(filteredItems, id: \.self) { item in
                                        Button(item) {
                                            searchText = item
                                        }
                                        .foregroundStyle(.primary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                            .frame(height: 100)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
            
            Text("Native iOS search functionality")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
    
    private var filteredItems: [String] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

// MARK: - Existing Helper Structs (for legacy components)

public enum NativeToggleStyle {
    case automatic, `switch`, button, checkbox
}

struct NativeToggleExample: View {
    let title: String
    let description: String
    let style: NativeToggleStyle
    @State private var isOn: Bool = false
    
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
            
            switch style {
            case .automatic:
                Toggle("Toggle", isOn: $isOn)
                    .toggleStyle(.automatic)
            case .switch:
                Toggle("Toggle", isOn: $isOn)
                    .toggleStyle(.switch)
            case .button:
                Toggle("Toggle", isOn: $isOn)
                    .toggleStyle(.button)
            case .checkbox:
                Toggle("Toggle", isOn: $isOn)
                    .toggleStyle(.switch) // Fallback to switch on iOS
            }
            
            Text("Status: \(isOn ? "ON" : "OFF")")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
    

}

public enum NativeDatePickerStyle {
    case compact, wheel, graphical
}

struct NativeDatePickerExample: View {
    let title: String
    let description: String
    let label: String
    let displayedComponents: DatePicker.Components
    let style: NativeDatePickerStyle
    @State private var selectedDate: Date = Date()
    
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
            
            switch style {
            case .compact:
                DatePicker(label, selection: $selectedDate, displayedComponents: displayedComponents)
                    .datePickerStyle(.compact)
                
            case .wheel:
                DatePicker(label, selection: $selectedDate, displayedComponents: displayedComponents)
                    .datePickerStyle(.wheel)
                    .frame(height: 120)
                    .labelsHidden()
                
            case .graphical:
                DatePicker(label, selection: $selectedDate, displayedComponents: displayedComponents)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
            }
            
            Text("Selected: \(selectedDate, formatter: dateFormatter)")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        if displayedComponents.contains(.hourAndMinute) {
            formatter.timeStyle = .short
        }
        return formatter
    }
}

enum NativeTextFieldStyle {
    case standard, roundedBorder, email, search, number
}

struct NativeTextFieldExample: View {
    let title: String
    let description: String
    let style: NativeTextFieldStyle
    @State private var text: String = ""
    @State private var emailText: String = ""
    @State private var numberText: String = ""
    @State private var searchText: String = ""
    @FocusState private var isFocused: Bool
    
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
            
            // Native TextField Examples
            switch style {
            case .standard:
                TextField("Enter text", text: $text)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
            case .roundedBorder:
                TextField("Enter text", text: $text)
                    .textFieldStyle(.roundedBorder)
                
            case .email:
                TextField("Enter email", text: $emailText)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                
            case .search:
                TextField("Search", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.none)
                    .overlay(
                        HStack {
                            Spacer()
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.trailing, 8)
                            }
                        }
                    )
                
            case .number:
                TextField("Enter number", text: $numberText)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
            }
            
            // Status Display
            Text("Current text: \(getCurrentText())")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
    
    private func getCurrentText() -> String {
        switch style {
        case .standard, .roundedBorder: return text.isEmpty ? "Empty" : text
        case .email: return emailText.isEmpty ? "Empty" : emailText
        case .search: return searchText.isEmpty ? "Empty" : searchText
        case .number: return numberText.isEmpty ? "Empty" : numberText
        }
    }
}

enum NativeTabViewStyle {
    case standard, page, pageAlwaysVisible
}

struct NativeTabViewExample: View {
    let title: String
    let description: String
    let style: NativeTabViewStyle
    @State private var selectedTab = 0
    @State private var pageSelection = 0
    
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
            
            // Native TabView Examples
            switch style {
            case .standard:
                TabView(selection: $selectedTab) {
                    VStack {
                        Image(systemName: "house.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.blue)
                        Text("Home")
                            .font(.headline)
                    }
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(0)
                    
                    VStack {
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                            .foregroundStyle(.green)
                        Text("Search")
                            .font(.headline)
                    }
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(1)
                }
                .frame(height: 150)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
            case .page:
                TabView(selection: $pageSelection) {
                    VStack {
                        Circle()
                            .fill(.red.gradient)
                            .frame(width: 60, height: 60)
                        Text("Page 1")
                            .font(.headline)
                    }
                    .tag(0)
                    
                    VStack {
                        Circle()
                            .fill(.blue.gradient)
                            .frame(width: 60, height: 60)
                        Text("Page 2")
                            .font(.headline)
                    }
                    .tag(1)
                    
                    VStack {
                        Circle()
                            .fill(.green.gradient)
                            .frame(width: 60, height: 60)
                        Text("Page 3")
                            .font(.headline)
                    }
                    .tag(2)
                }
                .tabViewStyle(.page)
                .frame(height: 150)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
            case .pageAlwaysVisible:
                TabView {
                    VStack {
                        Rectangle()
                            .fill(.orange.gradient)
                            .frame(height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Text("Card 1")
                            .font(.headline)
                    }
                    
                    VStack {
                        Rectangle()
                            .fill(.pink.gradient)
                            .frame(height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Text("Card 2")
                            .font(.headline)
                    }
                    
                    VStack {
                        Rectangle()
                            .fill(.cyan.gradient)
                            .frame(height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Text("Card 3")
                            .font(.headline)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 140)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Status Display
            Text("Selected: \(getSelectionStatus())")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
    
    private func getSelectionStatus() -> String {
        switch style {
        case .standard: return "Tab \(selectedTab + 1)"
        case .page: return "Page \(pageSelection + 1)"
        case .pageAlwaysVisible: return "Swipe to navigate"
        }
    }
}

// MARK: - Missing Structs and Enums

public enum NativeStepperDisplayStyle {
    case withLabel, withValue, labelsHidden, customFormat
}

struct NativeStepperExample: View {
    let title: String
    let description: String
    let label: String
    let value: Double
    let range: ClosedRange<Double>
    let step: Double
    let displayStyle: NativeStepperDisplayStyle
    @State private var currentValue: Double
    
    init(title: String, description: String, label: String, value: Double, range: ClosedRange<Double>, step: Double, displayStyle: NativeStepperDisplayStyle) {
        self.title = title
        self.description = description
        self.label = label
        self.value = value
        self.range = range
        self.step = step
        self.displayStyle = displayStyle
        self._currentValue = State(initialValue: value)
    }
    
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
            
            switch displayStyle {
            case .withLabel:
                Stepper("\(label): \(Int(currentValue))", value: $currentValue, in: range, step: step)
            case .withValue:
                Stepper("\(label): \(currentValue, specifier: "%.1f")", value: $currentValue, in: range, step: step)
            case .labelsHidden:
                Stepper(value: $currentValue, in: range, step: step) {
                    Text(label)
                }
                .labelsHidden()
            case .customFormat:
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(label): \(currentValue, specifier: "%.1f") ⭐")
                        .font(.subheadline)
                    Stepper("", value: $currentValue, in: range, step: step)
                        .labelsHidden()
                }
            }
            
            Text("Display style: .\(displayStyleString)")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
    
    private var displayStyleString: String {
        switch displayStyle {
        case .withLabel: return "withLabel"
        case .withValue: return "withValue" 
        case .labelsHidden: return "labelsHidden"
        case .customFormat: return "customFormat"
        }
    }
}

#Preview {
    ContentView()
}

