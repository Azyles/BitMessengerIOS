//
//  NavigationView.swift
//  BitMessenger
//
//  Created by Kushagra Singh on 8/26/20.
//

import SwiftUI

struct NavView: View {
    @State var selectedView = 1
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }.tag(0)
            
            FindUsersView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Messages")
                }.tag(1)
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }.tag(2)
            
        }.accentColor(.orange)
    }
}

struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        NavView()
    }
}
