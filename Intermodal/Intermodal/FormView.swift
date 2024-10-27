import SwiftUI
import MapKit

struct FormView: View {
    @State private var searchText: String = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var isSearching: Bool = false
    @State private var startLocation: MKMapItem?
    @State private var destinations: [Destination] = []
    @State private var showAlert: Bool = false
    @State private var isTakingTrain = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Fixed Header Section
                headerSection
                    .padding()
                
                // Main Content Area
                HStack(spacing: 0) {
                    // Left side: Locations
                    locationsSection
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // Right side: Search Results
                    if !searchResults.isEmpty {
                        searchResultsSection
                            .frame(width: UIScreen.main.bounds.width * 0.4)
                            .transition(.move(edge: .trailing))
                    }
                }
            }
            .background(Color(red: 38/255, green: 38/255, blue: 38/255))
            .navigationTitle("")  // Clear the default title
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Plan Your Route")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment:
                                .leading)  // Left align
                        .padding(.leading, 16)  // Add left padding
                        .padding(.top, 65)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                }
                
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Select a Location"),
                    message: Text("Please select a location before adding another destination."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            HStack {
                // Search Bar
                SearchBar(text: $searchText, onSearch: performSearch)
                    .frame(height: 40)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                // Train Toggle
                VStack(alignment: .leading) {
                    Text("Train?")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Picker("", selection: $isTakingTrain) {
                        Text("Yes").tag(true)
                        Text("No").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 100)
                }
            }
            
            if isSearching {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
    }
    
    // MARK: - Locations Section
    private var locationsSection: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    // Start Location Card
                    if let startLocation = startLocation {
                        LocationCard(
                            title: "Start Location",
                            location: startLocation,
                            onRemove: removeStartLocation
                        )
                    } else {
                        EmptyLocationCard(title: "Set Start Location")
                    }
                    
                    // Destinations
                    ForEach(destinations.indices, id: \.self) { index in
                        LocationCard(
                            title: "Destination \(index + 1)",
                            location: destinations[index].mapItem,
                            transportationMode: $destinations[index].transportationMode,
                            onRemove: { removeDestination(at: index) }
                        )
                    }
                }
                .padding()
            }
            
            // Fixed bottom actions
            actionButtonsSection
                .padding()
                .background(Color(red: 38/255, green: 38/255, blue: 38/255))
        }
    }
    
    // MARK: - Search Results Section
    private var searchResultsSection: some View {
        VStack {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(searchResults, id: \.self) { item in
                        SearchResultRow(item: item)
                            .onTapGesture { saveLocation(item) }
                    }
                }
                .padding(8)
            }
        }
        .background(Color.gray.opacity(0.1))
    }
    
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            Button(action: addDestination) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Destination")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            NavigationLink(
                destination: SummaryView(startLocation: startLocation, destinations: destinations)
            ) {
                HStack {
                    Image(systemName: "map.fill")
                    Text("Generate Route")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background((startLocation != nil && !destinations.isEmpty) ? Color.green : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(startLocation == nil || destinations.isEmpty)
        }
    }
    
    // Helper Methods (unchanged)
    private func addDestination() {
        if destinations.isEmpty || (destinations.last?.mapItem != nil) {
            destinations.append(Destination())
        } else {
            showAlert = true
        }
    }
    
    private func removeStartLocation() {
        startLocation = nil
    }
    
    private func removeDestination(at index: Int) {
        destinations.remove(at: index)
    }
    
    private func saveLocation(_ location: MKMapItem) {
        if startLocation == nil {
            startLocation = location
        } else if let index = destinations.firstIndex(where: { $0.mapItem == nil }) {
            destinations[index].mapItem = location
        }
        searchText = ""
        searchResults = []
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
}

// Supporting Views (LocationCard, EmptyLocationCard, SearchResultRow, SearchBar remain unchanged)

// MARK: - Supporting Views
struct LocationCard: View {
    let title: String
    let location: MKMapItem?
    var transportationMode: Binding<TransportationMode?>? = nil
    let onRemove: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
            
            if let location = location {
                Text(location.name ?? "Unknown Location")
                    .foregroundColor(.white.opacity(0.8))
            }
            
            if let transportationMode = transportationMode {
                Picker("Transportation", selection: transportationMode) {
                    ForEach(TransportationMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue.capitalized).tag(mode as TransportationMode?)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct EmptyLocationCard: View {
    let title: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct SearchResultRow: View {
    let item: MKMapItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name ?? "Unknown Location")
                    .font(.headline)
                    .foregroundColor(.white)
                
                if let address = item.placemark.thoroughfare {
                    Text(address)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
        .background(Color.gray.opacity(0.3))
        .cornerRadius(8)
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
        searchBar.barTintColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1) // Dark gray color
        searchBar.searchTextField.backgroundColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1) // Text field background color
        searchBar.searchTextField.textColor = UIColor.white // Text color
        
        // Change the color of the search icon
        if let searchIcon = searchBar.searchTextField.leftView as? UIImageView {
            searchIcon.image = searchIcon.image?.withRenderingMode(.alwaysTemplate)
            searchIcon.tintColor = UIColor.black // Set your desired color here
        }
        
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
