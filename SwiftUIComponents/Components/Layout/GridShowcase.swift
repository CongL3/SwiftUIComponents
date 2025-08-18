import SwiftUI

struct GridShowcase: View {
    var body: some View {
        VStack(spacing: 0) {
            NativeGridExample(
                title: "Basic Grid",
                description: "Native iOS 16+ Grid with basic layout",
                style: .basic
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeGridExample(
                title: "Aligned Grid",
                description: "Grid with column and row alignment",
                style: .aligned
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeGridExample(
                title: "Spaced Grid",
                description: "Grid with custom spacing between cells",
                style: .spaced
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeGridExample(
                title: "Complex Grid",
                description: "Grid with spanning cells and mixed content",
                style: .complex
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeGridStyle: CaseIterable {
    case basic
    case aligned
    case spaced
    case complex
    
    var displayName: String {
        switch self {
        case .basic: return "Basic"
        case .aligned: return "Aligned"
        case .spaced: return "Spaced"
        case .complex: return "Complex"
        }
    }
}

struct NativeGridExample: View {
    let title: String
    let description: String
    let style: NativeGridStyle
    
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
            
            // Grid examples (iOS 16+)
            VStack {
                if #available(iOS 16.0, *) {
                    switch style {
                    case .basic:
                        Grid {
                            GridRow {
                                Color.red.opacity(0.7)
                                Color.blue.opacity(0.7)
                                Color.green.opacity(0.7)
                            }
                            GridRow {
                                Color.orange.opacity(0.7)
                                Color.purple.opacity(0.7)
                                Color.pink.opacity(0.7)
                            }
                            GridRow {
                                Color.yellow.opacity(0.7)
                                Color.cyan.opacity(0.7)
                                Color.mint.opacity(0.7)
                            }
                        }
                        .frame(height: 120)
                        
                    case .aligned:
                        Grid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 8) {
                            GridRow(alignment: .top) {
                                VStack {
                                    Text("A")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    Text("Top")
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                VStack {
                                    Text("B")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    Text("Longer content")
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            GridRow {
                                Text("C")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.orange.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                Text("D")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.purple.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        .frame(height: 140)
                        
                    case .spaced:
                        Grid(horizontalSpacing: 16, verticalSpacing: 16) {
                            GridRow {
                                Circle()
                                    .fill(.red.opacity(0.7))
                                    .overlay(Text("1").foregroundStyle(.white).fontWeight(.bold))
                                
                                Circle()
                                    .fill(.blue.opacity(0.7))
                                    .overlay(Text("2").foregroundStyle(.white).fontWeight(.bold))
                                
                                Circle()
                                    .fill(.green.opacity(0.7))
                                    .overlay(Text("3").foregroundStyle(.white).fontWeight(.bold))
                            }
                            
                            GridRow {
                                Circle()
                                    .fill(.orange.opacity(0.7))
                                    .overlay(Text("4").foregroundStyle(.white).fontWeight(.bold))
                                
                                Circle()
                                    .fill(.purple.opacity(0.7))
                                    .overlay(Text("5").foregroundStyle(.white).fontWeight(.bold))
                                
                                Circle()
                                    .fill(.pink.opacity(0.7))
                                    .overlay(Text("6").foregroundStyle(.white).fontWeight(.bold))
                            }
                        }
                        .frame(height: 120)
                        
                    case .complex:
                        Grid(alignment: .center, horizontalSpacing: 8, verticalSpacing: 8) {
                            GridRow {
                                Text("Header")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .gridColumnAlignment(.center)
                            }
                            
                            GridRow {
                                VStack {
                                    Image(systemName: "star.fill")
                                        .font(.title)
                                        .foregroundStyle(.yellow)
                                    Text("Feature")
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.yellow.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                                
                                Text("Item 1")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                Text("Item 2")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.orange.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            GridRow {
                                Color.clear
    
                                
                                Text("Item 3")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.purple.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                Text("Item 4")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.pink.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        .frame(height: 160)
                    }
                } else {
                    // Fallback for iOS 15
                    VStack(spacing: 8) {
                        Image(systemName: "grid")
                            .font(.title2)
                            .foregroundStyle(.blue)
                        
                        Text("Grid Layout")
                            .font(.headline)
                        
                        Text("Available in iOS 16+")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(height: 120)
                    .background(Color(.secondarySystemBackground))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Style: .\(style.displayName.lowercased())")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                
                Text(gridDescription)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    private var gridDescription: String {
        switch style {
        case .basic:
            return "Grid { GridRow { } }"
        case .aligned:
            return "Grid(alignment: .leading, spacing:)"
        case .spaced:
            return "Grid(horizontalSpacing:, verticalSpacing:)"
        case .complex:
            return "Grid with mixed cell sizes"
        }
    }
}

#Preview {
    ScrollView {
        GridShowcase()
            .padding()
    }
} 