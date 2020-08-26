//
//  ContentView.swift
//  BitMessenger
//
//  Created by Kushagra Singh on 7/30/20.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct ContentView: View {
    
    @EnvironmentObject var session: SessionStore
    
    func getUser() {
        session.listen()
    }
    
    var body: some View {
        Group {
            if (session.session != nil) {
                UserDataExists()
            } else {
                AuthView()
            }
        }.onAppear(perform: getUser)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SessionStore()) .environment(\.colorScheme, .dark)
    }
}
