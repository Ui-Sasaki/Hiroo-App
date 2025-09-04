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
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // 最初に表示する画面（学校未選択→選択画面、選択済み→Home）
        if isSchoolSelected() {
            setRootToHome(animated: false)
        } else {
            setRootToSelectSchool(animated: false)
        }
    }
    
    // MARK: - ルート切り替え（共通）
    private func switchRoot(to root: UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        let nav = UINavigationController(rootViewController: root)
        nav.navigationBar.prefersLargeTitles = true
        
        // SideMenu を毎回この nav に対して設定
        configureSideMenu(for: nav)
        
        if animated {
            // クロスディゾルブで気持ちよく切り替え
            UIView.transition(with: window,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: {
                window.rootViewController = nav
                window.makeKeyAndVisible()
            },
                              completion: nil)
        } else {
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }
    
    func setRootToSelectSchool(animated: Bool) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SelectSchoolViewController") as! SelectSchoolViewController
        switchRoot(to: vc, animated: animated)
    }
    
    func setRootToHome(animated: Bool) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        switchRoot(to: vc, animated: animated)
    }
    
    private func configureSideMenu(for nav: UINavigationController) {
        let menuRoot = SideMenuViewController()
        let menu = SideMenuNavigationController(rootViewController: menuRoot)
        menu.leftSide = true
        menu.modalPresentationStyle = .overFullScreen
        
        var settings = SideMenuSettings()
        settings.presentationStyle = .menuSlideIn
        settings.menuWidth = min(self.window?.bounds.width ?? 320, 300)
        menu.settings = settings
        
        SideMenuManager.default.leftMenuNavigationController = menu
        // ナビゲーション領域のエッジスワイプでメニューを開く
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: nav.view, forMenu: .left)
        // 必要ならナビバーへのパンも
        // SideMenuManager.default.addPanGestureToPresent(toView: nav.navigationBar)
    }
    
    private func isSchoolSelected() -> Bool {
        return UserDefaults.standard.hasSelectedSchool
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
