import SwiftUI

struct FullScreenCoverShowcase: View {
    @State private var showingBasicCover = false
    @State private var showingInteractiveCover = false
    @State private var showingCustomCover = false
    @State private var showingConditionalCover = false
    
    var body: some View {
        VStack(spacing: 0) {
            NativeFullScreenCoverExample(
                title: "Basic Full Screen",
                description: "Native SwiftUI fullScreenCover presentation",
                style: .basic,
                showingCover: $showingBasicCover
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeFullScreenCoverExample(
                title: "Interactive Cover",
                description: "Full screen cover with interactive content",
                style: .interactive,
                showingCover: $showingInteractiveCover
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeFullScreenCoverExample(
                title: "Custom Styled Cover",
                description: "Full screen cover with custom styling",
                style: .customStyled,
                showingCover: $showingCustomCover
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeFullScreenCoverExample(
                title: "Conditional Cover",
                description: "Full screen cover with conditional presentation",
                style: .conditional,
                showingCover: $showingConditionalCover
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeFullScreenCoverStyle: CaseIterable {
    case basic
    case interactive
    case customStyled
    case conditional
    
    var displayName: String {
        switch self {
        case .basic: return "Basic"
        case .interactive: return "Interactive"
        case .customStyled: return "Custom Styled"
        case .conditional: return "Conditional"
        }
    }
}

struct NativeFullScreenCoverExample: View {
    let title: String
    let description: String
    let style: NativeFullScreenCoverStyle
    @Binding var showingCover: Bool
    
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
                Button("Present Cover") {
                    showingCover = true
                }
                .buttonStyle(.borderedProminent)
                .fullScreenCover(isPresented: $showingCover) {
                    fullScreenContent
                }
                
                Spacer()
                
                // Style indicator
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Style:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    styleLabel
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: ""))")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                
                Text(coverDescription)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private var fullScreenContent: some View {
        NavigationView {
            Group {
                switch style {
                case .basic:
                    BasicFullScreenView(showingCover: $showingCover)
                case .interactive:
                    InteractiveFullScreenView(showingCover: $showingCover)
                case .customStyled:
                    CustomStyledFullScreenView(showingCover: $showingCover)
                case .conditional:
                    ConditionalFullScreenView(showingCover: $showingCover)
                }
            }
        }
    }
    
    @ViewBuilder
    private var styleLabel: some View {
        switch style {
        case .basic:
            Label("Basic", systemImage: "rectangle.fill")
                .font(.caption2)
                .foregroundStyle(.blue)
        case .interactive:
            Label("Interactive", systemImage: "hand.tap")
                .font(.caption2)
                .foregroundStyle(.green)
        case .customStyled:
            Label("Styled", systemImage: "paintbrush")
                .font(.caption2)
                .foregroundStyle(.orange)
        case .conditional:
            Label("Conditional", systemImage: "questionmark.diamond")
                .font(.caption2)
                .foregroundStyle(.purple)
        }
    }
    
    private var coverDescription: String {
        switch style {
        case .basic:
            return ".fullScreenCover(isPresented:)"
        case .interactive:
            return "Full screen with interactive controls"
        case .customStyled:
            return "Full screen with custom background"
        case .conditional:
            return "Full screen with state management"
        }
    }
}

struct BasicFullScreenView: View {
    @Binding var showingCover: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "rectangle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
            
            Text("Basic Full Screen Cover")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This is a basic full screen cover presentation. It covers the entire screen and can be dismissed.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Dismiss") {
                showingCover = false
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .navigationBarHidden(true)
    }
}

struct InteractiveFullScreenView: View {
    @Binding var showingCover: Bool
    @State private var sliderValue: Double = 50
    @State private var isToggleOn = false
    @State private var selectedOption = 0
    
    let options = ["Option 1", "Option 2", "Option 3"]
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Interactive Full Screen")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                VStack {
                    Text("Slider Value: \(Int(sliderValue))")
                        .font(.headline)
                    
                    Slider(value: $sliderValue, in: 0...100)
                        .padding(.horizontal)
                }
                
                Toggle("Enable Feature", isOn: $isToggleOn)
                    .padding(.horizontal)
                
                Picker("Select Option", selection: $selectedOption) {
                    ForEach(0..<options.count, id: \.self) { index in
                        Text(options[index]).tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            
            Button("Done") {
                showingCover = false
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Close") {
                    showingCover = false
                }
            }
        }
    }
}

struct CustomStyledFullScreenView: View {
    @Binding var showingCover: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.purple, .blue, .teal]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "sparkles")
                    .font(.system(size: 80))
                    .foregroundStyle(.white)
                
                Text("Custom Styled Cover")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text("This full screen cover has a custom gradient background and white text styling.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.horizontal)
                
                Button("Dismiss") {
                    showingCover = false
                }
                .buttonStyle(.bordered)
                .foregroundStyle(.white)
                .background(Color.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .navigationBarHidden(true)
    }
}

struct ConditionalFullScreenView: View {
    @Binding var showingCover: Bool
    @State private var hasAcceptedTerms = false
    @State private var userName = ""
    @State private var canProceed = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Conditional Full Screen")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                TextField("Enter your name", text: $userName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                Toggle("I accept the terms and conditions", isOn: $hasAcceptedTerms)
                    .padding(.horizontal)
                
                if hasAcceptedTerms && !userName.isEmpty {
                    Text("Hello, \(userName)! You can now proceed.")
                        .font(.headline)
                        .foregroundStyle(.green)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut, value: hasAcceptedTerms)
            .animation(.easeInOut, value: userName)
            
            HStack(spacing: 16) {
                Button("Cancel") {
                    showingCover = false
                }
                .buttonStyle(.bordered)
                
                Button("Proceed") {
                    showingCover = false
                }
                .buttonStyle(.borderedProminent)
                .disabled(!hasAcceptedTerms || userName.isEmpty)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Close") {
                    showingCover = false
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        FullScreenCoverShowcase()
            .padding()
    }
} 