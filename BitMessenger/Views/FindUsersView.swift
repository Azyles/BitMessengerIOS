//
//  FindUsersView.swift
//  BitMessenger
//
//  Created by Kushagra Singh on 8/26/20.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Foundation

struct FindUsersView: View {
    let user = Auth.auth().currentUser
    @State private var showingAlert = false
    @ObservedObject var viewModel = BooksViewModel()
    @Environment(\.colorScheme) var colorScheme
    private var db = Firestore.firestore()
    func addToGroup(othermemberid: String){
        self.showingAlert = true
        var randomID = UUID()
        let postDictionaryUser: [String: Any] = [
            "groupName": "Private Group",
            "groupID": "\(randomID)",
            "members": [user?.uid, othermemberid],
        ]
        
        let docRefUser = Firestore.firestore()
            .collection("Group")
            .document("\(randomID)")
        
        docRefUser.setData(postDictionaryUser, merge: true){ (error) in
            if let error = error {
                print("error = \(error)")
            } else {
                print("Joined Group")
            }
        }
        
    }
    var body: some View {
            VStack{
                HStack {
                    Spacer()
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(colorScheme == .dark ? Color(red: 35/255.0, green: 35/255.0, blue: 35/255.0, opacity: 1.0):Color(red: 220/255.0, green: 220/255.0, blue: 220/255.0, opacity: 1.0) )
                        TextField(" UserName", text: $viewModel.searchText).padding(.horizontal, 13.0).textFieldStyle(PlainTextFieldStyle())
                    }.frame(height: 50)
                    
                    .padding(.horizontal, 25.0)
                    Spacer()
                }
                .padding(.top)
                
                List(viewModel.books){ book in
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
                        }
                        .padding(.horizontal, 25.0)
                        .frame(height: 62)
                        
                        .onTapGesture(count: 1) {
                            addToGroup(othermemberid: book.id)
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(
                                title: Text("Say Hi!"),
                                message: Text("... has been added to your message list"),
                                dismissButton: .default(Text("Confirm"))
                            )
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 15.0)
                }.onAppear() { // (3)
                    self.viewModel.fetchData()
                }
                .listStyle(PlainListStyle())
                Spacer()
            }.navigationBarTitle(Text("Find Users"),displayMode: .inline)
    }
}


struct ActivityCard: Identifiable {
    var id: String
    var fullName:String
    var userName:String
    var customID:String
}

class BooksViewModel: ObservableObject {
    @Published var books = [ActivityCard]()
    @Published var searchText: String = "" {
        didSet {
            fetchData()
        }
    }
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("UserData").whereField("customID", isEqualTo: searchText).addSnapshotListener { (querySnapshot, error) in
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
}

struct FindUsersView_Previews: PreviewProvider {
    static var previews: some View {
        FindUsersView()
    }
}
