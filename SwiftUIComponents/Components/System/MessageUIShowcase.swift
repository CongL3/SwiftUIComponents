import SwiftUI
import MessageUI

struct MessageUIShowcase: View {
    @State private var showingMailComposer = false
    @State private var showingMessageComposer = false
    @State private var showingMailWithAttachment = false
    @State private var showingMessageWithMedia = false
    @State private var mailResult: String = ""
    @State private var messageResult: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            NativeMessageUIExample(
                title: "Mail Composer",
                description: "Native iOS mail composer (MFMailComposeViewController)",
                style: .mailBasic,
                showingComposer: $showingMailComposer,
                result: $mailResult
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeMessageUIExample(
                title: "Message Composer",
                description: "Native iOS message composer (MFMessageComposeViewController)",
                style: .messageBasic,
                showingComposer: $showingMessageComposer,
                result: $messageResult
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeMessageUIExample(
                title: "Mail with Attachment",
                description: "Mail composer with attachment and custom subject",
                style: .mailWithAttachment,
                showingComposer: $showingMailWithAttachment,
                result: $mailResult
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeMessageUIExample(
                title: "Message with Media",
                description: "Message composer with media attachment",
                style: .messageWithMedia,
                showingComposer: $showingMessageWithMedia,
                result: $messageResult
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeMessageUIStyle: CaseIterable {
    case mailBasic
    case messageBasic
    case mailWithAttachment
    case messageWithMedia
    
    var displayName: String {
        switch self {
        case .mailBasic: return "Mail Basic"
        case .messageBasic: return "Message Basic"
        case .mailWithAttachment: return "Mail + Attachment"
        case .messageWithMedia: return "Message + Media"
        }
    }
}

struct NativeMessageUIExample: View {
    let title: String
    let description: String
    let style: NativeMessageUIStyle
    @Binding var showingComposer: Bool
    @Binding var result: String
    
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
                Button(buttonTitle) {
                    if canSend {
                        showingComposer = true
                    } else {
                        result = "Service not available"
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!canSend)
                
                Spacer()
                
                // Availability status
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Status:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(canSend ? "Available" : "Not Available")
                        .font(.caption2)
                        .foregroundStyle(canSend ? .green : .red)
                }
            }
            
            // Result display
            if !result.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Last Result:")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Text(result)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.tertiarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "+", with: "with"))")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                
                Text(messageUIDescription)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .sheet(isPresented: $showingComposer) {
            Group {
                switch style {
                case .mailBasic:
                    MailComposerView(
                        subject: "Hello from SwiftUI Components!",
                        recipients: ["example@example.com"],
                        messageBody: "This is a test email from the SwiftUI Components showcase app.",
                        isHTML: false,
                        result: $result
                    )
                case .mailWithAttachment:
                    MailComposerView(
                        subject: "SwiftUI Components - With Attachment",
                        recipients: ["example@example.com"],
                        messageBody: "<h2>SwiftUI Components</h2><p>Please find the attached document.</p>",
                        isHTML: true,
                        attachment: createSampleAttachment(),
                        result: $result
                    )
                case .messageBasic:
                    MessageComposerView(
                        recipients: ["+1234567890"],
                        body: "Hello from SwiftUI Components app! 📱",
                        result: $result
                    )
                case .messageWithMedia:
                    MessageComposerView(
                        recipients: ["+1234567890"],
                        body: "Check out this image! 🖼️",
                        attachment: createSampleImageAttachment(),
                        result: $result
                    )
                }
            }
        }
    }
    
    private var buttonTitle: String {
        switch style {
        case .mailBasic, .mailWithAttachment:
            return "Compose Mail"
        case .messageBasic, .messageWithMedia:
            return "Send Message"
        }
    }
    
    private var canSend: Bool {
        switch style {
        case .mailBasic, .mailWithAttachment:
            return MFMailComposeViewController.canSendMail()
        case .messageBasic, .messageWithMedia:
            return MFMessageComposeViewController.canSendText()
        }
    }
    
    private var messageUIDescription: String {
        switch style {
        case .mailBasic:
            return "MFMailComposeViewController.canSendMail()"
        case .messageBasic:
            return "MFMessageComposeViewController.canSendText()"
        case .mailWithAttachment:
            return "MFMailComposeViewController + attachment"
        case .messageWithMedia:
            return "MFMessageComposeViewController + media"
        }
    }
    
    private func createSampleAttachment() -> (Data, String, String) {
        let content = "SwiftUI Components Showcase\n\nThis is a sample text attachment demonstrating the mail composer functionality."
        let data = content.data(using: .utf8) ?? Data()
        return (data, "text/plain", "sample.txt")
    }
    
    private func createSampleImageAttachment() -> (Data, String) {
        // Create a simple colored image
        let size = CGSize(width: 100, height: 100)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.systemBlue.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            UIColor.white.setFill()
            let rect = CGRect(x: 25, y: 40, width: 50, height: 20)
            context.fill(rect)
        }
        
        return (image.pngData() ?? Data(), "image/png")
    }
}

struct MailComposerView: UIViewControllerRepresentable {
    let subject: String
    let recipients: [String]
    let messageBody: String
    let isHTML: Bool
    var attachment: (Data, String, String)? = nil
    @Binding var result: String
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = context.coordinator
        composer.setSubject(subject)
        composer.setToRecipients(recipients)
        composer.setMessageBody(messageBody, isHTML: isHTML)
        
        if let attachment = attachment {
            composer.addAttachmentData(attachment.0, mimeType: attachment.1, fileName: attachment.2)
        }
        
        return composer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposerView
        
        init(_ parent: MailComposerView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            switch result {
            case .sent:
                parent.result = "Mail sent successfully"
            case .saved:
                parent.result = "Mail saved to drafts"
            case .cancelled:
                parent.result = "Mail cancelled"
            case .failed:
                parent.result = "Mail failed: \(error?.localizedDescription ?? "Unknown error")"
            @unknown default:
                parent.result = "Unknown result"
            }
            
            parent.dismiss()
        }
    }
}

struct MessageComposerView: UIViewControllerRepresentable {
    let recipients: [String]
    let body: String
    var attachment: (Data, String)? = nil
    @Binding var result: String
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let composer = MFMessageComposeViewController()
        composer.messageComposeDelegate = context.coordinator
        composer.recipients = recipients
        composer.body = body
        
        if let attachment = attachment {
            composer.addAttachmentData(attachment.0, typeIdentifier: attachment.1, filename: "image.png")
        }
        
        return composer
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        let parent: MessageComposerView
        
        init(_ parent: MessageComposerView) {
            self.parent = parent
        }
        
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            switch result {
            case .sent:
                parent.result = "Message sent successfully"
            case .cancelled:
                parent.result = "Message cancelled"
            case .failed:
                parent.result = "Message failed to send"
            @unknown default:
                parent.result = "Unknown result"
            }
            
            parent.dismiss()
        }
    }
}

#Preview {
    ScrollView {
        MessageUIShowcase()
            .padding()
    }
} 