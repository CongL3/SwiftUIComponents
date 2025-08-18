import SwiftUI

struct AsyncImageShowcase: View {
    var body: some View {
        VStack(spacing: 0) {
            NativeAsyncImageExample(
                title: "Basic AsyncImage",
                description: "Native SwiftUI AsyncImage with automatic loading",
                imageURL: "https://picsum.photos/200/200?random=1",
                style: .basic
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeAsyncImageExample(
                title: "AsyncImage with Placeholder",
                description: "AsyncImage with custom placeholder while loading",
                imageURL: "https://picsum.photos/200/200?random=2",
                style: .withPlaceholder
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeAsyncImageExample(
                title: "AsyncImage with Error Handling",
                description: "AsyncImage with custom error view for failed loads",
                imageURL: "https://invalid-url-example.com/image.jpg",
                style: .withErrorHandling
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeAsyncImageExample(
                title: "Styled AsyncImage",
                description: "AsyncImage with custom content modes and styling",
                imageURL: "https://picsum.photos/300/200?random=3",
                style: .styled
            )
            
            Divider()
                .padding(.horizontal)
            
            // Multiple images section
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Multiple AsyncImages")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("Grid of different remote images")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(1...6, id: \.self) { index in
                        AsyncImage(url: URL(string: "https://picsum.photos/150/150?random=\(index + 10)")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 20, height: 20)
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                
                Text("AsyncImage is available on iOS 15.0+")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeAsyncImageStyle: CaseIterable {
    case basic
    case withPlaceholder
    case withErrorHandling
    case styled
    
    var displayName: String {
        switch self {
        case .basic: return "Basic"
        case .withPlaceholder: return "With Placeholder"
        case .withErrorHandling: return "With Error Handling"
        case .styled: return "Styled"
        }
    }
}

struct NativeAsyncImageExample: View {
    let title: String
    let description: String
    let imageURL: String
    let style: NativeAsyncImageStyle
    
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
                // AsyncImage examples
                HStack(spacing: 16) {
                    // Small size
                    VStack(spacing: 4) {
                        asyncImageView
                            .frame(width: 60, height: 60)
                        
                        Text("60x60")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                    
                    // Medium size
                    VStack(spacing: 4) {
                        asyncImageView
                            .frame(width: 80, height: 80)
                        
                        Text("80x80")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                    
                    // Large size (rectangular)
                    VStack(spacing: 4) {
                        asyncImageView
                            .frame(width: 100, height: 70)
                        
                        Text("100x70")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
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
    private var asyncImageView: some View {
        switch style {
        case .basic:
            AsyncImage(url: URL(string: imageURL))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
        case .withPlaceholder:
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                VStack(spacing: 4) {
                    ProgressView()
                        .controlSize(.mini)
                    Text("Loading...")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
        case .withErrorHandling:
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        
                case .failure(_):
                    VStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.title2)
                            .foregroundStyle(.red)
                        Text("Failed")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGray6))
                    
                @unknown default:
                    EmptyView()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
        case .styled:
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.3)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .overlay(
                        ProgressView()
                            .tint(.blue)
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue, lineWidth: 1)
            )
        }
    }
}

#Preview {
    ScrollView {
        AsyncImageShowcase()
            .padding()
    }
} 