# Component Showcase Design Guidelines

## 🚨 CRITICAL: Native iOS Styles Only - No Custom Implementations

### ⚠️ Common Mistake to Avoid:
**DO NOT** create multiple examples of the same native style with different content.
**DO** showcase different native iOS styles available for each component type.

### Example - WRONG vs RIGHT:

**❌ WRONG - Multiple identical segmented controls:**
```swift
// All using .pickerStyle(.segmented) - IDENTICAL UI
Picker("Options", selection: $value1) { ... }.pickerStyle(.segmented)
Picker("Different Options", selection: $value2) { ... }.pickerStyle(.segmented)
Picker("More Options", selection: $value3) { ... }.pickerStyle(.segmented)
```

**✅ RIGHT - Different native iOS picker styles:**
```swift
// Shows variety of native iOS styles - DIFFERENT UI
Picker("Options", selection: $value1) { ... }.pickerStyle(.segmented)
Picker("Options", selection: $value2) { ... }.pickerStyle(.menu)
Picker("Options", selection: $value3) { ... }.pickerStyle(.wheel)
```

### 🎯 Goal: Showcase Native iOS Style Variety
- Each example must demonstrate a **different native iOS style**
- Use Apple's built-in `.pickerStyle()`, `.toggleStyle()`, `.buttonStyle()`, etc.
- Never create custom UI that obscures native appearance
- Focus on showing developers what iOS provides out of the box

---

## Overview
This document defines the standard design pattern for showcasing native iOS components in our app. The goal is to create a clean, interactive, and informative experience that demonstrates how native iOS components work.

## Design Principles

### 1. **Native First**
- Show ONLY native iOS/SwiftUI components
- Use built-in styles and behaviors
- No custom styling that obscures native appearance

### 2. **Interactive Examples**
- All components must be fully interactive
- Use `@State` bindings, never `.constant()`
- Show real-time feedback of user interactions

### 3. **Clean List Format**
- Use vertical list with dividers between examples
- Consistent padding and spacing
- Minimal visual noise

### 4. **Descriptive Content**
- Each example has a clear title
- Include helper text explaining the use case
- Show current state/selection when relevant

### 5. **Compact Layout**
- Minimize header space usage
- Focus on the component examples
- Efficient use of screen real estate

## Standard Component Example Structure

```swift
struct ComponentExample: View {
    let title: String           // Clear, descriptive title
    let description: String     // Brief explanation of use case
    @State var interactiveState // Always interactive
    
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
            
            // Native Component (Interactive)
            NativeComponent(selection: $interactiveState)
            
            // Current State Display (Optional)
            Text("Current: \(interactiveState)")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}
```

## Layout Pattern for Multiple Examples

```swift
private var componentPreviewSection: some View {
    VStack(spacing: 0) {
        // Example 1
        ComponentExample(
            title: "Basic Usage",
            description: "Standard implementation"
        )
        
        Divider()
            .padding(.horizontal)
        
        // Example 2
        ComponentExample(
            title: "Different Variation",
            description: "Alternative use case"
        )
        
        // ... more examples
    }
    .background(Color(.systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 12))
}
```

## Header Design (Compact)

```swift
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
```

## Typography Scale

- **Component Title**: `.headline`
- **Description**: `.caption`
- **Current State**: `.caption2`
- **Header Title**: `.title2` + `.semibold`
- **Header Description**: `.caption`

## Color Usage

- **Primary Text**: `.primary`
- **Secondary Text**: `.secondary` 
- **Tertiary Text**: `.tertiary`
- **Category Icons**: `component.category.color`

## Spacing Standards

- **Between Examples**: `0` (use dividers)
- **Within Example**: `12pt`
- **Title/Description**: `4pt`
- **Header Elements**: `12pt`
- **Section Padding**: `16pt`

## Interactive Feedback

### Required for All Components:
1. **Visual State Changes** - Component must visually respond to interaction
2. **State Display** - Show current selection/value when relevant
3. **Real-time Updates** - Changes should be immediate

### Examples:
- **Segmented Control**: Show selected option
- **Toggle**: Show on/off state
- **Slider**: Show current value
- **Picker**: Show selected item

## Component Categories to Showcase

### 1. Controls & Selection
- Segmented Control (Picker with .segmented)
- Toggle (various styles)
- Slider (native)
- Stepper (native)

### 2. Pickers
- Segmented Picker
- Wheel Picker  
- Menu Picker
- Navigation Link Picker

### 3. Buttons & Actions
- Button (various styles)
- Link
- Menu Button

### 4. Input & Forms
- TextField (various styles)
- TextEditor
- SecureField

### 5. Navigation
- TabView
- NavigationLink
- NavigationStack

### 6. Feedback & Status
- ProgressView
- Alert
- ActionSheet

## Implementation Checklist

For each new component showcase:

- [ ] Uses native iOS component only
- [ ] Fully interactive (no `.constant()` bindings)
- [ ] Follows standard layout pattern
- [ ] Has descriptive titles and helper text
- [ ] Shows current state when relevant
- [ ] Uses consistent typography and spacing
- [ ] Multiple examples showing different use cases
- [ ] Clean dividers between examples
- [ ] Proper accessibility support

## Success Metrics

A good component showcase should:
1. **Teach** - User learns how to use the native component
2. **Demonstrate** - Shows real iOS behavior and appearance  
3. **Inspire** - Provides ideas for different use cases
4. **Reference** - Easy to find and copy code examples

---

*This design system ensures consistency across all component showcases and provides the best learning experience for developers exploring native iOS UI components.* 