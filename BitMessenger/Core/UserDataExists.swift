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
    @State var accountStatus: Bool = true
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    func confirm() -> Bool {
        let docRef = db.collection("UserData").document(user?.uid ?? "None")
     
        docRef.getDocument { (document, error) in
            if let document = document {
                if document.exists{
                    print("True")
                    self.accountStatus = true
                } else {
                    print("False")
                    self.accountStatus = false
                }
            }
        }
        return accountStatus
    }
    var body: some View {
        Group {
            if (confirm() == true) {
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
