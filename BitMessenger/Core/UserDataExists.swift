//
//  UserDataExists.swift
//  BitMessenger
//
//  Created by Kushagra Singh on 8/26/20.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct UserDataExists: View {
    
       let user = Auth.auth().currentUser
       let db = Firestore.firestore()
       
       @State var session: Bool = false
       
       func confrim() -> Bool {
           
           let docRef = db.collection("UserData").document(user?.uid ?? "None")
           
           docRef.getDocument { (document, error) in
               if let document = document {
                   if document.exists{
                       print("True")
                       self.session = true
                   } else {
                       print("False")
                       self.session = false
                   }
               }
           }
           return session
       }
       
       var body: some View {
           Group {
               if (confrim() == true) {
                   NavView()
               } else {
                   SetUpAccount()
               }
           }
       }
   }


struct UserDataExists_Previews: PreviewProvider {
    static var previews: some View {
        UserDataExists()
    }
}
