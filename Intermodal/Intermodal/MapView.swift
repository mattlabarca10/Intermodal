// MapView.swift
// Intermodal
// Created by Matthew LaBarca on 10/26/24.

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var startLocation: MKMapItem?
    var destinationLocation: MKMapItem?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        calculateRoute(on: mapView)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    func calculateRoute(on mapView: MKMapView) {
        guard let start = startLocation, let destination = destinationLocation else {
            print("Start or destination location is missing.")
            return
        }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start.placemark.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination.placemark.coordinate))
        request.transportType = .automobile

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

            mapView.addOverlay(route.polyline)

            // Set visible map rect with padding to zoom out a bit
            let routeRect = route.polyline.boundingMapRect
            let paddedRect = mapView.mapRectThatFits(routeRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
            mapView.setVisibleMapRect(paddedRect, animated: true)
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
                renderer.strokeColor = .blue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

#Preview {
    MapView()
}


/*

 */
