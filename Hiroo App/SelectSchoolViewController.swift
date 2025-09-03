//
//  SelectSchoolViewController.swift
//  Hiroo App
//
//  Created by 井上　希稟 on 2025/07/16.
//

import UIKit

class SelectSchoolViewController: UIViewController {
    var saveData: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SelectSchoolViewController")
    }
    
    @IBAction func selectHiroo() {
        UserDefaults.standard.selectedSchool = .hiroo
        toMainTabBar()
    }
    @IBAction func selectKoishikawa() {
        UserDefaults.standard.selectedSchool = .koishikawa
        toMainTabBar()
    }
    @objc func toMainTabBar() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBar = sb.instantiateViewController(
            withIdentifier: "MainTabBarController"
        ) as? MainTabBarViewController else {
            return
        }
        DispatchQueue.main.async {
            if let windowScene = self.view.window?.windowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = tabBar
                window.makeKeyAndVisible()
            }
        }
    }

}
