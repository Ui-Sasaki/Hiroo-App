//
//  MissingPersonViewController.swift
//  Hiroo App
//
//  Created by 井上　希稟 on 2025/05/14.
//

import UIKit
import FirebaseFirestore

class MissingPersonViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!           // 迷子の名前
    @IBOutlet weak var ageTextField: UITextField!            // 年齢
    @IBOutlet weak var clothesTextField: UITextField!        // 服装
    @IBOutlet weak var lastSeenTextField: UITextField!       // 最後に見かけた場所
    @IBOutlet weak var reporterTextField: UITextField!       // 探している人の名前

    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    struct MissingPerson {
        let name: String
        let age: String
        let clothes: String
        let lastSeenLocation: String
        let reportedBy: String

        var documentID: String {
            return name.replacingOccurrences(of: " ", with: "_") + "_" + age
        }
    }

    func registerMissingPerson() {
        guard let name = nameTextField.text, !name.isEmpty,
              let age = ageTextField.text, !age.isEmpty,
              let clothes = clothesTextField.text, !clothes.isEmpty,
              let lastSeen = lastSeenTextField.text, !lastSeen.isEmpty,
              let reporter = reporterTextField.text, !reporter.isEmpty else {
            print("すべての項目を入力してください")
            return
        }

        let alert = UIAlertController(title: "迷子登録",
                                      message: "この迷子情報を登録しますか？",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "はい", style: .default, handler: { _ in
            let person = MissingPerson(name: name,
                                       age: age,
                                       clothes: clothes,
                                       lastSeenLocation: lastSeen,
                                       reportedBy: reporter)

            FirestoreManager.shared.insertMissingPerson(person) { success in
                if success {
                    print("迷子情報の登録が完了しました")
                } else {
                    print("登録に失敗しました")
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }
}
