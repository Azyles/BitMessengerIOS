//
//  BitMessengerApp.swift
//  BitMessenger
//
//  Created by Kushagra Singh on 7/30/20.
//

import SwiftUI
import Firebase

@main
struct BitMessengerApp: App{
    init() {
        FirebaseApp.configure()
    }
    @SceneBuilder var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(SessionStore())
        }
    }
}
