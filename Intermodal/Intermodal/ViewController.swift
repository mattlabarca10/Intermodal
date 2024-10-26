import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController {

    var mapView: MKMapView!
    var stops: [(id: Int, name: String, latitude: Double, longitude: Double)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        loadStopsData()
        displayRouteBetweenStops(startID: 95001, endID: 95003)  // Adjust these IDs to display different routes
    }

    private func setupMapView() {
        mapView = MKMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
    }
    private func loadStopsData() {
        // Example of file parsing
        if let filePath = Bundle.main.path(forResource: "stops", ofType: "txt"),
           let fileContent = try? String(contentsOfFile: filePath) {
            let lines = fileContent.split(separator: "\n")
            for line in lines {
                let components = line.split(separator: ",")
                if components.count >= 6, let id = Int(components[1]),
                   let latitude = Double(components[4]), let longitude = Double(components[5]) {
                    let name = components[2].replacingOccurrences(of: "\"", with: "")
                    stops.append((id: id, name: name, latitude: latitude, longitude: longitude))
                }
            }
        }
    }
    private func displayRouteBetweenStops(startID: Int, endID: Int) {
        // Find the coordinates for the start and end stops
        guard let startStop = stops.first(where: { $0.id == startID }),
              let endStop = stops.first(where: { $0.id == endID }) else {
            print("Start or end stop not found.")
            return
        }
        let startCoordinate = CLLocationCoordinate2D(latitude: startStop.latitude, longitude: startStop.longitude)
        let endCoordinate = CLLocationCoordinate2D(latitude: endStop.latitude, longitude: endStop.longitude)
        // Add annotations for start and end points
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = startCoordinate
        startAnnotation.title = startStop.name
        mapView.addAnnotation(startAnnotation)
        let endAnnotation = MKPointAnnotation()
        endAnnotation.coordinate = endCoordinate
        endAnnotation.title = endStop.name
        mapView.addAnnotation(endAnnotation)
        // Create and add polyline to map
        let coordinates = [startCoordinate, endCoordinate]
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        // Set map region to display both points
        let region = MKCoordinateRegion(center: startCoordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
        mapView.setRegion(region, animated: true)
    }
}
extension ViewController: MKMapViewDelegate {
    // Render the polyline on the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer()
    }
}
#Preview
{
    ViewController()
}
