//
//  SceneDelegate.swift
//  Hiroo App
//
//  Created by ard on 2025/02/19.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // ✅ This is the only scene(_:willConnectTo:) you need.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let rootVC: UIViewController
        let forceShowStartingPage = false // ✅ Set to true to test intro screen

        if forceShowStartingPage {
            rootVC = StartingPageViewController()
        } else if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            // 🌱 First-time launch → show intro/tutorial
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            rootVC = StartingPageViewController()
        } else if let user = Auth.auth().currentUser {
            if user.isEmailVerified {
                // ✅ Already signed in and verified → go to HirooGakuenViewController with tab bar
                rootVC = HirooGakuenViewController()
            } else {
                // ❌ Signed in but not verified → go to sign-in page
                rootVC = SigninViewController_2()
            }
        } else {
            // 🚪 Not signed in → go to sign-in page
            rootVC = SigninViewController_2()
        }

        let navController = UINavigationController(rootViewController: rootVC)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
