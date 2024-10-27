import SwiftUI
import MapKit

struct TripCompleteView: View {
    var startLocation: MKMapItem?
    var destinations: [Destination]

    @State private var totDistance: Double = 0.0 // Variable to store the total distance traveled
    @State private var carCarbon: Double = 0.0   // Car carbon emissions
    @State private var tranCarbon: Double = 0.0  // Transit carbon emissions

    var body: some View {
        ZStack {
            // Background color to match LoginView
            Color(red: 38/255, green: 38/255, blue: 38/255)
                .ignoresSafeArea() // Extend background color to the entire screen
            
            VStack(spacing: 20) {
                Text("Total Distance Traveled: \(String(format: "%.2f", totDistance)) km")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()

                Text("Car Carbon Emissions: \(String(format: "%.2f", carCarbon)) lbs CO₂")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Transit Carbon Emissions: \(String(format: "%.2f", tranCarbon)) lbs CO₂")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .onAppear(perform: calculateTotalDistance)
        }
    }
    
    // Function to calculate total distance and carbon emissions
    private func calculateTotalDistance() {
        guard let start = startLocation else { return }
        
        // Initialize starting coordinates
        var currentLat = start.placemark.coordinate.latitude
        var currentLon = start.placemark.coordinate.longitude
        totDistance = 0.0 // Reset total distance
        
        // Iterate through destinations to calculate distances
        for destination in destinations {
            guard let destinationCoord = destination.mapItem?.placemark.coordinate else { continue }
            
            let distance = calculateDistance(lat1: currentLat, lon1: currentLon,
                                             lat2: destinationCoord.latitude, lon2: destinationCoord.longitude)
            
            totDistance += distance // Add to total distance
            
            // Update current location to the current destination
            currentLat = destinationCoord.latitude
            currentLon = destinationCoord.longitude
        }
        
        // Calculate carbon emissions based on totDistance
        carCarbon = totDistance * 0.33
        tranCarbon = totDistance * 0.21
    }

    // Calculate distance between two coordinates
    private func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let radius = 6371.0 // Earth's radius in kilometers
        let lat1Rad = lat1 * .pi / 180
        let lat2Rad = lat2 * .pi / 180
        let deltaLonRad = (lon2 - lon1) * .pi / 180

        let distance = acos(sin(lat1Rad) * sin(lat2Rad) + cos(lat1Rad) * cos(lat2Rad) * cos(deltaLonRad)) * radius
        return distance
    }
}

// Preview for TripCompleteView
struct TripCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        TripCompleteView(startLocation: nil, destinations: [])
    }
}
