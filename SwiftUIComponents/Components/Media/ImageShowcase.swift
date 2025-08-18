import SwiftUI

struct ImageShowcase: View {
    var body: some View {
        VStack(spacing: 0) {
            NativeImageExample(
                title: "Image with Fit Content Mode",
                description: "Native SwiftUI Image with .fit aspect ratio",
                contentMode: .fit,
                systemImage: "photo.artframe"
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeImageExample(
                title: "Image with Fill Content Mode",
                description: "Native SwiftUI Image with .fill aspect ratio",
                contentMode: .fill,
                systemImage: "photo.artframe.circle.fill"
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeImageExample(
                title: "Resizable Image",
                description: "Image that can be resized to fit different frames",
                contentMode: .fit,
                systemImage: "photo.on.rectangle.angled",
                isResizable: true
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeImageExample(
                title: "Styled Image",
                description: "Image with rendering modes and styling",
                contentMode: .fit,
                systemImage: "heart.fill",
                isStyled: true
            )
            
            Divider()
                .padding(.horizontal)
            
            // Image variations section
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Image Variations")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("Different ways to use native SwiftUI Image")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ImageVariation(
                        systemImage: "star.fill",
                        title: "Star",
                        color: .yellow
                    )
                    
                    ImageVariation(
                        systemImage: "heart.fill",
                        title: "Heart",
                        color: .red
                    )
                    
                    ImageVariation(
                        systemImage: "leaf.fill",
                        title: "Leaf",
                        color: .green
                    )
                    
                    ImageVariation(
                        systemImage: "flame.fill",
                        title: "Flame",
                        color: .orange
                    )
                    
                    ImageVariation(
                        systemImage: "drop.fill",
                        title: "Drop",
                        color: .blue
                    )
                    
                    ImageVariation(
                        systemImage: "snowflake",
                        title: "Snow",
                        color: .cyan
                    )
                }
                
                Text("Using SF Symbols with Image(systemName:)")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct NativeImageExample: View {
    let title: String
    let description: String
    let contentMode: ContentMode
    let systemImage: String
    let isResizable: Bool
    let isStyled: Bool
    
    init(title: String, description: String, contentMode: ContentMode, systemImage: String, isResizable: Bool = false, isStyled: Bool = false) {
        self.title = title
        self.description = description
        self.contentMode = contentMode
        self.systemImage = systemImage
        self.isResizable = isResizable
        self.isStyled = isStyled
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
                // Image examples
                HStack(spacing: 16) {
                    // Small size
                    VStack(spacing: 4) {
                        imageView
                            .frame(width: 40, height: 40)
                        
                        Text("40x40")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                    
                    // Medium size
                    VStack(spacing: 4) {
                        imageView
                            .frame(width: 60, height: 60)
                        
                        Text("60x60")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                    
                    // Large size
                    VStack(spacing: 4) {
                        imageView
                            .frame(width: 80, height: 80)
                        
                        Text("80x80")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }
                
                Spacer()
            }
            
            Text("ContentMode: .\(contentMode == .fit ? "fit" : "fill")\(isResizable ? ", resizable" : "")\(isStyled ? ", styled" : "")")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
    
    @ViewBuilder
    private var imageView: some View {
        Group {
            if isResizable {
                if isStyled {
                    Image(systemName: systemImage)
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .foregroundStyle(.red)
                        .symbolRenderingMode(.palette)
                } else {
                    Image(systemName: systemImage)
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .foregroundStyle(.blue)
                }
            } else {
                if isStyled {
                    Image(systemName: systemImage)
                        .font(.title)
                        .foregroundStyle(.red)
                        .symbolRenderingMode(.palette)
                } else {
                    Image(systemName: systemImage)
                        .font(.title)
                        .foregroundStyle(.blue)
                }
            }
        }
        .clipped()
    }
}

struct ImageVariation: View {
    let systemImage: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 40, height: 40)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ScrollView {
        ImageShowcase()
            .padding()
    }
} 