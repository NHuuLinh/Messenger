//
//  MainViewController.swift
//  Messenger
//
//  Created by LinhMAC on 15/02/2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import KeychainSwift

class MainViewController: UIViewController {
    
    
    private var databaseRef = Database.database().reference()
    let isReachable = NetworkMonitor.shared.isReachable
    let keychain = KeychainSwift()



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }



    @IBAction func BackBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(identifier: "NewMessengetViewController") as? NewMessengetViewController {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    @IBAction func menuBtn(_ sender: Any) {
        loadDataFromFirebase()
//        logoutHandle()
    }
    func logoutHandle() {
        print("logout")

        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
//                UserDefaults.standard.didOnMain = false

            if firebaseAuth.currentUser == nil {
//                    if isReachable {
//                        AppDelegate.scene?.goToLogin()
//                    } else {
                    AppDelegate.scene?.routeToNoInternetAccess()
//                    }
            }  else {
                print("Error: User is still signed in")
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    func loadDataFromFirebase() {
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
// MARK: - Các hàm xử lí liên quan đến kết nối internet
extension MainViewController {
    // Khi có thay đổi trạng thái mạng, bạn có thể gọi hàm này để cập nhật UIView
    func handleNetworkStatusChange(isReachable: Bool) {
        // Xử lý sự thay đổi trạng thái mạng tại đây
        updateInternetView()
    }
    func updateInternetView() {
        print("updateInternetView")

        if NetworkMonitor.shared.isReachable {
            DispatchQueue.main.async {
                print("internet")
//                self.noInternetView.isHidden = true
//                self.noInternetViewConstraints.constant = -25
            }
        } else {
            DispatchQueue.main.async {
                print("no internet")

//                self.noInternetView.isHidden = false
//                self.noInternetViewConstraints.constant = 0
            }
        }
    }
}
