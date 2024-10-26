import MapKit

// Structure to hold destination information
struct Destination {
    var mapItem: MKMapItem? = nil
    var transportationMode: TransportationMode? = nil
}

// Enum for transportation modes
enum TransportationMode: String, CaseIterable {
    case walk
    case bike
    case car
    case train
    case bus
}