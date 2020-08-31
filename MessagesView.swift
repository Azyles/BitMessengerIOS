//
//  MessagesView.swift
//  BitMessenger
//
//  Created by Kushagra Singh on 8/26/20.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct MessagesView: View {
    @ObservedObject var messageGroup = MessagesViewModel()
    var body: some View {
        NavigationView {
            VStack{
                Text("Messages")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 15.0)
                List(messageGroup.chatgroup) { chat in
                    NavigationLink(destination: ChatMessageView(chat:chat)) {
                        Text(chat.groupName)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }.padding(.top, 5.0).onAppear() { // (3)
                    self.messageGroup.fetchChatData()
                }
                .listStyle(PlainListStyle())
                Spacer()
            }.navigationBarHidden(true)
        }
    }
}

struct MessageCard: Identifiable {
    var id:String
    var groupName:String
}

class MessagesViewModel: ObservableObject {
    let user = Auth.auth().currentUser
    @Published var chatgroup = [MessageCard]()
    
    private var db = Firestore.firestore()
    
    func fetchChatData() {
        db.collection("Group").whereField("members", arrayContains: user?.uid ?? "ERROR").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            print("Document Found")
            self.chatgroup = documents.map { queryDocumentSnapshot -> MessageCard in
                let data = queryDocumentSnapshot.data()
                let groupName = data["groupName"] as? String ?? ""
                let groupID = data["groupID"] as? String ?? ""
                return MessageCard(id: groupID, groupName: groupName)
            }
        }
    }
}


struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
