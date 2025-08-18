import SwiftUI

struct ShareLinkShowcase: View {
    let sampleText = "Check out this amazing SwiftUI Components app!"
    let sampleURL = URL(string: "https://developer.apple.com/xcode/swiftui/")!
    
    var body: some View {
        VStack(spacing: 0) {
            NativeShareLinkExample(
                title: "Text Sharing",
                description: "Native iOS ShareLink for sharing text content",
                style: .text,
                text: sampleText,
                url: sampleURL
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeShareLinkExample(
                title: "URL Sharing",
                description: "ShareLink for sharing web URLs",
                style: .url,
                text: sampleText,
                url: sampleURL
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeShareLinkExample(
                title: "Mixed Content Sharing",
                description: "ShareLink for sharing text and URL together",
                style: .mixed,
                text: sampleText,
                url: sampleURL
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeShareLinkExample(
                title: "Custom ShareLink",
                description: "ShareLink with custom button styling",
                style: .custom,
                text: sampleText,
                url: sampleURL
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeShareLinkStyle: CaseIterable {
    case text
    case url
    case mixed
    case custom
    
    var displayName: String {
        switch self {
        case .text: return "Text"
        case .url: return "URL"
        case .mixed: return "Mixed"
        case .custom: return "Custom"
        }
    }
}

struct NativeShareLinkExample: View {
    let title: String
    let description: String
    let style: NativeShareLinkStyle
    let text: String
    let url: URL
    
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
                // ShareLink examples
                Group {
                    switch style {
                    case .text:
                        ShareLink(item: text) {
                            HStack(spacing: 6) {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share Text")
                            }
                        }
                        .buttonStyle(.bordered)
                        
                    case .url:
                        ShareLink(item: url) {
                            HStack(spacing: 6) {
                                Image(systemName: "link")
                                Text("Share URL")
                            }
                        }
                        .buttonStyle(.bordered)
                        
                    case .mixed:
                        ShareLink(item: text, subject: Text("SwiftUI Components"), message: Text("Check this out!")) {
                            HStack(spacing: 6) {
                                Image(systemName: "square.and.arrow.up.fill")
                                Text("Share Content")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        
                    case .custom:
                        ShareLink(item: url, subject: Text("Amazing SwiftUI App")) {
                            VStack(spacing: 4) {
                                Image(systemName: "heart.fill")
                                    .font(.title2)
                                    .foregroundStyle(.red)
                                Text("Share App")
                                    .font(.caption)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                
                Spacer()
                
                // Content preview
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Content:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    switch style {
                    case .text:
                        Text("Text content")
                            .font(.caption2)
                            .foregroundStyle(.blue)
                    case .url:
                        Text("URL link")
                            .font(.caption2)
                            .foregroundStyle(.green)
                    case .mixed:
                        Text("Text + Subject")
                            .font(.caption2)
                            .foregroundStyle(.purple)
                    case .custom:
                        Text("URL + Subject")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Style: .\(style.displayName.lowercased())")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                
                Text(contentDescription)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding()
    }
    
    private var contentDescription: String {
        switch style {
        case .text:
            return "ShareLink(item: String)"
        case .url:
            return "ShareLink(item: URL)"
        case .mixed:
            return "ShareLink(item:subject:message:)"
        case .custom:
            return "ShareLink with custom label"
        }
    }
}

#Preview {
    ScrollView {
        ShareLinkShowcase()
            .padding()
    }
} 