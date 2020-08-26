//
//  HomeView.swift
//  BitMessenger
//
//  Created by Kushagra Singh on 7/30/20.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack{
            Text("Home")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 15.0)
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
