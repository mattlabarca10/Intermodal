//
//  FormView.swift
//  Intermodal
//
//  Created by Matthew LaBarca on 10/26/24.
// MKMapItemIdentifier / Place.id

import SwiftUI
import MapKit

struct FormView: View {
    @State private var searchText: String = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var isSearching: Bool = false

    @State private var startLocation: MKMapItem?
    @State private var destinationLocation: MKMapItem?
    @State private var selectingStartLocation = true

    var body: some View {
        NavigationView {
            VStack {
                // Toggle between setting Start and Destination
                HStack {
                    Button(action: { selectingStartLocation = true }) {
                        Text("Set Start Location")
                            .padding()
                            .background(selectingStartLocation ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    Button(action: { selectingStartLocation = false }) {
                        Text("Set Destination")
                            .padding()
                            .background(!selectingStartLocation ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.bottom)

                // Display selected start and destination
                if let start = startLocation {
                    Text("Start: \(start.name ?? "Unknown Location")")
                        .font(.subheadline)
                        .padding(.bottom, 2)
                }
                if let destination = destinationLocation {
                    Text("Destination: \(destination.name ?? "Unknown Location")")
                        .font(.subheadline)
                        .padding(.bottom, 2)
                }

                // Search bar for entering location text
                SearchBar(text: $searchText, onSearch: performSearch)
                    .padding()

                // Display progress while searching
                if isSearching {
                    ProgressView("Searching...")
                        .padding()
                }

                // List of search results
                List(searchResults, id: \.self) { item in
                    VStack(alignment: .leading) {
                        Text(item.name ?? "Unknown Location")
                            .font(.headline)
                        Text("\(item.placemark.coordinate.latitude), \(item.placemark.coordinate.longitude)")
                            .font(.subheadline)
                    }
                    .onTapGesture {
                        saveLocation(item)
                    }
                }

                // Submit Button for Navigation
                NavigationLink(destination: MapView(startLocation: startLocation, destinationLocation: destinationLocation)) {
                    Text("Submit")
                        .padding()
                        .background((startLocation != nil && destinationLocation != nil) ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(startLocation == nil || destinationLocation == nil)
                .padding()
            }
            .navigationTitle("Location Search")
            .onChange(of: searchText) { newValue in
                performSearch()
            }
        }
    }

    // Search function
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

    // Save location based on the selected type (start or destination)
    private func saveLocation(_ location: MKMapItem) {
        if selectingStartLocation {
            startLocation = location
            print("Start location set to: \(location.name ?? "Unknown")")
        } else {
            destinationLocation = location
            print("Destination set to: \(location.name ?? "Unknown")")
        }
        searchText = ""
        searchResults = []
    }
}

// Custom SearchBar component to allow location text input and search triggering
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
