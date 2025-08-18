import SwiftUI

struct SFSymbolsShowcase: View {
    var body: some View {
        VStack(spacing: 0) {
            NativeSFSymbolExample(
                title: "Monochrome Rendering",
                description: "SF Symbols with monochrome rendering mode",
                renderingMode: .monochrome,
                symbols: ["heart.fill", "star.fill", "person.fill", "house.fill"]
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeSFSymbolExample(
                title: "Multicolor Rendering",
                description: "SF Symbols with multicolor rendering mode",
                renderingMode: .multicolor,
                symbols: ["heart.fill", "star.fill", "person.fill", "house.fill"]
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeSFSymbolExample(
                title: "Hierarchical Rendering",
                description: "SF Symbols with hierarchical rendering mode",
                renderingMode: .hierarchical,
                symbols: ["wifi", "battery.100", "signal.3", "antenna.radiowaves.left.and.right"]
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeSFSymbolExample(
                title: "Palette Rendering",
                description: "SF Symbols with palette rendering mode",
                renderingMode: .palette,
                symbols: ["person.crop.circle.fill", "folder.fill", "doc.fill", "trash.fill"]
            )
            
            Divider()
                .padding(.horizontal)
            
            // Symbol variations section
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Symbol Variations & Sizes")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("Different font sizes and symbol weights")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                VStack(spacing: 16) {
                    // Font sizes
                    HStack(spacing: 16) {
                        VStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundStyle(.orange)
                            Text("Caption")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.body)
                                .foregroundStyle(.orange)
                            Text("Body")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.title)
                                .foregroundStyle(.orange)
                            Text("Title")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.orange)
                            Text("Large Title")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    // Symbol weights
                    HStack(spacing: 16) {
                        VStack(spacing: 4) {
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .fontWeight(.ultraLight)
                                .foregroundStyle(.red)
                            Text("Ultra Light")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .fontWeight(.regular)
                                .foregroundStyle(.red)
                            Text("Regular")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                            Text("Bold")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .fontWeight(.black)
                                .foregroundStyle(.red)
                            Text("Black")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Text("SF Symbols 4.0+ includes 5000+ symbols with rendering modes")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeSFSymbolRenderingMode: CaseIterable {
    case monochrome
    case multicolor
    case hierarchical
    case palette
    
    var displayName: String {
        switch self {
        case .monochrome: return "Monochrome"
        case .multicolor: return "Multicolor"
        case .hierarchical: return "Hierarchical"
        case .palette: return "Palette"
        }
    }
    
    var swiftUIRenderingMode: SymbolRenderingMode {
        switch self {
        case .monochrome: return .monochrome
        case .multicolor: return .multicolor
        case .hierarchical: return .hierarchical
        case .palette: return .palette
        }
    }
}

struct NativeSFSymbolExample: View {
    let title: String
    let description: String
    let renderingMode: NativeSFSymbolRenderingMode
    let symbols: [String]
    
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
                // Symbol examples
                HStack(spacing: 20) {
                    ForEach(symbols, id: \.self) { symbolName in
                        VStack(spacing: 8) {
                            symbolView(for: symbolName)
                            
                            Text(symbolName)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .frame(width: 60)
                        }
                    }
                }
                
                Spacer()
            }
            
            Text("Rendering mode: .\(renderingMode.displayName.lowercased())")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
    
    @ViewBuilder
    private func symbolView(for symbolName: String) -> some View {
        switch renderingMode {
        case .monochrome:
            Image(systemName: symbolName)
                .font(.title2)
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(.blue)
                
        case .multicolor:
            Image(systemName: symbolName)
                .font(.title2)
                .symbolRenderingMode(.multicolor)
                
        case .hierarchical:
            Image(systemName: symbolName)
                .font(.title2)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.blue)
                
        case .palette:
            Image(systemName: symbolName)
                .font(.title2)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.blue, .red, .green)
        }
    }
}

#Preview {
    ScrollView {
        SFSymbolsShowcase()
            .padding()
    }
} 