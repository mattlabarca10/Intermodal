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

    // Computed property to generate trip summary
    private var tripSummary: String {
        guard let start = startLocation else { return "No starting location." }

        var summary = "Starting at \(start.name ?? "Unknown")\n"
        var totalDuration: TimeInterval = 0

        for destination in destinations {
            guard let destinationMapItem = destination.mapItem else { continue }
            let travelTime: TimeInterval = estimateTravelTime(for: destination)
            totalDuration += travelTime

            let mode = destination.transportationMode?.rawValue.capitalized ?? "Unknown mode"
            summary += "\(mode.capitalized) to \(destinationMapItem.name ?? "Unknown"): \(formatTime(travelTime))\n"
        }

        summary += "Total Trip Time: \(formatTime(totalDuration))"
        return summary
    }

    // Mock travel time estimation method
    private func estimateTravelTime(for destination: Destination) -> TimeInterval {
        switch destination.transportationMode {
        case .walk:
            return 30 * 60 // 30 minutes
        case .bike:
            return 15 * 60 // 15 minutes
        case .car:
            return 80 * 60 // 1 hour 20 minutes
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
