import SwiftUI

struct MenuShowcase: View {
    @State private var selectedOption = "Option 1"
    @State private var selectedColor = "Blue"
    @State private var isEnabled = true
    
    var body: some View {
        VStack(spacing: 0) {
            NativeMenuExample(
                title: "Basic Menu",
                description: "Native SwiftUI Menu with simple actions",
                style: .basic,
                selectedOption: $selectedOption
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeMenuExample(
                title: "Menu with Icons",
                description: "Menu items with SF Symbol icons",
                style: .withIcons,
                selectedOption: $selectedColor
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeMenuExample(
                title: "Menu with Sections",
                description: "Menu organized with sections and dividers",
                style: .withSections,
                selectedOption: $selectedOption
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeMenuExample(
                title: "Menu with Destructive Actions",
                description: "Menu with destructive and disabled actions",
                style: .withDestructive,
                selectedOption: $selectedOption
            )
            
            Divider()
                .padding(.horizontal)
            
            // Menu variations section
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Menu Variations")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("Different ways to style and present menus")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                VStack(spacing: 8) {
                    HStack(spacing: 12) {
                        // Compact menu
                        Menu("Compact") {
                            Button("Action 1") { }
                            Button("Action 2") { }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        
                        // Menu as primary action
                        Menu("Primary") {
                            Button("Edit") { }
                            Button("Share") { }
                            Button("Delete", role: .destructive) { }
                        }
                        .buttonStyle(.borderedProminent)
                        
                        // Menu with custom label
                        Menu {
                            Button("Copy") { }
                            Button("Paste") { }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.title2)
                        }
                    }
                }
                
                Text("Menu automatically handles presentation and dismissal")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeMenuStyle: CaseIterable {
    case basic
    case withIcons
    case withSections
    case withDestructive
    
    var displayName: String {
        switch self {
        case .basic: return "Basic"
        case .withIcons: return "With Icons"
        case .withSections: return "With Sections"
        case .withDestructive: return "With Destructive"
        }
    }
}

struct NativeMenuExample: View {
    let title: String
    let description: String
    let style: NativeMenuStyle
    @Binding var selectedOption: String
    
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
                // Menu examples
                HStack(spacing: 16) {
                    menuView
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Selected:")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(selectedOption)
                            .font(.body)
                            .foregroundStyle(.primary)
                    }
                }
                
                Spacer()
            }
            
            Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: ""))")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
    
    @ViewBuilder
    private var menuView: some View {
        switch style {
        case .basic:
            Menu("Select Option") {
                Button("Option 1") {
                    selectedOption = "Option 1"
                }
                Button("Option 2") {
                    selectedOption = "Option 2"
                }
                Button("Option 3") {
                    selectedOption = "Option 3"
                }
            }
            .buttonStyle(.bordered)
            
        case .withIcons:
            Menu("Choose Color") {
                Button(action: { selectedOption = "Red" }) {
                    Label("Red", systemImage: "circle.fill")
                }
                .foregroundStyle(.red)
                
                Button(action: { selectedOption = "Green" }) {
                    Label("Green", systemImage: "circle.fill")
                }
                .foregroundStyle(.green)
                
                Button(action: { selectedOption = "Blue" }) {
                    Label("Blue", systemImage: "circle.fill")
                }
                .foregroundStyle(.blue)
            }
            .buttonStyle(.bordered)
            
        case .withSections:
            Menu("Actions") {
                Section("Edit") {
                    Button(action: { selectedOption = "Cut" }) {
                        Label("Cut", systemImage: "scissors")
                    }
                    Button(action: { selectedOption = "Copy" }) {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    Button(action: { selectedOption = "Paste" }) {
                        Label("Paste", systemImage: "clipboard")
                    }
                }
                
                Section("Share") {
                    Button(action: { selectedOption = "AirDrop" }) {
                        Label("AirDrop", systemImage: "airplay")
                    }
                    Button(action: { selectedOption = "Messages" }) {
                        Label("Messages", systemImage: "message")
                    }
                }
            }
            .buttonStyle(.bordered)
            
        case .withDestructive:
            Menu("File Actions") {
                Button(action: { selectedOption = "Rename" }) {
                    Label("Rename", systemImage: "pencil")
                }
                Button(action: { selectedOption = "Duplicate" }) {
                    Label("Duplicate", systemImage: "plus.square.on.square")
                }
                
                Divider()
                
                Button("Move to Trash", role: .destructive) {
                    selectedOption = "Deleted"
                }
                
                Button("Disabled Action") {
                    selectedOption = "Should not happen"
                }
                .disabled(true)
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    ScrollView {
        MenuShowcase()
            .padding()
    }
} 