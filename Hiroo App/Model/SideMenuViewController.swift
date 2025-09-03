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
    private let items = ["学校選択", "イベント一覧", "設定"]
    
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
        case "学校選択":
            goToSelectSchool()
            
        case "イベント一覧":
            print("イベント一覧 tapped")
            
        case "設定":
            print("設定 tapped")
            
        default:
            break
        }
    }
    private func goToSelectSchool() {
        dismiss(animated: true) {
            // 最前面の UINavigationController を取得
            guard let nav = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })?
                .rootViewController as? UINavigationController else {
                assertionFailure("UINavigationController not found")
                return
            }
            
            // ✅ Storyboard に ID がある場合
            let sb = UIStoryboard(name: "Main", bundle: nil)
            if let selectVC = sb.instantiateViewController(withIdentifier: "SelectSchoolViewController") as? SelectSchoolViewController {
                nav.pushViewController(selectVC, animated: true)
                return
            }
            
            // ✅ もし Storyboard を使っていない（コードまたはXIBの）場合のフォールバック
            let selectVC = SelectSchoolViewController() // XIBなら nibName: を指定
            nav.pushViewController(selectVC, animated: true)
        }
    }
    
    
    //import UIKit
    //
    //import UIKit
    //
    //final class SideMenuViewController: UITableViewController {
    //    private let items = ["学校選択", "イベント一覧", "設定"]
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    //    }
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    //        cell.textLabel?.text = items[indexPath.row]
    //        return cell
    //    }
    //    override func tableView(_ tv: UITableView, didSelectRowAt i: IndexPath) {
    //            // メニュー項目タップ時の遷移処理
    //            tv.deselectRow(at: i, animated: true)
    //            switch items[i.row] {
    //            case "設定":
    //                print("設定")
    //            case "ヘルプ":
    //                print("ヘルプ")
    //            case "ログアウト":
    //                print("ログアウト")
    //            default: break
    //            }
    //        }
    //}
}
