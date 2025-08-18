import SwiftUI

struct ColorPickerShowcase: View {
    @State private var selectedColor = Color.blue
    @State private var backgroundColor = Color.red
    @State private var textColor = Color.black
    @State private var accentColor = Color.purple
    
    var body: some View {
        VStack(spacing: 0) {
            NativeColorPickerExample(
                title: "Basic ColorPicker",
                description: "Native iOS ColorPicker with default configuration",
                color: $selectedColor,
                showsAlpha: true
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeColorPickerExample(
                title: "ColorPicker without Alpha",
                description: "ColorPicker with alpha channel disabled",
                color: $backgroundColor,
                showsAlpha: false
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeColorPickerExample(
                title: "Text Color Picker",
                description: "ColorPicker for selecting text colors",
                color: $textColor,
                showsAlpha: true
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeColorPickerExample(
                title: "Accent Color Picker",
                description: "ColorPicker for theme accent colors",
                color: $accentColor,
                showsAlpha: false
            )
            
            Divider()
                .padding(.horizontal)
            
            // Color preview section
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Color Preview")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("See the selected colors in action")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                VStack(spacing: 12) {
                    // Color swatches
                    HStack(spacing: 12) {
                        ColorSwatch(color: selectedColor, label: "Basic")
                        ColorSwatch(color: backgroundColor, label: "Background")
                        ColorSwatch(color: textColor, label: "Text")
                        ColorSwatch(color: accentColor, label: "Accent")
                    }
                    
                    // Sample text with colors
                    VStack(spacing: 8) {
                        Text("Sample Text")
                            .font(.headline)
                            .foregroundColor(textColor)
                            .padding()
                            .background(backgroundColor.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Button("Sample Button") {
                            // Action
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(accentColor)
                    }
                }
                
                Text("ColorPicker is available on iOS 14.0+")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct NativeColorPickerExample: View {
    let title: String
    let description: String
    @Binding var color: Color
    let showsAlpha: Bool
    
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
                ColorPicker("Select Color", selection: $color, supportsOpacity: showsAlpha)
                    .labelsHidden()
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(colorDescription(color))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("Alpha: \(showsAlpha ? "Enabled" : "Disabled")")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
            
            Text("supportsOpacity: \(showsAlpha ? "true" : "false")")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
    
    private func colorDescription(_ color: Color) -> String {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return String(format: "R:%.0f G:%.0f B:%.0f", red * 255, green * 255, blue * 255)
    }
}

struct ColorSwatch: View {
    let color: Color
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 40, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ScrollView {
        ColorPickerShowcase()
            .padding()
    }
} 