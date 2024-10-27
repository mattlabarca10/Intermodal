import SwiftUI
import MapKit

struct FormView: View {
    @State private var searchText: String = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var isSearching: Bool = false
    @State private var isDestinationSelected: Bool = false
    @State private var startLocation: MKMapItem?
    @State private var destinations: [Destination] = [] // Holds destination details

    var body: some View {
        NavigationView {
            VStack {
                // Start Location
                locationInputView(title: "Start Location", location: $startLocation, isStart: true)

                // Dynamic Destination Inputs
                ForEach(destinations.indices, id: \.self) { index in
                    let title = index == 0 ? "Starting Location" : "Destination \(index)"
                    locationInputView(title: title, location: $destinations[index].mapItem, transportationMode: $destinations[index].transportationMode)
                }

                // Add Destination Button
                HStack{
                    Button(action: addDestination){
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                    .frame(width: 25,height: 25)
                    .background(.blue)
                    .cornerRadius(40)
                    Text("Add destination")
                    Spacer()
                } .padding(.leading,30)

                

                // Navigation Link to SummaryView
                NavigationLink(destination: SummaryView(startLocation: startLocation, destinations: destinations)) {
                    Text("Generate Route")
                        .padding()
                        .background((startLocation != nil && !destinations.isEmpty) ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(startLocation == nil || destinations.isEmpty)

                // List of search results
                List(searchResults, id: \.self) { item in
                    VStack(alignment: .leading) {
                        Text(item.name ?? "Unknown Location")
                            .font(.headline)
                        Text("\(item.placemark.coordinate.latitude), \(item.placemark.coordinate.longitude)")
                            .font(.subheadline)
                    }
                    .onTapGesture {
                        saveLocation(item) // Save selected location
                    }
                }

                // Display progress while searching
                if isSearching {
                    ProgressView("Searching...")
                        .padding()
                }
            }
            .navigationTitle("Location Search")
            
            .onChange(of: searchText) { newValue in
                performSearch()
            }
        }
    }

    private func locationInputView(title: String, location: Binding<MKMapItem?>, isStart: Bool = false, transportationMode: Binding<TransportationMode?>? = nil) -> some View {
        HStack {
            Text(title)
                .font(.headline)

            // Search Bar
            SearchBar(text: $searchText, onSearch: performSearch)
                .frame(width: 200)

            if let selectedLocation = location.wrappedValue {
                // Display selected location in the search bar
                Text(selectedLocation.name ?? "Unknown Location")
                    .foregroundColor(.gray)
            }

            // Dropdown for Transportation Mode for destinations
            if transportationMode != nil {
                Picker("Mode", selection: transportationMode!) {
                    ForEach(TransportationMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue.capitalized).tag(mode as TransportationMode?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 100)
            }
        }
    }

    private func addDestination() {
        destinations.append(Destination())
    }

    private func performSearch() {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }

        isSearching = true
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            isSearching = false
            if let error = error {
                print("Error searching for locations: \(error.localizedDescription)")
                return
            }

            guard let mapItems = response?.mapItems else {
                print("No results found.")
                return
            }

            DispatchQueue.main.async {
                self.searchResults = mapItems
            }
        }
    }

    private func saveLocation(_ location: MKMapItem) {
        if startLocation == nil {
            startLocation = location
            print("Start location set to: \(location.name ?? "Unknown")")
            searchText = "" // Clear search text after selecting
        } else if let index = destinations.firstIndex(where: { $0.mapItem == nil }) {
            destinations[index].mapItem = location
            print("Destination \(index + 1) set to: \(location.name ?? "Unknown")")
            searchText = "" // Clear search text after selecting
        }
        searchResults = [] // Clear search results after selection
    }
}

// Custom SearchBar component
struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var onSearch: () -> Void

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        var onSearch: () -> Void

        init(text: Binding<String>, onSearch: @escaping () -> Void) {
            _text = text
            self.onSearch = onSearch
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            onSearch()
            searchBar.resignFirstResponder()
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.text = searchText
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, onSearch: onSearch)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}

// Preview for FormView
struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
