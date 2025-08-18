import SwiftUI
import AVKit

struct VideoPlayerShowcase: View {
    @State private var player1 = AVPlayer(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
    @State private var player2 = AVPlayer(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!)
    
    var body: some View {
        VStack(spacing: 0) {
            NativeVideoPlayerExample(
                title: "Basic VideoPlayer",
                description: "Native iOS VideoPlayer with default controls",
                player: player1,
                style: .basic
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeVideoPlayerExample(
                title: "VideoPlayer with Overlay",
                description: "VideoPlayer with custom overlay content",
                player: player2,
                style: .withOverlay
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeVideoPlayerExample(
                title: "Compact VideoPlayer",
                description: "Smaller VideoPlayer for preview purposes",
                player: player1,
                style: .compact
            )
            
            Divider()
                .padding(.horizontal)
            
            // Video controls section
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Video Controls")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("Control video playback and test different states")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                HStack(spacing: 12) {
                    Button("Play") {
                        player1.play()
                        player2.play()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Pause") {
                        player1.pause()
                        player2.pause()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Restart") {
                        player1.seek(to: .zero)
                        player2.seek(to: .zero)
                        player1.play()
                        player2.play()
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                }
                
                Text("VideoPlayer is available on iOS 14.0+")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onDisappear {
            player1.pause()
            player2.pause()
        }
    }
}

public enum NativeVideoPlayerStyle: CaseIterable {
    case basic
    case withOverlay
    case compact
    
    var displayName: String {
        switch self {
        case .basic: return "Basic"
        case .withOverlay: return "With Overlay"
        case .compact: return "Compact"
        }
    }
}

struct NativeVideoPlayerExample: View {
    let title: String
    let description: String
    let player: AVPlayer
    let style: NativeVideoPlayerStyle
    
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
                case .basic:
                    VideoPlayer(player: player)
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                case .withOverlay:
                    VideoPlayer(player: player) {
                        VStack {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Sample Video")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text("With Custom Overlay")
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.8))
                                }
                                Spacer()
                            }
                            .padding()
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    if player.timeControlStatus == .playing {
                                        player.pause()
                                    } else {
                                        player.play()
                                    }
                                }) {
                                    Image(systemName: player.timeControlStatus == .playing ? "pause.circle.fill" : "play.circle.fill")
                                        .font(.system(size: 44))
                                        .foregroundStyle(.white)
                                        .background(Color.black.opacity(0.3))
                                        .clipShape(Circle())
                                }
                                
                                Spacer()
                            }
                            .padding()
                        }
                    }
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                case .compact:
                    VideoPlayer(player: player)
                        .frame(height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            
            Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: ""))")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

#Preview {
    ScrollView {
        VideoPlayerShowcase()
            .padding()
    }
} 