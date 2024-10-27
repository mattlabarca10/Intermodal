import SwiftUI
import MapKit

struct SummaryView: View {
    var startLocation: MKMapItem?
    var destinations: [Destination]

    var body: some View {
        VStack {
            MapView(startLocation: startLocation, destinations: destinations)
                .frame(height: 300) // Set a fixed height for the map

            Text(tripSummary)
                .padding()
                .foregroundColor(.black)
        }
        .onAppear {
            // You can populate data here or rely on the passed parameters
        }
    }
    
    private var startLatitude: Double? {
            return startLocation?.placemark.coordinate.latitude
        }

        private var startLongitude: Double? {
            return startLocation?.placemark.coordinate.longitude
        }
    
    private var destinationCoordinates: [(latitude: Double, longitude: Double)?] {
            return destinations.map { destination in
                guard let coordinate = destination.mapItem?.placemark.coordinate else {
                    return nil
                }
                return (latitude: coordinate.latitude, longitude: coordinate.longitude)
            }
        }
    
    // Distance calculation function
    func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let radius = 6371.0 // Earth's radius in kilometers
        let lat1Rad = lat1 * .pi / 180
        let lat2Rad = lat2 * .pi / 180
        let deltaLonRad = (lon2 - lon1) * .pi / 180
        
        let distance = acos(sin(lat1Rad) * sin(lat2Rad) + cos(lat1Rad) * cos(lat2Rad) * cos(deltaLonRad)) * radius
        return distance
    }
 
    // Computed property to generate trip summary
    private var tripSummary: String {
        guard let start = startLocation else { return "No starting location." }
        
        var summary = "Starting at \(start.name ?? "Unknown")\n"
        var totalDuration: TimeInterval = 0

        // Get start coordinates
        guard let startLat = startLatitude, let startLon = startLongitude else {
            return "No valid coordinates for starting location."
        }

        for destination in destinations {
            guard let destinationMapItem = destination.mapItem else { continue }
            
            let travelTime: TimeInterval = estimateTravelTime(for: destination)
            totalDuration += travelTime
            
            let mode = destination.transportationMode?.rawValue.capitalized ?? "Unknown mode"
            let distance: Double? = calculateDistance(lat1: startLat, lon1: startLon,
                                                      lat2: destinationCoordinates.first??.latitude ?? 0,
                                                      lon2: destinationCoordinates.first??.longitude ?? 0)

            summary += "\(mode) to \(destinationMapItem.name ?? "Unknown"): \(formatTime(travelTime))"
            
            if let distance = distance {
                summary += String(format: " (Distance: %.2f km)\n", distance)
            } else {
                summary += " (Distance: Unknown)\n"
            }
        }
        
        // Adding total duration to the summary
        summary += "Total Duration: \(formatTime(totalDuration))"
        
        return summary
    }

    // Mock travel time estimation method
    private func estimateTravelTime(for destination: Destination) -> TimeInterval {
        switch destination.transportationMode {
        case .walk:
            return 2 / 5.1 // 30 minutes
        case .bike:
            return 2 / 20 // 15 minutes
        case .car:
            return 2 / 64 // 1 hour 20 minutes
        default:
            return 0 // 0 minutes for unknown modes
        }
    }

    // Format TimeInterval to human-readable format
    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        return "\(hours) hr \(minutes) min"
    }
}

// Preview for SummaryView
struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(destinations: [])
    }
}
