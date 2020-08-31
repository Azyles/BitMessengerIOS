//
//  ChatMessageView.swift
//  BitMessenger
//
//  Created by Kushagra Singh on 8/28/20.
//
/*
 
 var id:String
 var senderName:String
 var senderID:String
 var sentDate:String
 var content:String
 var reactions:String
 */


import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ChatMessageView: View {
    let user = Auth.auth().currentUser
    var chat: MessageCard
    @State var usermessage: String = ""
    @State var userNameField: String = "Name"
    @ObservedObject var texts = TextViewModel()
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
    func sendMessage(){
        let sendersName: String = name()
        print(sendersName)
        let postDictionaryUser: [String: Any] = [
            "id": "randomID",
            "senderName": "\(sendersName)",
            "senderID": user?.uid ?? "None",
            "sentDate": Timestamp(date: Date()),
            "content": usermessage,
            "reactions": "None",
        ]
        
        let docRefUser = Firestore.firestore()
            .collection("Group")
            .document("\(chat.id)")
            .collection("Messages")
            .document()
        
        docRefUser.setData(postDictionaryUser, merge: true){ (error) in
            if let error = error {
                print("error = \(error)")
            } else {
                print("data updated successfully")
                self.usermessage = ""
            }
        }
    }
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                VStack {
                    List(texts.text){ text in
                        if text.senderID == user?.uid{
                            HStack{
                                Spacer()
                                VStack(alignment: .leading){
                                    Group {
                                        Text(text.senderName)
                                            .fontWeight(.bold)
                                            .padding(.bottom, 5.0)
                                        Text(text.content)
                                    }
                                }.padding(.all)
                                .background(Color(red: 0.95, green: 0.3, blue: 0.25, opacity: 1))
                                .cornerRadius(10)
                                .frame(minWidth: geo.size.width*0.6, idealWidth:geo.size.width*0.6, maxWidth: geo.size.width*0.6,alignment: .trailing)
                                
                            }
                        }else{
                            HStack{
                                VStack(alignment: .leading){
                                    Group {
                                        Text(text.senderName)
                                            .fontWeight(.bold)
                                            .padding(.bottom, 5.0)
                                        Text(text.content)
                                    }
                                }.padding(.all)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                                .frame(minWidth: geo.size.width*0.6, idealWidth:geo.size.width*0.6, maxWidth: geo.size.width*0.6,alignment: .leading)
                                Spacer()
                            }
                        }
                    }.onAppear {
                        texts.fetchChatData(documentIID: chat.id)
                    }
                    .listStyle(PlainListStyle())
                    .padding(.bottom, 60.0)
                    Spacer()
                }
                VStack {
                    Spacer()
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(colorScheme == .dark ? Color(red: 35/255.0, green: 35/255.0, blue: 35/255.0, opacity: 1.0):Color(red: 220/255.0, green: 220/255.0, blue: 220/255.0, opacity: 1.0) )
                            .padding(.trailing, 76.0)
                        HStack {
                            TextField(" Message", text: $usermessage).padding(.horizontal, 13.0).textFieldStyle(PlainTextFieldStyle())
                            Button(action: sendMessage) {
                                ZStack{
                                    Circle().foregroundColor(.orange)
                                    Image(systemName: "plus")
                                }.frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding(.trailing, 13.0)
                            }
                        }
                    }.frame(height: 50)
                    .padding(.leading, 25.0)
                }
                .padding(.bottom)
            }
        }.navigationBarTitle(Text(chat.groupName),displayMode: .inline)
    }
}

struct TextCard: Identifiable {
    var id = UUID()
    var docid:String
    var senderName:String
    var senderID:String
    var sentDate:String
    var content:String
    var reactions:String
}


class TextViewModel: ObservableObject {
    
    let user = Auth.auth().currentUser
    @Published var text = [TextCard]()
    
    private var db = Firestore.firestore()
    
    func fetchChatData(documentIID: String) {
        db.collection("Group").document(documentIID).collection("Messages").order(by: "sentDate").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            print("Message Document Found")
            self.text = documents.map { queryDocumentSnapshot -> TextCard in
                let data = queryDocumentSnapshot.data()
                let docid = data["id"] as? String ?? ""
                let senderName = data["senderName"] as? String ?? ""
                let senderID = data["senderID"] as? String ?? ""
                let sentDate = data["sentDate"] as? String ?? ""
                let content = data["content"] as? String ?? ""
                let reactions = data["reactions"] as? String ?? ""
                return TextCard(id: .init(),docid: docid, senderName: senderName, senderID:senderID,sentDate:sentDate,content:content,reactions:reactions)
            }
        }
    }
}

/*
 let data = queryDocumentSnapshot.data()
 let id = data["id"] as? String ?? ""
 let senderName = data["senderName"] as? String ?? ""
 let senderID = data["senderID"] as? String ?? ""
 let sentDate = data["sentDate"] as? String ?? ""
 let content = data["content"] as? String ?? ""
 let reactions = data["reactions"] as? String ?? ""
 return TextCard(id: id, senderName: senderName, senderID:senderID,sentDate:sentDate,content:content,reactions:reactions)
 }
 */
