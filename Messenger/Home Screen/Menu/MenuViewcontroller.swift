//
//  MenuViewcontroller.swift
//  Messenger
//
//  Created by Huu Linh Nguyen on 3/12/24.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Kingfisher
import CoreData
import KeychainSwift
enum MenuSection: CaseIterable {
    case main
}
struct UserProfile: Codable,Hashable {
    var id: String?
    var name: String?
    var gender: String?
    var dateOfBirth: String?
    var email: String
    var phoneNumber: String?
    var avatar: String?
    var favorited: [String]?
    var searchHistory: [String]?
}


protocol SideMenuViewControllerDisplay: AnyObject {
//    func selectMenuItem(with menuItems: MenuItem)
    func loadDataFromFirebase()
}

class MenuViewcontroller: UIViewController, SideMenuViewControllerDisplay {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var menuTableView: UITableView!
    
    @IBOutlet weak var hideMenuBtn: UIButton!
    @IBOutlet weak var leftBtnConstraint: NSLayoutConstraint!
    
//    weak var delegate: SideMenuDelegate?
    var onMenuItemSelected: ((MenuItem) -> Void)?
    var currentUser: UserProfile?
    private let storage = Storage.storage().reference()
    private var databaseRef = Database.database().reference()
    var menuItems = [MenuItem]()
    let keychain = KeychainSwift()
    var isHideMenu = true {
        didSet {
            sideMenuHandle()
        }
    }
    var pressMenuBtn : (() -> ())?
    var dataSource : UITableViewDiffableDataSource<MenuSection,MenuItem>?


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        chooseDataToLoad()
        setupUI()

    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func setupUI(){
        handlerSideView()
    }
    func sideMenuHandle(){
        UIView.animate(withDuration: 1) { [weak self] in
            print("start")
            self?.handlerSideView()
        } completion: { [weak self] finished in
            guard let self = self else {return}
            if self.isHideMenu && finished {
                self.pressMenuBtn?()
                print("stop")
            }
        }
    }
    func handlerSideView(){
        leftBtnConstraint.constant = isHideMenu ? -240 : 0
        view.layer.opacity = isHideMenu ? 0 : 1
        hideMenuBtn.layer.opacity = isHideMenu ? 0 : 1
//        sideMenuView.isHidden = isHideMenu
//        hideMenuBtn.isHidden = isHideMenu
        self.view.layoutIfNeeded()

    }
    @IBAction func BtnHandle(_ sender: UIButton) {
        switch sender {
        case hideMenuBtn:
            isHideMenu = true
//            sideMenuHandle()
            print("hide")
        default:
            break
        }
    }
}
extension MenuViewcontroller : UITableViewDelegate {
    func setUpView() {
        menuItems = [
            MenuItem(title: "Tài khoản",
                     image: UIImage(systemName: "person.fill"),
                     screen: .profile),
            MenuItem(title: "Cài đặt",
                     image: UIImage(systemName: "gearshape.fill"),
                     screen: .settings),
            MenuItem(title: "Thông báo",
                     image: UIImage(systemName: "bell.fill"),
                     screen: .notification),
            MenuItem(title: "Về chúng tôi",
                     image: UIImage(named: "Aboutus"),
                     screen: .aboutUs),
            MenuItem(title: "Chính sách bảo mật",
                     image: UIImage(systemName: "shield.fill"),
                     screen: .privatePolicy),
            MenuItem(title: "Điều khoản sử dụng",
                     image: UIImage(systemName: "book.fill"),
                     screen: .termsOfUse),
            MenuItem(title: "Đăng xuất",
                     image: UIImage(named: "Logout"),
                     screen: .logout)
        ]
//        menuTableView.dataSource = self
        menuTableView.delegate = self
        let menuCell = UINib(nibName: "MenuTableViewCell", bundle: nil)
        menuTableView.register(menuCell, forCellReuseIdentifier: "MenuTableViewCell")
        menuTableView.rowHeight = 70
        menuTableView.separatorStyle = .none
        setupdata()
        applynapShot()
    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return menuItems.count
//    }
    func setupdata(){
        dataSource = UITableViewDiffableDataSource<MenuSection, MenuItem>(tableView: menuTableView) { (tableView, indexPath, itemIdentifier) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
            cell.getMenuTitle(item: itemIdentifier)
            return cell
        }
    }
    func applynapShot(){
        var snapShot = NSDiffableDataSourceSnapshot<MenuSection,MenuItem>()
        snapShot.appendSections([.main])
        snapShot.appendItems(menuItems)
        dataSource?.apply(snapShot)
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
//        cell.getMenuTitle(item: menuItems[indexPath.row])
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onMenuItemSelected?(menuItems[indexPath.row])
        print("onMenuItemSelected:\(indexPath.row)")
    }
    
    
}

extension MenuViewcontroller {
    
    func loadDataFromFirebase() {
       showLoading(isShow: true)
       guard let currentUserID = Auth.auth().currentUser?.uid else {
           showLoading(isShow: false)
           return
       }
       self.userEmail.text = Auth.auth().currentUser?.email
       let userRef = Database.database().reference().child("users").child(currentUserID)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            self.showLoading(isShow: false)
            if let userData = snapshot.value as? [String: Any] {
                self.userName.text = userData["name"] as? String
                if let imageURLString = userData["avatar"] as? String,
                   let imageURL = URL(string: imageURLString) {
                    self.userAvatar.kf.setImage(with: imageURL)
                }
                print("Dữ liệu tải thành công")
            } else {
                print("Không thể lấy dữ liệu từ Firebase")
            }
        }
   }
    func loadProfileFromCoreData(){
#warning("Thiếu CoreData")
        //        let profileData = CoreDataHelper.share.getProfileValuesFromCoreData()
//        userAvatar.image = profileData.avatar
//        userName.text = profileData.name
        userEmail.text = keychain.get("email")
    }
    func chooseDataToLoad(){
        if UserDefaults.standard.didUpdateProfile {
            loadProfileFromCoreData()
            print("loadProfileFromCoreData")
        } else {
            loadDataFromFirebase()
            print("loadDataFromFirebase")
        }
    }
}

