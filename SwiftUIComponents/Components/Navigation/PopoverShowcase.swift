import SwiftUI

struct PopoverShowcase: View {
    @State private var showingBasicPopover = false
    @State private var showingAttachmentPopover = false
    @State private var showingArrowPopover = false
    @State private var showingCustomPopover = false
    
    var body: some View {
        VStack(spacing: 0) {
            NativePopoverExample(
                title: "Basic Popover",
                description: "Native SwiftUI popover with basic content",
                style: .basic,
                showingPopover: $showingBasicPopover
            )
            
            Divider()
                .padding(.horizontal)
            
            NativePopoverExample(
                title: "Popover with Attachment",
                description: "Popover anchored to specific attachment point",
                style: .withAttachment,
                showingPopover: $showingAttachmentPopover
            )
            
            Divider()
                .padding(.horizontal)
            
            NativePopoverExample(
                title: "Arrow Direction",
                description: "Popover with specific arrow direction",
                style: .arrowDirection,
                showingPopover: $showingArrowPopover
            )
            
            Divider()
                .padding(.horizontal)
            
            NativePopoverExample(
                title: "Custom Size Popover",
                description: "Popover with custom presentation size",
                style: .customSize,
                showingPopover: $showingCustomPopover
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativePopoverStyle: CaseIterable {
    case basic
    case withAttachment
    case arrowDirection
    case customSize
    
    var displayName: String {
        switch self {
        case .basic: return "Basic"
        case .withAttachment: return "With Attachment"
        case .arrowDirection: return "Arrow Direction"
        case .customSize: return "Custom Size"
        }
    }
}

struct NativePopoverExample: View {
    let title: String
    let description: String
    let style: NativePopoverStyle
    @Binding var showingPopover: Bool
    
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
                Button("Show Popover") {
                    showingPopover = true
                }
                .buttonStyle(.borderedProminent)
                .popover(isPresented: $showingPopover, 
                        attachmentAnchor: attachmentAnchor,
                        arrowEdge: arrowEdge) {
                    popoverContent
                        .presentationCompactAdaptation(.popover)
                        .if(style == .customSize) { view in
                            view.presentationDetents([.height(200), .medium])
                        }
                }
                
                Spacer()
                
                // Configuration preview
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Config:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    configurationLabel
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: ""))")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                
                Text(popoverDescription)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private var popoverContent: some View {
        switch style {
        case .basic:
            VStack(spacing: 12) {
                Text("Basic Popover")
                    .font(.headline)
                
                Text("This is a basic popover with simple content.")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                
                Button("Dismiss") {
                    showingPopover = false
                }
                .buttonStyle(.bordered)
            }
            .padding()
            
        case .withAttachment:
            VStack(spacing: 12) {
                Image(systemName: "paperclip")
                    .font(.title)
                    .foregroundStyle(.blue)
                
                Text("Attachment Popover")
                    .font(.headline)
                
                Text("This popover is anchored to a specific attachment point.")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                
                HStack {
                    Button("Cancel") {
                        showingPopover = false
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Open") {
                        showingPopover = false
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            
        case .arrowDirection:
            VStack(spacing: 12) {
                Image(systemName: "arrow.up")
                    .font(.title)
                    .foregroundStyle(.green)
                
                Text("Arrow Direction")
                    .font(.headline)
                
                Text("This popover has a specific arrow direction.")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                
                Button("Got it") {
                    showingPopover = false
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
        case .customSize:
            ScrollView {
                VStack(spacing: 16) {
                    Text("Custom Size Popover")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("This popover has custom presentation detents and can be resized.")
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Features:")
                            .fontWeight(.medium)
                        
                        Label("Custom height", systemImage: "arrow.up.and.down")
                        Label("Resizable", systemImage: "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left")
                        Label("Scrollable content", systemImage: "scroll")
                    }
                    
                    Button("Close") {
                        showingPopover = false
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    private var configurationLabel: some View {
        switch style {
        case .basic:
            Label("Default", systemImage: "bubble")
                .font(.caption2)
                .foregroundStyle(.blue)
        case .withAttachment:
            Label("Anchored", systemImage: "link")
                .font(.caption2)
                .foregroundStyle(.orange)
        case .arrowDirection:
            Label("Arrow Up", systemImage: "arrow.up")
                .font(.caption2)
                .foregroundStyle(.green)
        case .customSize:
            Label("Custom", systemImage: "rectangle.expand.vertical")
                .font(.caption2)
                .foregroundStyle(.purple)
        }
    }
    
    private var attachmentAnchor: PopoverAttachmentAnchor {
        switch style {
        case .withAttachment:
            return .point(.topLeading)
        default:
            return .rect(.bounds)
        }
    }
    
    private var arrowEdge: Edge {
        switch style {
        case .arrowDirection:
            return .top
        default:
            return .bottom
        }
    }
    
    private var popoverDescription: String {
        switch style {
        case .basic:
            return ".popover(isPresented:)"
        case .withAttachment:
            return ".popover(attachmentAnchor: .point)"
        case .arrowDirection:
            return ".popover(arrowEdge: .top)"
        case .customSize:
            return ".presentationDetents([.height, .medium])"
        }
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

#Preview {
    ScrollView {
        PopoverShowcase()
            .padding()
    }
} 