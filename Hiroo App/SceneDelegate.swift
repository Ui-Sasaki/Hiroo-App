//
//  SceneDelegate.swift
//  Hiroo App
//
//  Created by ard on 2025/02/19.
//
//
//  SceneDelegate.swift
//  Hiroo App
//
//  Created by ard on 2025/02/19.
//

import UIKit
import FirebaseAuth
import SideMenu   // ← 追加

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let sb = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = sb.instantiateViewController(withIdentifier: "SelectSchoolViewController") as! SelectSchoolViewController

        let nav = UINavigationController(rootViewController: rootVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()

        // ===== SideMenu 初期化をここに追加 =====
        let menuRoot = SideMenuViewController() // ← あなたが作るメニュー画面
        let menu = SideMenuNavigationController(rootViewController: menuRoot)
        menu.leftSide = true
        menu.modalPresentationStyle = .overFullScreen

        var settings = SideMenuSettings()
        settings.presentationStyle = .menuSlideIn
        settings.menuWidth = min(window!.bounds.width, 300)
        menu.settings = settings

        // Manager に登録
        SideMenuManager.default.leftMenuNavigationController = menu

        // エッジスワイプで開けるようにする（TableViewとの干渉を避けたいならこちら推奨）
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: nav.view, forMenu: .left)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}


//import UIKit
//import FirebaseAuth
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//
//        window = UIWindow(windowScene: windowScene)
//
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let rootVC = sb.instantiateViewController(
//            withIdentifier: "SelectSchoolViewController"
//        ) as! SelectSchoolViewController
//
//        let nav = UINavigationController(rootViewController: rootVC)
//        window?.rootViewController = nav
//        window?.makeKeyAndVisible()
//    }
//
//    func sceneDidDisconnect(_ scene: UIScene) {}
//    func sceneDidBecomeActive(_ scene: UIScene) {}
//    func sceneWillResignActive(_ scene: UIScene) {}
//    func sceneWillEnterForeground(_ scene: UIScene) {}
//    func sceneDidEnterBackground(_ scene: UIScene) {}
//}
