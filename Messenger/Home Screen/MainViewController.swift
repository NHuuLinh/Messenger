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
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var messageCollectionView: UICollectionView!
    typealias DataSource = UICollectionViewDiffableDataSource<MenuSection, MenuItem>
    typealias SnapShot = NSDiffableDataSourceSnapshot<MenuSection, MenuItem>
    
    private var databaseRef = Database.database().reference()
    let isReachable = NetworkMonitor.shared.isReachable
    let keychain = KeychainSwift()
    var isHideMenu = true
    let chidleView = MenuViewcontroller()
    private lazy var dataSource = makeDataSource()
    let item = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuView.isHidden = true
        loadDataFromFirebase()
        subViewHandle()
        // Do any additional setup after loading the view.
    }
    override func viewIsAppearing(_ animated: Bool) {
        subViewHandle()
    }

    func subViewHandle(){
        chidleView.view.frame = sideMenuView.bounds
        addChild(chidleView)
        sideMenuView.addSubview(chidleView.view)
        chidleView.didMove(toParent: self)
        chidleView.pressMenuBtn = {[weak self] in
            self?.sideMenuView.isHidden = true
        }
    }
    @IBAction func BackBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(identifier: "NewMessengetViewController") as? NewMessengetViewController {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        sideMenuView.isHidden = false
        chidleView.isHideMenu = false
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
extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func registerCell(){
        messageCollectionView.delegate = self
        let nib = UINib(nibName: "UserListCollectionViewCell", bundle: nil)
        messageCollectionView.register(nib, forCellWithReuseIdentifier: "UserListCollectionViewCell")
    }
    func makeDataSource()-> DataSource{
        let dataSource = DataSource(collectionView: messageCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserListCollectionViewCell", for: indexPath)
//            cell
            return cell
        }
        return dataSource
    }
    func appllySnapShot(){
        var snapshot = SnapShot()
        snapshot.appendSections([.main])
        snapshot.appendItems(<#T##identifiers: [MenuItem]##[MenuItem]#>)
    }
}
