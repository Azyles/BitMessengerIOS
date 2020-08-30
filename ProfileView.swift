//
//  ProfileView.swift
//  BitMessenger
//
//  Created by Kushagra Singh on 8/26/20.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct ProfileView: View {
    @State var userNameField: String = "Error"
    @State var fullNameField: String = "Error"
    @State var customIDField: String = "Error"
    let user = Auth.auth().currentUser
    func name() -> String {
        let docRef = Firestore.firestore().collection("UserData").document(user?.uid ?? "")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Getting Field")
                self.userNameField = document.get("userName") as! String
            } else {
                print("Document Not Found ")
            }
        }
        return userNameField
    }
    func fullName() -> String {
        let docRef = Firestore.firestore().collection("UserData").document(user?.uid ?? "")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Getting Field")
                self.fullNameField = document.get("fullName") as! String
            } else {
                print("Document Not Found ")
            }
        }
        return fullNameField
    }
    func usercustomID() -> String {
        let docRef = Firestore.firestore().collection("UserData").document(user?.uid ?? "")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Getting Field")
                self.customIDField = document.get("customID") as! String
            } else {
                print("Document Not Found ")
            }
        }
        return customIDField
    }
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Text(name())
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 15.0)
                HStack {
                    Image("Clarkson")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width*0.35, height: geometry.size.width*0.35)
                        .clipShape(Circle())
                }
                .padding(.vertical, 15.0)

                HStack {
                    Spacer()
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(colorScheme == .dark ? Color(red: 30/255.0, green: 30/255.0, blue: 30/255.0, opacity: 1.0):Color(red: 235/255.0, green: 235/255.0, blue: 235/255.0, opacity: 1.0) )
                        HStack {
                            Text(fullName())
                                .font(.headline)
                                .fontWeight(.bold)
                            Text(usercustomID())
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        .padding(.leading, 15.0)
                    }.frame(width: geometry.size.width*0.8, height: geometry.size.height*0.08)
                    
                    Spacer()
                }
                .padding(.top, 15.0)
                
                NavigationLink(destination: FindUsersView()) {
                    
                    HStack {
                        Spacer()
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(colorScheme == .dark ? Color(red: 30/255.0, green: 30/255.0, blue: 30/255.0, opacity: 1.0):Color(red: 235/255.0, green: 235/255.0, blue: 235/255.0, opacity: 1.0) )
                            HStack {
                                Text("Friends")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.leading, 15.0)
                        }.frame(width: geometry.size.width*0.8, height: geometry.size.height*0.08)
                        
                        Spacer()
                    }
                    .padding(5.0)
                }
                Spacer()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
