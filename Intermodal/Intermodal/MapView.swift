// MapView.swift
// Intermodal
// Created by Matthew LaBarca on 10/26/24.

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var startLocation: MKMapItem?
    var destinations: [Destination] // Updated to accept multiple destinations

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        calculateRoutes(on: mapView) // Calculate routes when the view is created
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // If the locations change, recalculate the route
        calculateRoutes(on: uiView)
    }

    func calculateRoutes(on mapView: MKMapView) {
        guard let start = startLocation else {
            print("Start location is missing.")
            return
        }

        // Create an array to hold the MKMapItem for destinations
        var destinationItems: [MKMapItem] = []

        // Collect all valid destination map items
        for destination in destinations {
            if let destinationMapItem = destination.mapItem {
                destinationItems.append(destinationMapItem)
            }
        }

        // Ensure there are destination items to process
        guard !destinationItems.isEmpty else {
            print("No destinations to route.")
            return
        }

        // Create a route from start to the first destination
        calculateRoute(from: start, to: destinationItems[0], on: mapView) { route in
            // Calculate the route from the first destination to subsequent destinations
            for index in 1..<destinationItems.count {
                let previousDestination = destinationItems[index - 1]
                let nextDestination = destinationItems[index]

                calculateRoute(from: previousDestination, to: nextDestination, on: mapView) { route in
                    // Further logic can be added here if needed
                }
            }
        }
    }

    private func calculateRoute(from source: MKMapItem, to destination: MKMapItem, on mapView: MKMapView, completion: @escaping (MKRoute) -> Void) {
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination

        // Set transport type based on the first destination's transportation mode
        if let firstDestination = destinations.first, let mode = firstDestination.transportationMode {
            switch mode {
            case .walk:
                request.transportType = .walking
            case .bike:
                request.transportType = .automobile // MKMapKit does not support bicycle directly
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

            // Add overlay for the route with a random color
            let randomColor = UIColor.random() // Get a random color
            mapView.addOverlay(route.polyline, level: .aboveRoads)

            // Set visible map rect with padding to zoom out a bit
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
                // Assign a random color to each polyline
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor.random() // Random color for the polyline
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
        MapView(
            startLocation: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))),
            destinations: [
                Destination(mapItem: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094))),
                            transportationMode: .car),
                Destination(mapItem: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7949, longitude: -122.3994))),
                            transportationMode: .car)
            ]
        )
    }
}
