import SwiftUI
import MapKit

struct SummaryView: View {
    var startLocation: MKMapItem?
    var destinations: [Destination]

    @State private var travelTimes: [TimeInterval] = [] // Array to hold travel times
    @State private var isFetchingTravelTimes = true // State to check if fetching is in progress

    var body: some View {
        VStack {
            MapView(startLocation: startLocation, destinations: destinations)
                .frame(height: 300) // Set a fixed height for the map

            Text(tripSummary)
                .padding()
                .foregroundColor(.black)
                .onAppear(perform: fetchTravelTimes) // Start fetching travel times on appear

            Spacer()
            
            
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

    private var tripSummary: String {
        guard let start = startLocation else { return "No starting location." }

        var summary = "Starting at \(start.name ?? "Unknown")\n"
        var totalDuration: TimeInterval = 0

        // Get start coordinates
        guard let startLat = startLatitude, let startLon = startLongitude else {
            return "No valid coordinates for starting location."
        }

        for (index, destination) in destinations.enumerated() {
            guard let destinationMapItem = destination.mapItem else { continue }

            // Calculate distance to the destination
            let destinationCoord = destinationCoordinates[index]
            guard let destLat = destinationCoord?.latitude, let destLon = destinationCoord?.longitude else {
                continue // Skip if destination coordinates are invalid
            }

            let distance = calculateDistance(lat1: startLat, lon1: startLon, lat2: destLat, lon2: destLon)

            // Get travel time from the travelTimes array
            let travelTime = index < travelTimes.count ? travelTimes[index] : 0 // Default to 0 if travel time not yet fetched

            let mode = destination.transportationMode?.rawValue.capitalized ?? "Unknown mode"
            summary += "\(mode) to \(destinationMapItem.name ?? "Unknown"): \(formatTime(travelTime))"
            summary += String(format: " (Distance: %.2f km)\n", distance)

            totalDuration += travelTime // Add travel time to total duration
        }

        // Adding total duration to the summary
        summary += "Total Duration: \(formatTime(totalDuration))"

        return summary
    }

    // Method to fetch travel times for each destination
    private func fetchTravelTimes() {
        guard let startLocation = startLocation else { return }

        travelTimes = Array(repeating: 0, count: destinations.count) // Reset travel times array to match the number of destinations
        isFetchingTravelTimes = true

        let group = DispatchGroup() // Group to manage asynchronous requests

        for (index, destination) in destinations.enumerated() {
            guard let destinationMapItem = destination.mapItem else { continue }
            group.enter() // Enter the group for each request

            estimateTravelTime(from: startLocation, to: destinationMapItem, mode: destination.transportationMode ?? .walk) { travelTime in
                travelTimes[index] = travelTime // Append travel time to the correct index
                group.leave() // Leave the group once done
            }
        }

        group.notify(queue: .main) {
            isFetchingTravelTimes = false // Mark fetching as complete
        }
    }

    // Travel time estimation method
    private func estimateTravelTime(from source: MKMapItem, to destination: MKMapItem, mode: TransportationMode, completion: @escaping (TimeInterval) -> Void) {
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination

        // Set transportation type based on mode
        switch mode {
        case .walk:
            request.transportType = .walking
        case .bike:
            request.transportType = .walking // Note: Use automobile since MKMapKit does not support bike routes directly
        case .car:
            request.transportType = .automobile
        default:
            completion(0) // Unknown mode
            return
        }

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("Error calculating directions: \(error.localizedDescription)")
                completion(0) // Return 0 in case of an error
                return
            }

            guard let route = response?.routes.first else {
                print("No route found.")
                completion(0) // Return 0 if no route is found
                return
            }

            // Adjust expected travel time for biking
            let expectedTravelTime = route.expectedTravelTime
            if mode == .bike {
                completion(expectedTravelTime / 3) // Adjust travel time for biking
            } else {
                completion(expectedTravelTime) // Pass the estimated time for other modes
            }
        }
    }

    // Calculate distance function
    func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let radius = 6371.0 // Earth's radius in kilometers
        let lat1Rad = lat1 * .pi / 180
        let lat2Rad = lat2 * .pi / 180
        let deltaLonRad = (lon2 - lon1) * .pi / 180

        let distance = acos(sin(lat1Rad) * sin(lat2Rad) + cos(lat1Rad) * cos(lat2Rad) * cos(deltaLonRad)) * radius
        return distance
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
