import SwiftUI
import UniformTypeIdentifiers

struct DocumentPickerShowcase: View {
    @State private var showDocumentPicker = false
    @State private var showImagePicker = false
    @State private var showPDFPicker = false
    @State private var showMultiplePicker = false
    @State private var selectedDocuments: [URL] = []
    
    var body: some View {
        VStack(spacing: 0) {
            NativeDocumentPickerExample(
                title: "All Documents",
                description: "Native iOS DocumentPicker for all document types",
                style: .allDocuments,
                showPicker: $showDocumentPicker,
                selectedDocuments: $selectedDocuments
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeDocumentPickerExample(
                title: "Images Only",
                description: "DocumentPicker filtered for image files",
                style: .imagesOnly,
                showPicker: $showImagePicker,
                selectedDocuments: $selectedDocuments
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeDocumentPickerExample(
                title: "PDF Documents",
                description: "DocumentPicker specifically for PDF files",
                style: .pdfOnly,
                showPicker: $showPDFPicker,
                selectedDocuments: $selectedDocuments
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeDocumentPickerExample(
                title: "Multiple Selection",
                description: "DocumentPicker allowing multiple file selection",
                style: .multiple,
                showPicker: $showMultiplePicker,
                selectedDocuments: $selectedDocuments
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .fileImporter(
            isPresented: $showDocumentPicker,
            allowedContentTypes: [.item],
            onCompletion: handleDocumentSelection
        )
        .fileImporter(
            isPresented: $showImagePicker,
            allowedContentTypes: [.image],
            onCompletion: handleDocumentSelection
        )
        .fileImporter(
            isPresented: $showPDFPicker,
            allowedContentTypes: [.pdf],
            onCompletion: handleDocumentSelection
        )
        .fileImporter(
            isPresented: $showMultiplePicker,
            allowedContentTypes: [.item],
            allowsMultipleSelection: true,
            onCompletion: handleMultipleDocumentSelection
        )
    }
    
    private func handleDocumentSelection(_ result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            selectedDocuments = [url]
        case .failure(let error):
            print("Document selection failed: \(error)")
        }
    }
    
    private func handleMultipleDocumentSelection(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            selectedDocuments = urls
        case .failure(let error):
            print("Multiple document selection failed: \(error)")
        }
    }
}

public enum NativeDocumentPickerStyle: CaseIterable {
    case allDocuments
    case imagesOnly
    case pdfOnly
    case multiple
    
    var displayName: String {
        switch self {
        case .allDocuments: return "All Documents"
        case .imagesOnly: return "Images Only"
        case .pdfOnly: return "PDF Only"
        case .multiple: return "Multiple"
        }
    }
}

struct NativeDocumentPickerExample: View {
    let title: String
    let description: String
    let style: NativeDocumentPickerStyle
    @Binding var showPicker: Bool
    @Binding var selectedDocuments: [URL]
    
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
                Button("Pick \(buttonLabel)") {
                    showPicker = true
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
                
                // Selection status
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Selected:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    if selectedDocuments.isEmpty {
                        Text("None")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    } else {
                        Text("\(selectedDocuments.count) file\(selectedDocuments.count == 1 ? "" : "s")")
                            .font(.caption2)
                            .foregroundStyle(.green)
                    }
                }
            }
            
            // Show selected files
            if !selectedDocuments.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Selected Files:")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    ForEach(selectedDocuments.prefix(3), id: \.self) { url in
                        HStack(spacing: 6) {
                            Image(systemName: iconForFile(url))
                                .font(.caption)
                                .foregroundStyle(.blue)
                            
                            Text(url.lastPathComponent)
                                .font(.caption2)
                                .lineLimit(1)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.tertiarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    
                    if selectedDocuments.count > 3 {
                        Text("... and \(selectedDocuments.count - 3) more")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: ""))")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                
                Text(contentTypeDescription)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    private var buttonLabel: String {
        switch style {
        case .allDocuments: return "Documents"
        case .imagesOnly: return "Images"
        case .pdfOnly: return "PDFs"
        case .multiple: return "Multiple"
        }
    }
    
    private var contentTypeDescription: String {
        switch style {
        case .allDocuments: return "allowedContentTypes: [.item]"
        case .imagesOnly: return "allowedContentTypes: [.image]"
        case .pdfOnly: return "allowedContentTypes: [.pdf]"
        case .multiple: return "allowsMultipleSelection: true"
        }
    }
    
    private func iconForFile(_ url: URL) -> String {
        let pathExtension = url.pathExtension.lowercased()
        switch pathExtension {
        case "pdf": return "doc.fill"
        case "jpg", "jpeg", "png", "gif", "heic": return "photo"
        case "mp4", "mov", "avi": return "video"
        case "mp3", "wav", "m4a": return "music.note"
        case "txt", "rtf": return "doc.text"
        case "zip", "rar": return "archivebox"
        default: return "doc"
        }
    }
}

#Preview {
    ScrollView {
        DocumentPickerShowcase()
            .padding()
    }
} 