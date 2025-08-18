import SwiftUI

struct SheetShowcase: View {
    @State private var showBasicSheet = false
    @State private var showFullScreenSheet = false
    @State private var showDetentSheet = false
    @State private var showFormSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            NativeSheetExample(
                title: "Basic Sheet",
                description: "Standard SwiftUI sheet presentation",
                style: .basic,
                showSheet: $showBasicSheet
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeSheetExample(
                title: "Full Screen Cover",
                description: "Full screen modal presentation",
                style: .fullScreen,
                showSheet: $showFullScreenSheet
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeSheetExample(
                title: "Sheet with Detents",
                description: "Sheet with custom presentation detents",
                style: .withDetents,
                showSheet: $showDetentSheet
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeSheetExample(
                title: "Form Sheet",
                description: "Sheet containing a form with various inputs",
                style: .form,
                showSheet: $showFormSheet
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .sheet(isPresented: $showBasicSheet) {
            BasicSheetContent()
        }
        .fullScreenCover(isPresented: $showFullScreenSheet) {
            FullScreenSheetContent()
        }
        .sheet(isPresented: $showDetentSheet) {
            DetentSheetContent()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showFormSheet) {
            FormSheetContent()
                .presentationDetents([.fraction(0.7), .large])
        }
    }
}

public enum NativeSheetStyle: CaseIterable {
    case basic
    case fullScreen
    case withDetents
    case form
    
    var displayName: String {
        switch self {
        case .basic: return "Basic"
        case .fullScreen: return "Full Screen"
        case .withDetents: return "With Detents"
        case .form: return "Form"
        }
    }
}

struct NativeSheetExample: View {
    let title: String
    let description: String
    let style: NativeSheetStyle
    @Binding var showSheet: Bool
    
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
                Button("Present \(style.displayName)") {
                    showSheet = true
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(modifierText)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    
                    if style == .withDetents {
                        Text("with detents")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            
            Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: ""))")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
    
    private var modifierText: String {
        switch style {
        case .basic: return ".sheet(isPresented:)"
        case .fullScreen: return ".fullScreenCover(isPresented:)"
        case .withDetents: return ".sheet + .presentationDetents"
        case .form: return ".sheet + .presentationDetents"
        }
    }
}

struct BasicSheetContent: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                
                Text("Basic Sheet")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("This is a standard SwiftUI sheet presentation. It appears as a modal overlay with automatic dismiss gestures.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button("Dismiss") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Sheet Content")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
}

struct FullScreenSheetContent: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "rectangle.expand.vertical")
                    .font(.system(size: 60))
                    .foregroundStyle(.green)
                
                Text("Full Screen Cover")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("This is a full screen modal presentation. It covers the entire screen and requires explicit dismissal.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    Button("Close") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Text("No automatic dismiss gestures")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Full Screen")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Close") { dismiss() })
        }
    }
}

struct DetentSheetContent: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "arrow.up.and.down.text.horizontal")
                    .font(.system(size: 60))
                    .foregroundStyle(.orange)
                
                Text("Sheet with Detents")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("This sheet has custom presentation detents. You can drag to resize between medium and large sizes.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    Text("Available Detents:")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("• .medium - 50% of screen")
                        Text("• .large - Full height")
                    }
                    .font(.body)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Spacer()
            }
            .padding()
            .navigationTitle("Detents")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
}

struct FormSheetContent: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var isSubscribed = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Personal Information") {
                    TextField("Full Name", text: $name)
                    TextField("Email Address", text: $email)
                        .keyboardType(.emailAddress)
                }
                
                Section("Preferences") {
                    Toggle("Subscribe to Newsletter", isOn: $isSubscribed)
                }
                
                Section {
                    Button("Save") {
                        // Save action
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Form Sheet")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") { dismiss() }
            )
        }
    }
}

#Preview {
    ScrollView {
        SheetShowcase()
            .padding()
    }
} 