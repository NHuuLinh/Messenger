//
//  NewMessengetViewController.swift
//  Messenger
//
//  Created by LinhMAC on 18/02/2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class NewMessengetViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var newMessengerTableView: UITableView!
    let ref = Database.database().reference()
    private var databaseRef = Database.database().reference()
    var searchResult = [String]()
    var searchResult1 = [String:String]()
    var userData = [User]()
    var searchTimer: Timer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        registerCell()

    }
    func registerCell(){
        newMessengerTableView.dataSource = self
        newMessengerTableView.delegate = self
        let cell = UINib(nibName: "NewMessengetTableViewCell", bundle: nil)
        newMessengerTableView.register(cell, forCellReuseIdentifier: "NewMessengetTableViewCell")
    }

    func searchUser(withEmail email: String) {
        userData.removeAll()
//        searchResult1.removeAll()

        ref.child("users").queryOrdered(byChild: "email").observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                print("loading")
                for child in snapshot.children {
                    let childSnapshot = child as! DataSnapshot
                    let user = childSnapshot.value as! [String: Any]
                    if let userEmail = user["email"] as? String, userEmail.contains(email) {
                        guard let userID = user["id"] as? String else {
                            return
                        }
                        print("User with email containing 'linhlinh' has ID: \(userID)")
                        print("User found with id: \(userEmail)")
                        self.searchResult1[userEmail] = userEmail
                        self.loadDataFromFirebase(id: userID)
//                        self.newMessengerTableView.reloadData()

                    } else {
                        print("cast fail")
                    }
                }
                print("done loading")

            } else {
                print("No users found with the email containing: \(email)")
            }
        }
        print("searchResult: \(searchResult1)")
    }
    func loadDataFromFirebase(id: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }
        let userRef = Database.database().reference().child("users").child(id)
        userRef.observeSingleEvent(of: .value) { snapshot,arg  in
            
            if let userData1 = snapshot.value as? [String: Any] {
                let name = userData1["name"] as? String
                let email = userData1["email"] as? String
                let phoneNumber = userData1["phoneNumber"] as? String
                let user = User(avatar: nil, email: email, id: id, name: name, phoneNumber: phoneNumber)
                self.userData.append(user)
                self.newMessengerTableView.reloadData()

                print("name:\(name)")
                print("email:\(email)")
                print("phoneNumber:\(phoneNumber)")
                print("userData?.name:\(self.userData)")

            }
        }

    }

    @IBAction func backBtn(_ sender: Any) {
//        userData.removeAll()
        guard let email = searchBar.text?.lowercased() else {
            return
        }
        searchUser(withEmail: email)

    }
}
extension NewMessengetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("userData.count:\(userData.count)")
        return userData.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewMessengetTableViewCell", for: indexPath) as! NewMessengetTableViewCell
        let data = userData[indexPath.row]
            cell.blinData(data: data)
        return cell
    }
    
}


extension NewMessengetViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            guard let lowercase = searchBar.text?.lowercased() else {
                return
            }
            self.searchUser(withEmail: lowercase)
            print("\(lowercase)")
        }
    }
}
