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
                // Assuming each line is formatted as "stop_code, stop_name"
                stations = data.components(separatedBy: .newlines).compactMap { line in
                    let components = line.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
                    // Return the stop_name (second field) without surrounding quotes
                    if components.count > 2 {
                        let stopName = String(components[2])
                        return String(stopName.dropFirst().dropLast()) // Remove the first and last character (quotes)
                    }
                    return nil
                }.filter { !$0.isEmpty }
            } catch {
                print("Error loading stops: \(error)")
            }
        }
    }


    func getStations() -> [String] {
        return stations
    }

    func isStation(_ name: String) -> Bool {
        return stations.contains(name)
    }
}
