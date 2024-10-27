//
//  IntermodalApp.swift
//  Intermodal
//
//  Created by Matthew LaBarca on 10/26/24.
//

import SwiftUI
import Firebase

@main
struct YourAppNameApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            WelcomeView() // Starting view
        }
    }
}
