import SwiftUI

struct HUDLoadingShowcase: View {
    @State private var isLoading = false
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            NativeHUDLoadingExample(
                title: "Basic Activity Indicator",
                description: "Native iOS ProgressView as activity indicator",
                style: .basic,
                isLoading: $isLoading
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeHUDLoadingExample(
                title: "Activity with Label",
                description: "Activity indicator with descriptive text",
                style: .withLabel,
                isLoading: $isLoading
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeHUDLoadingExample(
                title: "Overlay Loading",
                description: "Full-screen overlay loading indicator",
                style: .overlay,
                isLoading: $isLoading
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeHUDLoadingExample(
                title: "Loading States",
                description: "Different loading states and feedback",
                style: .states,
                isLoading: $isLoading
            )
            
            Divider()
                .padding(.horizontal)
            
            // Loading controls section
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Loading Controls")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("Toggle loading states and test different indicators")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                VStack(spacing: 12) {
                    HStack {
                        Button(isLoading ? "Stop Loading" : "Start Loading") {
                            withAnimation {
                                isLoading.toggle()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Spacer()
                        
                        Button("Show Alert") {
                            showAlert = true
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    HStack(spacing: 16) {
                        // Small indicators
                        ProgressView()
                            .controlSize(.mini)
                            .tint(.blue)
                        
                        ProgressView()
                            .controlSize(.small)
                            .tint(.green)
                        
                        ProgressView()
                            .controlSize(.regular)
                            .tint(.orange)
                        
                        ProgressView()
                            .controlSize(.large)
                            .tint(.red)
                        
                        Spacer()
                        
                        Text("Different sizes")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Text("Native iOS activity indicators with different control sizes")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .alert("Loading Complete", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text("This demonstrates native iOS alert presentation.")
        }
    }
}

public enum NativeHUDLoadingStyle: CaseIterable {
    case basic
    case withLabel
    case overlay
    case states
    
    var displayName: String {
        switch self {
        case .basic: return "Basic"
        case .withLabel: return "With Label"
        case .overlay: return "Overlay"
        case .states: return "States"
        }
    }
}

struct NativeHUDLoadingExample: View {
    let title: String
    let description: String
    let style: NativeHUDLoadingStyle
    @Binding var isLoading: Bool
    
    @State private var loadingProgress: Double = 0.0
    @State private var loadingMessage = "Loading..."
    
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
                // Loading examples
                Group {
                    switch style {
                    case .basic:
                        HStack(spacing: 16) {
                            ProgressView()
                                .opacity(isLoading ? 1 : 0.3)
                            
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.blue)
                                .opacity(isLoading ? 1 : 0.3)
                            
                            ProgressView()
                                .controlSize(.large)
                                .tint(.green)
                                .opacity(isLoading ? 1 : 0.3)
                        }
                        
                    case .withLabel:
                        VStack(spacing: 8) {
                            ProgressView("Loading data...")
                                .opacity(isLoading ? 1 : 0.3)
                            
                            ProgressView {
                                HStack(spacing: 8) {
                                    Text("Processing")
                                    Image(systemName: "gear")
                                        .rotationEffect(.degrees(isLoading ? 360 : 0))
                                        .animation(isLoading ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isLoading)
                                }
                            }
                            .opacity(isLoading ? 1 : 0.3)
                        }
                        
                    case .overlay:
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.secondarySystemBackground))
                                .frame(width: 120, height: 80)
                            
                            VStack(spacing: 8) {
                                ProgressView()
                                    .controlSize(.large)
                                    .tint(.blue)
                                
                                Text("Loading...")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .opacity(isLoading ? 1 : 0.3)
                        .scaleEffect(isLoading ? 1 : 0.8)
                        .animation(.easeInOut(duration: 0.3), value: isLoading)
                        
                    case .states:
                        VStack(spacing: 8) {
                            HStack(spacing: 12) {
                                if isLoading {
                                    ProgressView()
                                        .controlSize(.small)
                                    Text("Loading...")
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                    Text("Ready")
                                }
                            }
                            .font(.caption)
                            
                            HStack(spacing: 12) {
                                Image(systemName: isLoading ? "wifi" : "wifi.slash")
                                    .foregroundStyle(isLoading ? .blue : .red)
                                Text(isLoading ? "Connected" : "Offline")
                            }
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Spacer()
            }
            
            Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: "")) - \(isLoading ? "Active" : "Inactive")")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .onAppear {
            if isLoading {
                startLoadingAnimation()
            }
        }
        .onChange(of: isLoading) { _, newValue in
            if newValue {
                startLoadingAnimation()
            }
        }
    }
    
    private func startLoadingAnimation() {
        loadingProgress = 0.0
        withAnimation(.linear(duration: 3.0)) {
            loadingProgress = 1.0
        }
    }
}

#Preview {
    ScrollView {
        HUDLoadingShowcase()
            .padding()
    }
} 