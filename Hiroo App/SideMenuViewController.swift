//
//  MenuViewController.swift
//  Hiroo App
//
//  Created by 井上　希稟 on 2025/09/03.
//

// MenuViewController.swift
//
//  MenuViewController.swift
//  Hiroo App
//
//  Created by XX on 2025/09/03.
//

import UIKit

final class SideMenuViewController: UITableViewController {
    private let items = ["学校選択に戻る", "イベント一覧", "設定"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tv: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tv.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = items[indexPath.row]
        
        switch selectedItem {
        case "学校選択に戻る":
            self.presentingViewController?.dismiss(animated: true, completion: { [weak self] in
                self?.routeToSelectSchool()
            })
        case "イベント一覧":
            print("イベント一覧 tapped")
            
        case "設定":
            print("設定 tapped")
            
        default:
            break
        }
    }
    private func routeToSelectSchool() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let selectVC = sb.instantiateViewController(withIdentifier: "SelectSchoolViewController") as? SelectSchoolViewController else {
            return
        }
        let nav = UINavigationController(rootViewController: selectVC)
        if let windowScene = view.window?.windowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = nav
            window.makeKeyAndVisible()
        } else {
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                window.rootViewController = nav
                window.makeKeyAndVisible()
            }
        }
    }
}
