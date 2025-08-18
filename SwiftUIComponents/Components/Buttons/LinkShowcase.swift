import SwiftUI

struct LinkShowcase: View {
    var body: some View {
        VStack(spacing: 0) {
            NativeLinkExample(
                title: "Basic Link",
                description: "Native SwiftUI Link that opens URLs in Safari",
                url: "https://developer.apple.com",
                displayText: "Apple Developer"
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeLinkExample(
                title: "Link with Custom Styling",
                description: "Link with custom foreground color and styling",
                url: "https://swift.org",
                displayText: "Swift.org",
                isStyled: true
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeLinkExample(
                title: "Link with Icon",
                description: "Link combined with SF Symbol icon",
                url: "https://github.com",
                displayText: "GitHub",
                hasIcon: true
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeLinkExample(
                title: "Email Link",
                description: "Link that opens mail app with email address",
                url: "mailto:developer@example.com",
                displayText: "Send Email",
                linkType: .email
            )
            
            Divider()
                .padding(.horizontal)
            
            // Multiple link types section
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Different Link Types")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("Various URL schemes supported by Link")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                VStack(spacing: 8) {
                    HStack(spacing: 12) {
                        Link("Call Phone", destination: URL(string: "tel:+1234567890")!)
                            .buttonStyle(.bordered)
                        
                        Link("Send SMS", destination: URL(string: "sms:+1234567890")!)
                            .buttonStyle(.bordered)
                    }
                    
                    HStack(spacing: 12) {
                        Link("Open Maps", destination: URL(string: "maps://")!)
                            .buttonStyle(.bordered)
                        
                        Link("App Store", destination: URL(string: "https://apps.apple.com")!)
                            .buttonStyle(.bordered)
                    }
                }
                
                Text("Link supports various URL schemes: http, https, mailto, tel, sms, maps, etc.")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

enum LinkType {
    case web
    case email
    case phone
    case sms
    
    var icon: String {
        switch self {
        case .web: return "globe"
        case .email: return "envelope"
        case .phone: return "phone"
        case .sms: return "message"
        }
    }
}

struct NativeLinkExample: View {
    let title: String
    let description: String
    let url: String
    let displayText: String
    let isStyled: Bool
    let hasIcon: Bool
    let linkType: LinkType
    
    init(title: String, description: String, url: String, displayText: String, isStyled: Bool = false, hasIcon: Bool = false, linkType: LinkType = .web) {
        self.title = title
        self.description = description
        self.url = url
        self.displayText = displayText
        self.isStyled = isStyled
        self.hasIcon = hasIcon
        self.linkType = linkType
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
            
            HStack {
                // Link examples
                VStack(alignment: .leading, spacing: 8) {
                    // Default link
                    Link(displayText, destination: URL(string: url)!)
                        .foregroundStyle(isStyled ? .red : .blue)
                    
                    // Link with icon
                    if hasIcon {
                        Link(destination: URL(string: url)!) {
                            HStack(spacing: 6) {
                                Image(systemName: linkType.icon)
                                Text(displayText)
                            }
                        }
                        .foregroundStyle(.blue)
                    }
                    
                    // Button-styled link
                    Link(destination: URL(string: url)!) {
                        HStack(spacing: 6) {
                            Image(systemName: linkType.icon)
                            Text("Button Style")
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("URL: \(url)")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .lineLimit(1)
                
                Text("Link opens in: \(linkType == .web ? "Safari" : linkType == .email ? "Mail" : linkType == .phone ? "Phone" : "Messages")")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
    }
}

#Preview {
    ScrollView {
        LinkShowcase()
            .padding()
    }
} 