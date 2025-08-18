import SwiftUI
import PhotosUI

struct PhotosPickerShowcase: View {
    @State private var selectedImage: PhotosPickerItem?
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var selectedVideo: PhotosPickerItem?
    @State private var displayedImage: Image?
    @State private var displayedImages: [Image] = []
    
    var body: some View {
        VStack(spacing: 0) {
            NativePhotosPickerExample(
                title: "Single Photo Picker",
                description: "Native iOS PhotosPicker for selecting single photos",
                style: .singlePhoto,
                selectedImage: $selectedImage,
                selectedImages: $selectedImages,
                selectedVideo: $selectedVideo,
                displayedImage: $displayedImage,
                displayedImages: $displayedImages
            )
            
            Divider()
                .padding(.horizontal)
            
            NativePhotosPickerExample(
                title: "Multiple Photos Picker",
                description: "PhotosPicker for selecting multiple photos",
                style: .multiplePhotos,
                selectedImage: $selectedImage,
                selectedImages: $selectedImages,
                selectedVideo: $selectedVideo,
                displayedImage: $displayedImage,
                displayedImages: $displayedImages
            )
            
            Divider()
                .padding(.horizontal)
            
            NativePhotosPickerExample(
                title: "Video Picker",
                description: "PhotosPicker specifically for video content",
                style: .video,
                selectedImage: $selectedImage,
                selectedImages: $selectedImages,
                selectedVideo: $selectedVideo,
                displayedImage: $displayedImage,
                displayedImages: $displayedImages
            )
            
            Divider()
                .padding(.horizontal)
            
            NativePhotosPickerExample(
                title: "Mixed Media Picker",
                description: "PhotosPicker for both photos and videos",
                style: .mixed,
                selectedImage: $selectedImage,
                selectedImages: $selectedImages,
                selectedVideo: $selectedVideo,
                displayedImage: $displayedImage,
                displayedImages: $displayedImages
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativePhotosPickerStyle: CaseIterable {
    case singlePhoto
    case multiplePhotos
    case video
    case mixed
    
    var displayName: String {
        switch self {
        case .singlePhoto: return "Single Photo"
        case .multiplePhotos: return "Multiple Photos"
        case .video: return "Video"
        case .mixed: return "Mixed Media"
        }
    }
}

struct NativePhotosPickerExample: View {
    let title: String
    let description: String
    let style: NativePhotosPickerStyle
    @Binding var selectedImage: PhotosPickerItem?
    @Binding var selectedImages: [PhotosPickerItem]
    @Binding var selectedVideo: PhotosPickerItem?
    @Binding var displayedImage: Image?
    @Binding var displayedImages: [Image]
    
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
                // PhotosPicker buttons
                Group {
                    switch style {
                    case .singlePhoto:
                        PhotosPicker(
                            selection: $selectedImage,
                            matching: .images
                        ) {
                            HStack(spacing: 6) {
                                Image(systemName: "photo")
                                Text("Select Photo")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .onChange(of: selectedImage) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    displayedImage = Image(uiImage: uiImage)
                                }
                            }
                        }
                        
                    case .multiplePhotos:
                        PhotosPicker(
                            selection: $selectedImages,
                            maxSelectionCount: 3,
                            matching: .images
                        ) {
                            HStack(spacing: 6) {
                                Image(systemName: "photo.stack")
                                Text("Select Photos")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .onChange(of: selectedImages) { _, newItems in
                            Task {
                                displayedImages = []
                                for item in newItems {
                                    if let data = try? await item.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        displayedImages.append(Image(uiImage: uiImage))
                                    }
                                }
                            }
                        }
                        
                    case .video:
                        PhotosPicker(
                            selection: $selectedVideo,
                            matching: .videos
                        ) {
                            HStack(spacing: 6) {
                                Image(systemName: "video")
                                Text("Select Video")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        
                    case .mixed:
                        PhotosPicker(
                            selection: $selectedImages,
                            maxSelectionCount: 2,
                            matching: .any(of: [.images, .videos])
                        ) {
                            HStack(spacing: 6) {
                                Image(systemName: "photo.on.rectangle.angled")
                                Text("Select Media")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                
                Spacer()
                
                // Preview area
                Group {
                    switch style {
                    case .singlePhoto:
                        if let displayedImage {
                            displayedImage
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray5))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundStyle(.secondary)
                                )
                        }
                        
                    case .multiplePhotos:
                        HStack(spacing: 4) {
                            ForEach(0..<min(displayedImages.count, 3), id: \.self) { index in
                                displayedImages[index]
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                            
                            if displayedImages.isEmpty {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(.systemGray5))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Image(systemName: "photo.stack")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    )
                            }
                        }
                        
                    case .video:
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedVideo != nil ? Color.blue.opacity(0.2) : Color(.systemGray5))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: selectedVideo != nil ? "checkmark.circle.fill" : "video")
                                    .foregroundStyle(selectedVideo != nil ? .blue : .secondary)
                            )
                        
                    case .mixed:
                        HStack(spacing: 4) {
                            ForEach(0..<min(selectedImages.count, 2), id: \.self) { index in
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.green.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.green)
                                    )
                            }
                            
                            if selectedImages.isEmpty {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(.systemGray5))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Image(systemName: "photo.on.rectangle.angled")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    )
                            }
                        }
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: ""))")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                
                Text(statusText)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    private var statusText: String {
        switch style {
        case .singlePhoto:
            return selectedImage != nil ? "Photo selected" : "No photo selected"
        case .multiplePhotos:
            return selectedImages.isEmpty ? "No photos selected" : "\(selectedImages.count) photo\(selectedImages.count == 1 ? "" : "s") selected"
        case .video:
            return selectedVideo != nil ? "Video selected" : "No video selected"
        case .mixed:
            return selectedImages.isEmpty ? "No media selected" : "\(selectedImages.count) item\(selectedImages.count == 1 ? "" : "s") selected"
        }
    }
}

#Preview {
    ScrollView {
        PhotosPickerShowcase()
            .padding()
    }
} 