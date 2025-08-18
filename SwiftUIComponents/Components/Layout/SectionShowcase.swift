import SwiftUI

struct SectionShowcase: View {
    var body: some View {
        VStack(spacing: 0) {
            NativeSectionExample(
                title: "Basic Section",
                description: "Native SwiftUI Section with header",
                style: .basic
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeSectionExample(
                title: "Section with Footer",
                description: "Section with both header and footer",
                style: .withFooter
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeSectionExample(
                title: "Section with Content",
                description: "Section with custom header and footer content",
                style: .withContent
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeSectionExample(
                title: "Collapsible Section",
                description: "Section that can be collapsed and expanded",
                style: .collapsible
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeSectionStyle: CaseIterable {
    case basic
    case withFooter
    case withContent
    case collapsible
    
    var displayName: String {
        switch self {
        case .basic: return "Basic"
        case .withFooter: return "With Footer"
        case .withContent: return "With Content"
        case .collapsible: return "Collapsible"
        }
    }
}

struct NativeSectionExample: View {
    let title: String
    let description: String
    let style: NativeSectionStyle
    @State private var isExpanded = true
    
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
            
            // Section examples
            VStack(spacing: 8) {
                switch style {
                case .basic:
                    List {
                        Section("Settings") {
                            Label("Notifications", systemImage: "bell")
                            Label("Privacy", systemImage: "lock")
                            Label("Accessibility", systemImage: "accessibility")
                        }
                    }
                    .frame(height: 120)
                    
                case .withFooter:
                    List {
                        Section {
                            Label("Face ID", systemImage: "faceid")
                            Label("Touch ID", systemImage: "touchid")
                            Label("Passcode", systemImage: "lock.fill")
                        } header: {
                            Text("Security")
                        } footer: {
                            Text("These settings help protect your personal information.")
                        }
                    }
                    .frame(height: 140)
                    
                case .withContent:
                    List {
                        Section {
                            Label("iCloud Drive", systemImage: "icloud")
                            Label("Photos", systemImage: "photo.on.rectangle")
                            Label("Mail", systemImage: "envelope")
                        } header: {
                            HStack {
                                Image(systemName: "icloud.fill")
                                    .foregroundStyle(.blue)
                                Text("iCloud Services")
                                    .fontWeight(.medium)
                            }
                        } footer: {
                            HStack {
                                Image(systemName: "info.circle")
                                    .foregroundStyle(.secondary)
                                Text("Sync your data across all your devices.")
                                    .font(.footnote)
                            }
                        }
                    }
                    .frame(height: 140)
                    
                case .collapsible:
                    List {
                        Section(isExpanded: $isExpanded) {
                            if isExpanded {
                                Label("Wi-Fi", systemImage: "wifi")
                                Label("Bluetooth", systemImage: "bluetooth")
                                Label("Cellular", systemImage: "antenna.radiowaves.left.and.right")
                                Label("Personal Hotspot", systemImage: "personalhotspot")
                            }
                        } header: {
                            HStack {
                                Text("Network Settings")
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        isExpanded.toggle()
                                    }
                                }) {
                                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .frame(height: isExpanded ? 140 : 60)
                    .animation(.easeInOut, value: isExpanded)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: ""))")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                
                Text(sectionDescription)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    private var sectionDescription: String {
        switch style {
        case .basic:
            return "Section(\"Header\") { content }"
        case .withFooter:
            return "Section { } header: { } footer: { }"
        case .withContent:
            return "Section with custom header/footer views"
        case .collapsible:
            return "Section(isExpanded: $binding) { }"
        }
    }
}

#Preview {
    ScrollView {
        SectionShowcase()
            .padding()
    }
} 