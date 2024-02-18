//
//  SceneDelegate.swift
//  Messenger
//
//  Created by LinhMAC on 07/02/2024.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    static let shared = SceneDelegate()



    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        /**
         Khởi tạo window từ windownScene
         */
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        
        
        // kiểm tra xem có người dùng đã chọn theme chưa, nếu chưa load theme theo hệ thống
        if let selectedTheme = UserDefaults.standard.selectedTheme {
            print("Selected Theme:", selectedTheme.rawValue)
            ThemeManager.shared.applyTheme(selectedTheme, to: window)
        } else {
            print("No theme saved. Using default theme.")
            ThemeManager.shared.applyTheme(.system, to: window)
        }
        
        /// Vứt cho appDelegate nó giữ để sau mình lấy ra cho dễ
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
        
        let isReachableConnection = NetworkMonitor.shared.isReachable
        
        if isReachableConnection {
            // có mạng
            if UserDefaults.standard.hasOnboarded {
                if Auth.auth().currentUser != nil {
                    goToMain()
                    print("goToMain")
                } else {
                    goToLogin()
                    print("goToLogin")
                }
            } else {
                goToOnboard()
                print("goToOnboard")
            }
        } else {
            // mất mạng
            if UserDefaults.standard.hasOnboarded {
                if Auth.auth().currentUser != nil {
                    goToMain()
                } else {
                    routeToNoInternetAccess()
                }
            } else {
                routeToNoInternetAccess()
            }
            
        }
    }
    
    func goToMain() {
        print("Đã login rồi. Cho vào main")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        let mainNavigation = UINavigationController(rootViewController: mainVC)
        window!.rootViewController = mainNavigation
        window!.makeKeyAndVisible()
    }
    func goToOnboard() {
        print("Đã login rồi. Cho vào main")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let onboardVC = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController")
        window!.rootViewController = onboardVC
        window!.makeKeyAndVisible()
    }
    func goToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        let loginNavigation = UINavigationController(rootViewController: loginVC)
        window!.rootViewController = loginNavigation
        window!.makeKeyAndVisible()
    }
    func routeToNoInternetAccess() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let noInernetVC = storyboard.instantiateViewController(withIdentifier: "NoInternetAccessViewController")
        let noInternetNavigation = UINavigationController(rootViewController: noInernetVC)
        window!.rootViewController = noInternetNavigation
        window!.makeKeyAndVisible()
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

