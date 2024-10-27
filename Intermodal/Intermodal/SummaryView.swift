import SwiftUI
import MapKit

struct SummaryView: View {
    var startLocation: MKMapItem?
    var destinations: [Destination]

    @State private var travelTimes: [TimeInterval] = []
    @State private var isFetchingTravelTimes = true

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 38/255, green: 38/255, blue: 38/255)
                    .edgesIgnoringSafeArea(.all) // Set background color

                VStack {
                    MapView(startLocation: startLocation, destinations: destinations)
                        .frame(height: 250) // Adjust height and move map up
                        .cornerRadius(10)
                        .padding([.horizontal, .top])
                    
                    ScrollView { // Enable scrolling for trip summary
                        VStack(alignment: .leading, spacing: 15) {
                            if isFetchingTravelTimes {
                                ProgressView("Calculating travel times...")
                                    .foregroundColor(.white)
                                    .padding(.bottom)
                            } else {
                                Text("Trip Summary")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                    .padding(.vertical, 5)
                                
                                Text(tripSummary)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                            }
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6).opacity(0.15))
                        .cornerRadius(12)
                        .shadow(radius: 3)
                        .padding([.horizontal, .bottom])
                    }
                    HStack {
                        NavigationLink(destination: TripCompleteView(startLocation: startLocation, destinations: destinations)) {
                            Text("End Your Trip")
                                .foregroundColor(.white)
                                .padding(.horizontal, 122)
                                .padding(.vertical, 10)
                                .background(Color.green)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .overlay(RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.green, lineWidth: 2))
                        }
                    }
                    
                }
            }
            .onAppear(perform: fetchTravelTimes)
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

        var summary = "Starting Location:\n \(start.name ?? "Unknown\n")"
        
        var totalDuration: TimeInterval = 0
        var totalDistance: Double = 0

        guard let startLat = startLatitude, let startLon = startLongitude else {
            return "No valid coordinates for starting location."
        }

        for (index, destination) in destinations.enumerated() {
            guard let destinationMapItem = destination.mapItem else { continue }

            let destinationCoord = destinationCoordinates[index]
            guard let destLat = destinationCoord?.latitude, let destLon = destinationCoord?.longitude else {
                continue
            }

            let distance = calculateDistance(lat1: startLat, lon1: startLon, lat2: destLat, lon2: destLon)
            let travelTime = index < travelTimes.count ? travelTimes[index] : 0
            let mode = destination.transportationMode?.rawValue.capitalized ?? "Unknown mode"
            
            summary += "Trip to \(destinationMapItem.name ?? "Unknown") by \(mode)\n Trip Time: \(formatTime(travelTime))\n"
            summary += String(format: " (Trip Distance: %.2f km)\n", distance)
            totalDistance += distance
            totalDuration += travelTime
        }

        summary += "\nTotal Duration: \(formatTime(totalDuration))"
        summary += "\nTotal Distance: \((totalDistance))"
        return summary
    }

    private func fetchTravelTimes() {
        guard let startLocation = startLocation else { return }

        travelTimes = Array(repeating: 0, count: destinations.count)
        isFetchingTravelTimes = true
        let group = DispatchGroup()

        for (index, destination) in destinations.enumerated() {
            guard let destinationMapItem = destination.mapItem else { continue }
            group.enter()

            estimateTravelTime(from: startLocation, to: destinationMapItem, mode: destination.transportationMode ?? .walk) { travelTime in
                travelTimes[index] = travelTime
                group.leave()
            }
        }

        group.notify(queue: .main) {
            isFetchingTravelTimes = false
        }
    }

    private func estimateTravelTime(from source: MKMapItem, to destination: MKMapItem, mode: TransportationMode, completion: @escaping (TimeInterval) -> Void) {
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination

        switch mode {
        case .walk:
            request.transportType = .walking
        case .bike:
            request.transportType = .walking
        case .car:
            request.transportType = .automobile
        default:
            completion(0)
            return
        }

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("Error calculating directions: \(error.localizedDescription)")
                completion(0)
                return
            }

            guard let route = response?.routes.first else {
                print("No route found.")
                completion(0)
                return
            }

            let expectedTravelTime = route.expectedTravelTime
            completion(mode == .bike ? expectedTravelTime / 3 : expectedTravelTime)
        }
    }

    private func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let radius = 6371.0
        let lat1Rad = lat1 * .pi / 180
        let lat2Rad = lat2 * .pi / 180
        let deltaLonRad = (lon2 - lon1) * .pi / 180

        return acos(sin(lat1Rad) * sin(lat2Rad) + cos(lat1Rad) * cos(lat2Rad) * cos(deltaLonRad)) * radius
    }

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
