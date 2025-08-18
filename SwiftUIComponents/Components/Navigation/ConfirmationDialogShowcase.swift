import SwiftUI

struct ConfirmationDialogShowcase: View {
    @State private var showingBasicDialog = false
    @State private var showingDestructiveDialog = false
    @State private var showingComplexDialog = false
    @State private var showingTitleMessageDialog = false
    
    var body: some View {
        VStack(spacing: 0) {
            NativeConfirmationDialogExample(
                title: "Basic Dialog",
                description: "Native SwiftUI confirmationDialog with basic actions",
                style: .basic,
                showingDialog: $showingBasicDialog
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeConfirmationDialogExample(
                title: "Destructive Dialog",
                description: "Confirmation dialog with destructive action",
                style: .destructive,
                showingDialog: $showingDestructiveDialog
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeConfirmationDialogExample(
                title: "Complex Dialog",
                description: "Dialog with multiple actions and sections",
                style: .complex,
                showingDialog: $showingComplexDialog
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeConfirmationDialogExample(
                title: "Title & Message Dialog",
                description: "Dialog with both title and message content",
                style: .titleAndMessage,
                showingDialog: $showingTitleMessageDialog
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeConfirmationDialogStyle: CaseIterable {
    case basic
    case destructive
    case complex
    case titleAndMessage
    
    var displayName: String {
        switch self {
        case .basic: return "Basic"
        case .destructive: return "Destructive"
        case .complex: return "Complex"
        case .titleAndMessage: return "Title & Message"
        }
    }
}

struct NativeConfirmationDialogExample: View {
    let title: String
    let description: String
    let style: NativeConfirmationDialogStyle
    @Binding var showingDialog: Bool
    @State private var resultMessage = ""
    
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
                Button("Show Dialog") {
                    showingDialog = true
                }
                .buttonStyle(.borderedProminent)
                .confirmationDialog(
                    dialogTitle,
                    isPresented: $showingDialog,
                    titleVisibility: titleVisibility,
                    presenting: style
                ) { style in
                    dialogActions(for: style)
                } message: { style in
                    if style == .titleAndMessage || style == .complex {
                        Text(dialogMessage)
                    }
                }
                
                Spacer()
                
                // Style indicator
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Style:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    styleLabel
                }
            }
            
            // Result display
            if !resultMessage.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Last Action:")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Text(resultMessage)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.tertiarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "&", with: "and"))")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                
                Text(dialogDescription)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func dialogActions(for style: NativeConfirmationDialogStyle) -> some View {
        switch style {
        case .basic:
            Button("Option 1") {
                resultMessage = "Selected Option 1"
            }
            
            Button("Option 2") {
                resultMessage = "Selected Option 2"
            }
            
            Button("Cancel", role: .cancel) {
                resultMessage = "Cancelled"
            }
            
        case .destructive:
            Button("Save Changes") {
                resultMessage = "Changes saved"
            }
            
            Button("Discard Changes", role: .destructive) {
                resultMessage = "Changes discarded"
            }
            
            Button("Cancel", role: .cancel) {
                resultMessage = "Cancelled"
            }
            
        case .complex:
            Button("Share") {
                resultMessage = "Shared item"
            }
            
            Button("Edit") {
                resultMessage = "Started editing"
            }
            
            Button("Duplicate") {
                resultMessage = "Item duplicated"
            }
            
            Button("Move to Trash", role: .destructive) {
                resultMessage = "Moved to trash"
            }
            
            Button("Cancel", role: .cancel) {
                resultMessage = "Cancelled"
            }
            
        case .titleAndMessage:
            Button("Confirm") {
                resultMessage = "Action confirmed"
            }
            
            Button("Not Now") {
                resultMessage = "Deferred action"
            }
            
            Button("Cancel", role: .cancel) {
                resultMessage = "Cancelled"
            }
        }
    }
    
    @ViewBuilder
    private var styleLabel: some View {
        switch style {
        case .basic:
            Label("Basic", systemImage: "list.bullet")
                .font(.caption2)
                .foregroundStyle(.blue)
        case .destructive:
            Label("Destructive", systemImage: "trash")
                .font(.caption2)
                .foregroundStyle(.red)
        case .complex:
            Label("Complex", systemImage: "ellipsis.circle")
                .font(.caption2)
                .foregroundStyle(.orange)
        case .titleAndMessage:
            Label("Title + Message", systemImage: "text.bubble")
                .font(.caption2)
                .foregroundStyle(.green)
        }
    }
    
    private var dialogTitle: String {
        switch style {
        case .basic: return "Choose an Option"
        case .destructive: return "Unsaved Changes"
        case .complex: return "Item Actions"
        case .titleAndMessage: return "Enable Notifications"
        }
    }
    
    private var dialogMessage: String {
        switch style {
        case .titleAndMessage: 
            return "Allow this app to send you notifications about important updates and reminders?"
        case .complex:
            return "Choose an action to perform on this item. Some actions cannot be undone."
        default:
            return ""
        }
    }
    
    private var titleVisibility: Visibility {
        switch style {
        case .titleAndMessage, .complex:
            return .visible
        default:
            return .automatic
        }
    }
    
    private var dialogDescription: String {
        switch style {
        case .basic:
            return ".confirmationDialog() with basic actions"
        case .destructive:
            return "Button(role: .destructive)"
        case .complex:
            return "Multiple actions with message"
        case .titleAndMessage:
            return "titleVisibility: .visible + message"
        }
    }
}

#Preview {
    ScrollView {
        ConfirmationDialogShowcase()
            .padding()
    }
} 