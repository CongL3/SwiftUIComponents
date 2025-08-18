import SwiftUI

struct DividerSpacerShowcase: View {
    var body: some View {
        VStack(spacing: 0) {
            NativeDividerSpacerExample(
                title: "Horizontal Divider",
                description: "Native SwiftUI Divider for horizontal separation",
                style: .horizontalDivider
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeDividerSpacerExample(
                title: "Vertical Divider",
                description: "Divider used in horizontal layouts",
                style: .verticalDivider
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeDividerSpacerExample(
                title: "Flexible Spacer",
                description: "Native SwiftUI Spacer for flexible spacing",
                style: .spacer
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeDividerSpacerExample(
                title: "Mixed Layout",
                description: "Combining Dividers and Spacers in layouts",
                style: .mixed
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeDividerSpacerStyle: CaseIterable {
    case horizontalDivider
    case verticalDivider
    case spacer
    case mixed
    
    var displayName: String {
        switch self {
        case .horizontalDivider: return "Horizontal Divider"
        case .verticalDivider: return "Vertical Divider"
        case .spacer: return "Spacer"
        case .mixed: return "Mixed"
        }
    }
}

struct NativeDividerSpacerExample: View {
    let title: String
    let description: String
    let style: NativeDividerSpacerStyle
    
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
            
            Group {
                switch style {
                case .horizontalDivider:
                    VStack(spacing: 8) {
                        Text("Content Above")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Divider()
                        
                        Text("Content Below")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                case .verticalDivider:
                    HStack(spacing: 8) {
                        Text("Left Content")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Divider()
                            .frame(width: 1, height: 60)
                        
                        Text("Right Content")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                case .spacer:
                    VStack(spacing: 8) {
                        HStack {
                            Text("Left")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            
                            Spacer()
                            
                            Text("Right")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.green.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        
                        VStack {
                            Text("Top")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.orange.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            
                            Spacer()
                            
                            Text("Bottom")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.purple.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .frame(height: 80)
                    }
                    
                case .mixed:
                    VStack(spacing: 8) {
                        HStack {
                            Text("Item 1")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(.tertiarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            
                            Spacer()
                            
                            Text("Item 2")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(.tertiarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            
                            Spacer()
                            
                            Text("Item 3")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(.tertiarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                        
                        Divider()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Section A")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                Text("Content here")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Divider()
                                .frame(width: 1, height: 40)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Section B")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                Text("More content")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .frame(height: 100)
            .padding(.horizontal, 4)
            
            Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: ""))")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

#Preview {
    ScrollView {
        DividerSpacerShowcase()
            .padding()
    }
} 