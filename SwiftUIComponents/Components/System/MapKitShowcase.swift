import SwiftUI
import MapKit

struct MapKitShowcase: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    @State private var annotations = [
        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), title: "San Francisco"),
        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094), title: "Marker 2"),
        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37.7649, longitude: -122.4294), title: "Marker 3")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            NativeMapKitExample(
                title: "Standard Map",
                description: "Native SwiftUI Map with standard view",
                style: .standard,
                region: $region,
                annotations: annotations
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeMapKitExample(
                title: "Satellite Map",
                description: "Map with satellite imagery",
                style: .satellite,
                region: $region,
                annotations: annotations
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeMapKitExample(
                title: "Hybrid Map",
                description: "Map with satellite imagery and labels",
                style: .hybrid,
                region: $region,
                annotations: annotations
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeMapKitExample(
                title: "Map with Annotations",
                description: "Interactive map with custom annotations",
                style: .withAnnotations,
                region: $region,
                annotations: annotations
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct MapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
}

public enum NativeMapKitStyle: CaseIterable {
    case standard
    case satellite
    case hybrid
    case withAnnotations
    
    var displayName: String {
        switch self {
        case .standard: return "Standard"
        case .satellite: return "Satellite"
        case .hybrid: return "Hybrid"
        case .withAnnotations: return "With Annotations"
        }
    }
    
    var mapType: MKMapType {
        switch self {
        case .standard, .withAnnotations: return .standard
        case .satellite: return .satellite
        case .hybrid: return .hybrid
        }
    }
}

struct NativeMapKitExample: View {
    let title: String
    let description: String
    let style: NativeMapKitStyle
    @Binding var region: MKCoordinateRegion
    let annotations: [MapAnnotation]
    
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
            
            // Map view
            if #available(iOS 17.0, *) {
                Map(coordinateRegion: $region, annotationItems: style == .withAnnotations ? annotations : []) { annotation in
                    MapPin(coordinate: annotation.coordinate, tint: .red)
                }
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            } else {
                // Fallback for iOS 16
                Map(coordinateRegion: $region, annotationItems: style == .withAnnotations ? annotations : []) { annotation in
                    MapPin(coordinate: annotation.coordinate, tint: .red)
                }
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Map Controls:")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    HStack(spacing: 8) {
                        Button("SF") {
                            withAnimation {
                                region.center = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
                            }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.mini)
                        
                        Button("NYC") {
                            withAnimation {
                                region.center = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
                            }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.mini)
                        
                        Button("London") {
                            withAnimation {
                                region.center = CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)
                            }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.mini)
                    }
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: ""))")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                
                Text(mapTypeDescription)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    private var mapTypeDescription: String {
        switch style {
        case .standard: return "Map() with standard view"
        case .satellite: return "Map() with satellite imagery"
        case .hybrid: return "Map() with hybrid view"
        case .withAnnotations: return "Map() with MapPin annotations"
        }
    }
}

#Preview {
    ScrollView {
        MapKitShowcase()
            .padding()
    }
} 