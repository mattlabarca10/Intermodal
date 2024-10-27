import Foundation

class StopsManager {
    static let shared = StopsManager()
    private var stations: [String] = []

    private init() {
        loadStations()
    }

    func loadStations() {
        // Load stations from stops.txt
        if let url = Bundle.main.url(forResource: "stops", withExtension: "txt") {
            do {
                let data = try String(contentsOf: url)
                stations = data.components(separatedBy: .newlines).compactMap { line in
                    let components = line.components(separatedBy: ",") // Change the delimiter as needed
                    guard components.count > 2 else { return nil }
                    let station = components[2]
                    return station.trimmingCharacters(in: CharacterSet(charactersIn: "\"")) // Remove quotes
                }
            } catch {
                print("Error loading stops: \(error)")
            }
        }
    }

    func getStations() -> [String] {
        return stations
    }
}
