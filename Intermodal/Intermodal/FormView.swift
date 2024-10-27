import SwiftUI
import MapKit



struct FormView: View {
    @State private var searchText: String = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var isSearching: Bool = false
    @State private var startLocation: MKMapItem?
    @State private var destinations: [Destination] = [] // Holds destination details
    @State private var showAlert: Bool = false // To show alert when trying to add destination without selection
    @State private var isTakingTrain: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 38/255, green: 38/255, blue: 38/255)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 20) {
                    // Search Bar for Locations
                    HStack{
                        SearchBar(text: $searchText,isTakingTrain: $isTakingTrain, onSearch: performSearch)
                            .frame(width: 200)
                            .padding()
                        
                    Text("Train?")
                    .font(.headline)
                                   
                        Picker(selection: $isTakingTrain, label: Text("Mode")) {
                        Text("Yes").tag(true)
                        Text("No").tag(false)
                        }
                        .pickerStyle(DefaultPickerStyle())
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.top,10)
                        .padding(.leading,-5)
                               }
                    
                    
                
                    
                    // Display selected Start Location
                    if let startLocation = startLocation {
                        HStack {
                            Text("Start Location: \(startLocation.name ?? "Unknown")")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            
                            Button(action: { removeStartLocation() }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    // Dynamic Destination Inputs
                    ForEach(destinations.indices, id: \.self) { index in
                        HStack {
                            locationInputView(
                                title: "Destination \(index + 1)",
                                location: $destinations[index].mapItem,
                                transportationMode: $destinations[index].transportationMode
                            )
                            Button(action: { removeDestination(at: index) }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    // Add Destination Button
                    Button(action: addDestination) {
                        Text("Add Destination")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    
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
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Select a Destination"), message: Text("Please select a location for the destination before adding."), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
    
    
    private func locationInputView(title: String, location: Binding<MKMapItem?>, transportationMode: Binding<TransportationMode?>? = nil) -> some View {
        VStack {
            HStack {
                Text(title)
                    .font(.headline)
                
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
            .padding()
        }
    }
    
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
    @Binding var isTakingTrain: Bool
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
        
        if isTakingTrain {
            
        } else {
            searchBar.barTintColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1) // Custom color for "Not Taking Train"
            searchBar.searchTextField.backgroundColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)
            searchBar.searchTextField.textColor = UIColor.black
        }
        
        if let searchIcon = searchBar.searchTextField.leftView as? UIImageView {
            searchIcon.image = searchIcon.image?.withRenderingMode(.alwaysTemplate)
            searchIcon.tintColor = isTakingTrain ? UIColor.white : UIColor.black
        }
        
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
        uiView.barTintColor = isTakingTrain ? UIColor(red: 0/255, green: 100/255, blue: 200/255, alpha: 1) : UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        uiView.searchTextField.backgroundColor = isTakingTrain ? UIColor(red: 0/255, green: 50/255, blue: 150/255, alpha: 1) : UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)
        
        if let searchIcon = uiView.searchTextField.leftView as? UIImageView {
            searchIcon.tintColor = isTakingTrain ? UIColor.white : UIColor.black
        }
    }
}

// Preview for FormView
struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
