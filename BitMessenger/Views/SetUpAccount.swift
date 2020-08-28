//
//  SetUpAccount.swift
//  BitMessenger
//
//  Created by Kushagra Singh on 8/26/20.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SetUpAccount: View {
    
    @State private var shouldTransit: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @State var userName = ""
    @State var fullName = ""
    @State private var showingAlert = false
    func randomString(length: Int) -> String {
        let letters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    func setupAccountData(){
        self.showingAlert = true
        var uniqueuserid = randomString(length:7)
        // User Data
        
        let postDictionaryUser: [String: Any] = [
            "userUID": user?.uid ?? "uid not found",
            "fullName": self.fullName,
            "userName": self.userName,
            "customID": uniqueuserid,
        ]
        
        let docRefUser = Firestore.firestore()
            .collection("UserData")
            .document(user?.uid ?? "UID not found")
        
        docRefUser.setData(postDictionaryUser, merge: true){ (error) in
            if let error = error {
                print("error = \(error)")
            } else {
                print("data updated successfully")
                self.fullName = ""
                self.userName = ""
            }
        }
        
    }
    let user = Auth.auth().currentUser
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(alignment: .center){
                    Text("Setup Account")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 15.0)
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(colorScheme == .dark ? Color(red: 35/255.0, green: 35/255.0, blue: 35/255.0, opacity: 1.0):Color(red: 220/255.0, green: 220/255.0, blue: 220/255.0, opacity: 1.0) )
                            TextField(" UserName", text: $userName).padding(.horizontal, 5.0).textFieldStyle(PlainTextFieldStyle())
                        }.frame(width: geometry.size.width*0.8, height: geometry.size.height*0.07)
                        Spacer()
                    }
                    .padding(.top)
                    HStack {
                        Spacer()
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(colorScheme == .dark ? Color(red: 35/255.0, green: 35/255.0, blue: 35/255.0, opacity: 1.0):Color(red: 220/255.0, green: 220/255.0, blue: 220/255.0, opacity: 1.0) )
                            TextField(" Full Name", text: $fullName).padding(.horizontal, 5.0).textFieldStyle(PlainTextFieldStyle())
                        }.frame(width: geometry.size.width*0.8, height: geometry.size.height*0.07)
                        Spacer()
                    }
                    .padding(.top, 5.0)
                    HStack {
                        Spacer()
                        NavigationLink(destination: UserDataExists()) {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.purple)
                                Text("Confirm")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                            }.frame(width: geometry.size.width*0.8, height: geometry.size.height*0.07)
                            .onTapGesture {
                                self.setupAccountData()
                        }
                        }
                        .navigationBarBackButtonHidden(true)
                        
                        Spacer()
                    }
                    .padding(.top, 5.0)
                    Spacer()
                }
            }
        }
    }
}

struct SetUpAccount_Previews: PreviewProvider {
    static var previews: some View {
        SetUpAccount()
    }
}
