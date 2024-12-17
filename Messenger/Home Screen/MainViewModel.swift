//
//  MainViewModel.swift
//  Messenger
//
//  Created by Huu Linh Nguyen on 12/12/24.
//

import Foundation
import KeychainSwift

import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

import FirebaseCore
import FirebaseFirestore


struct Book: Codable {
    var id: String
  var title: String
  var numberOfPages: Int
  var author: String
}

final class MainViewModel {
    private var databaseRef = Database.database().reference()
    let keychain = KeychainSwift()
    let isReachable = NetworkMonitor.shared.isReachable
    var totalFriendList = [Document]()
    let db = Firestore.firestore()

    func logoutHandle() {
        print("logout")

        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
//                UserDefaults.standard.didOnMain = false
            if firebaseAuth.currentUser == nil {
//                    if isReachable {
                        AppDelegate.scene?.goToLogin()
//                    } else {
//                    AppDelegate.scene?.routeToNoInternetAccess()
//                    }
            }  else {
                print("Error: User is still signed in")
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
//    func loadDataFromFirebase() {
//            let ref =   db.collection("chatHistory").document("chatHistory")
//        do {
//            self.totalFriendList = try await ref.getDocument(as: Document.self) { result,arg  in
//              // handle result
//            }
////            self.totalFriendList = data.
//        }
//    }
        private func fetchBook(documentId: String) {
          let docRef = db.collection("books").document(documentId)
          
          docRef.getDocument(as: Book.self) { result in
            switch result {
            case .success(let book):
              // A Book value was successfully initialized from the DocumentSnapshot.
              self.book = book
              self.errorMessage = nil
            case .failure(let error):
              // A Book value could not be initialized from the DocumentSnapshot.
              self.errorMessage = "Error decoding document: \(error.localizedDescription)"
            }
          }
    }
    func loadDataFromFirebase1() {
        let databaseRef = Database.database().reference()
        //self.registerVC.showLoading(isShow: true)
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        let userRef = databaseRef.child("users").child(currentUser)
        userRef.child("email").setValue(keychain.get("email"))
        userRef.child("id").setValue(currentUserID)
    }
    



    
}
