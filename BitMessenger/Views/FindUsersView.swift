//
//  FindUsersView.swift
//  BitMessenger
//
//  Created by Kushagra Singh on 8/26/20.
//

import SwiftUI
import FirebaseFirestore
import Foundation

struct FindUsersView: View {
    @State var searched = "sRFYiRP"
    @Environment(\.colorScheme) var colorScheme
    @State var books = [ActivityCard]()
    private var db = Firestore.firestore()
    
    func fetchData(searchedField: String) {
        db.collection("UserData").whereField("customID", isEqualTo: searchedField).addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }

        self.books = documents.map { queryDocumentSnapshot -> ActivityCard in
          let data = queryDocumentSnapshot.data()
          let id = data["userUID"] as? String ?? ""
          let fullName = data["fullName"] as? String ?? ""
          let userName = data["userName"] as? String ?? ""
          let customID = data["customID"] as? String ?? ""

          return ActivityCard(id: id, fullName: fullName, userName: userName, customID: customID)
        }
      }
    }
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Text("Find Users")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 15.0)
                HStack {
                    Spacer()
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(colorScheme == .dark ? Color(red: 35/255.0, green: 35/255.0, blue: 35/255.0, opacity: 1.0):Color(red: 220/255.0, green: 220/255.0, blue: 220/255.0, opacity: 1.0) )
                        TextField(" UserName", text: $searched).padding(.horizontal, 5.0).textFieldStyle(PlainTextFieldStyle())
                    }.frame(width: geometry.size.width*0.8, height: geometry.size.height*0.07)
                    Spacer()
                }
                .padding(.top)
                
                List(books){ book in
                    HStack {
                        Spacer()
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(colorScheme == .dark ? Color(red: 30/255.0, green: 30/255.0, blue: 30/255.0, opacity: 1.0):Color(red: 235/255.0, green: 235/255.0, blue: 235/255.0, opacity: 1.0) )
                            HStack {
                                Text(book.userName)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text(book.customID)
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
                }.onAppear() { // (3)
                    self.fetchData(searchedField: searched)
                  }
                Spacer()
            }
        }
    }
}

struct ActivityCard: Identifiable {
    var id: String
    var fullName:String
    var userName:String
    var customID:String
}

struct FindUsersView_Previews: PreviewProvider {
    static var previews: some View {
        FindUsersView()
    }
}
