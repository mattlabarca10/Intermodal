import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var startLocation: MKMapItem?
    var destinations: [Destination]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Clear existing overlays before recalculating routes
        uiView.removeOverlays(uiView.overlays)

        // Calculate and display routes
        calculateRoutes(on: uiView)
    }

    private func calculateRoutes(on mapView: MKMapView) {
        guard let start = startLocation else {
            print("Start location is missing.")
            return
        }

        var destinationItems: [MKMapItem] = destinations.compactMap { $0.mapItem }

        guard !destinationItems.isEmpty else {
            print("No destinations to route.")
            return
        }

        // Calculate route from the start location to the first destination
        calculateRoute(from: start, to: destinationItems[0], on: mapView) { _ in
            for index in 1..<destinationItems.count {
                let previousDestination = destinationItems[index - 1]
                let nextDestination = destinationItems[index]

                // Calculate route from previous to next destination
                calculateRoute(from: previousDestination, to: nextDestination, on: mapView, completion: { _ in })
            }
        }
    }

    private func calculateRoute(from source: MKMapItem, to destination: MKMapItem, on mapView: MKMapView, completion: @escaping (MKRoute) -> Void) {
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination

        if let firstDestination = destinations.first, let mode = firstDestination.transportationMode {
            switch mode {
            case .walk:
                request.transportType = .walking
            case .bike:
                request.transportType = .walking // MKMapKit does not support bicycle directly
            case .car:
                request.transportType = .automobile
            case .train, .bus:
                request.transportType = .transit
            }
        } else {
            request.transportType = .automobile // Default to automobile if not set
        }

        let directions = MKDirections(request: request)

        directions.calculate { response, error in
            if let error = error {
                print("Error calculating directions: \(error.localizedDescription)")
                return
            }

            guard let route = response?.routes.first else {
                print("No route found.")
                return
            }

            let randomColor = UIColor.random()
            mapView.addOverlay(route.polyline, level: .aboveRoads)

            let routeRect = route.polyline.boundingMapRect
            let paddedRect = mapView.mapRectThatFits(routeRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
            mapView.setVisibleMapRect(paddedRect, animated: true)

            // Call the completion handler
            completion(route)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor.random()
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

// UIColor extension to generate random colors
extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}


// Preview for MapView
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(startLocation: nil, destinations: [])
    }
}
