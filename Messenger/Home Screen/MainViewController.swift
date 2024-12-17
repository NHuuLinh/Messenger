//
//  MainViewController.swift
//  Messenger
//
//  Created by LinhMAC on 15/02/2024.
//

import UIKit



final class MainViewController: UIViewController {
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var messageCollectionView: UICollectionView!
    
    typealias DataSource = UICollectionViewDiffableDataSource<MenuSection, Document>
    typealias SnapShot = NSDiffableDataSourceSnapshot<MenuSection, Document>
    
    private let chidleView = MenuViewcontroller()
    private lazy var dataSource = makeDataSource()
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuView.isHidden = true
        viewModel.loadDataFromFirebase()
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
        snapshot.appendItems(viewModel.totalFriendList)
    }
}
