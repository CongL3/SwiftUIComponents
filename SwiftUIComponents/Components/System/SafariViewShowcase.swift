import SwiftUI
import SafariServices

struct SafariViewShowcase: View {
    @State private var showingSafari1 = false
    @State private var showingSafari2 = false
    @State private var showingSafari3 = false
    @State private var showingSafari4 = false
    
    let sampleURL1 = URL(string: "https://developer.apple.com/documentation/swiftui")!
    let sampleURL2 = URL(string: "https://www.hackingwithswift.com")!
    let sampleURL3 = URL(string: "https://github.com")!
    let sampleURL4 = URL(string: "https://stackoverflow.com")!
    
    var body: some View {
        VStack(spacing: 0) {
            NativeSafariViewExample(
                title: "Basic Safari View",
                description: "Native Safari view controller with default configuration",
                style: .basic,
                url: sampleURL1,
                showingSafari: $showingSafari1
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeSafariViewExample(
                title: "Safari with Reader Mode",
                description: "Safari view with reader mode enabled",
                style: .readerMode,
                url: sampleURL2,
                showingSafari: $showingSafari2
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeSafariViewExample(
                title: "Safari with Custom Tint",
                description: "Safari view with custom tint color",
                style: .customTint,
                url: sampleURL3,
                showingSafari: $showingSafari3
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeSafariViewExample(
                title: "Safari with Bar Collapsing",
                description: "Safari view with collapsing navigation bar",
                style: .barCollapsing,
                url: sampleURL4,
                showingSafari: $showingSafari4
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeSafariViewStyle: CaseIterable {
    case basic
    case readerMode
    case customTint
    case barCollapsing
    
    var displayName: String {
        switch self {
        case .basic: return "Basic"
        case .readerMode: return "Reader Mode"
        case .customTint: return "Custom Tint"
        case .barCollapsing: return "Bar Collapsing"
        }
    }
}

struct NativeSafariViewExample: View {
    let title: String
    let description: String
    let style: NativeSafariViewStyle
    let url: URL
    @Binding var showingSafari: Bool
    
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
                Button("Open in Safari") {
                    showingSafari = true
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
                
                // URL preview
                VStack(alignment: .trailing, spacing: 4) {
                    Text("URL:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(url.host ?? "Unknown")
                        .font(.caption2)
                        .foregroundStyle(.blue)
                        .lineLimit(1)
                }
            }
            
            // Configuration details
            VStack(alignment: .leading, spacing: 4) {
                Text("Configuration:")
                    .font(.caption)
                    .fontWeight(.medium)
                
                HStack {
                    configurationView
                    Spacer()
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: ""))")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                
                Text(safariDescription)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .sheet(isPresented: $showingSafari) {
            SafariView(url: url, style: style)
        }
    }
    
    @ViewBuilder
    private var configurationView: some View {
        switch style {
        case .basic:
            Label("Default", systemImage: "safari")
                .font(.caption2)
                .foregroundStyle(.blue)
        case .readerMode:
            Label("Reader Mode", systemImage: "doc.text")
                .font(.caption2)
                .foregroundStyle(.green)
        case .customTint:
            Label("Custom Tint", systemImage: "paintbrush")
                .font(.caption2)
                .foregroundStyle(.orange)
        case .barCollapsing:
            Label("Bar Collapsing", systemImage: "arrow.up.and.down")
                .font(.caption2)
                .foregroundStyle(.purple)
        }
    }
    
    private var safariDescription: String {
        switch style {
        case .basic:
            return "SFSafariViewController with default settings"
        case .readerMode:
            return "entersReaderIfAvailable = true"
        case .customTint:
            return "preferredControlTintColor = .orange"
        case .barCollapsing:
            return "preferredBarTintColor + dismissButtonStyle"
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    let style: NativeSafariViewStyle
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        
        switch style {
        case .basic:
            // Use default configuration
            break
        case .readerMode:
            configuration.entersReaderIfAvailable = true
        case .customTint:
            // Custom tint will be set on the view controller
            break
        case .barCollapsing:
            configuration.barCollapsingEnabled = true
        }
        
        let safariViewController = SFSafariViewController(url: url, configuration: configuration)
        
        // Apply style-specific customizations
        switch style {
        case .basic, .readerMode:
            break
        case .customTint:
            safariViewController.preferredControlTintColor = .systemOrange
        case .barCollapsing:
            safariViewController.preferredBarTintColor = .systemPurple
            safariViewController.dismissButtonStyle = .close
        }
        
        return safariViewController
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // No updates needed for this example
    }
}

#Preview {
    ScrollView {
        SafariViewShowcase()
            .padding()
    }
} 