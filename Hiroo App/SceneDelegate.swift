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

    internal func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let rootVC: UIViewController
        let forceShowStartingPage = true // ← change to false when you're done testing

        if forceShowStartingPage {
            rootVC = StartingPageViewController()
        } else if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            // First-time launch → show StartingPageViewController
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            rootVC = StartingPageViewController()
        } else if let user = Auth.auth().currentUser, user.isEmailVerified {
            // Already signed in & verified → go to MainPage
            rootVC = MainPage()
        } else {
            // Not signed in → show Signin screen
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
