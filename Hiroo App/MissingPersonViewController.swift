import UIKit
import FirebaseFirestore

// 迷子情報を表示するViewController
class MissingPersonViewController: UIViewController {

    // TextFields
    let nameTextField = UITextField()
    let ageTextField = UITextField()
    let clothesTextField = UITextField()
    let lastSeenTextField = UITextField()
    let reporterTextField = UITextField()
    let foundNameTextField = UITextField()
    let foundLocationTextField = UITextField()

    // Buttons
    let registerButton = UIButton(type: .system)
    let foundButton = UIButton(type: .system)

    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.backgroundColor = .systemBackground
        view.backgroundColor = .white
        setupUI()
    }

    func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [
            nameTextField,
            ageTextField,
            clothesTextField,
            lastSeenTextField,
            reporterTextField,
            registerButton,
            foundNameTextField,
            foundLocationTextField,
            foundButton
        ])

        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        // 共通TextField設定
        let textFields = [
            nameTextField,
            ageTextField,
            clothesTextField,
            lastSeenTextField,
            reporterTextField,
            foundNameTextField,
            foundLocationTextField
        ]

        textFields.forEach {
            $0.borderStyle = .roundedRect
            $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }

        // プレースホルダー設定
        nameTextField.placeholder = "迷子の名前/ lost person's name"
        ageTextField.placeholder = "年齢/ lost person's age"
        clothesTextField.placeholder = "服装/ clothing"
        lastSeenTextField.placeholder = "最後に見かけた場所/ last seen location"
        reporterTextField.placeholder = "探している人の名前/ person searching"
        foundNameTextField.placeholder = "発見された迷子の名前/ found lost person's name"
        foundLocationTextField.placeholder = "見つかった場所/ where they are found"

        // 登録ボタン設定
        registerButton.setTitle("迷子を登録", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.layer.cornerRadius = 8
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        registerButton.addTarget(self, action: #selector(registerMissingPerson), for: .touchUpInside)

        // 発見ボタン設定
        foundButton.setTitle("発見情報を登録", for: .normal)
        foundButton.setTitleColor(.white, for: .normal)
        foundButton.backgroundColor = .systemGreen
        foundButton.layer.cornerRadius = 8
        foundButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        foundButton.addTarget(self, action: #selector(registerFoundPerson), for: .touchUpInside)

        // Auto Layout
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    // MARK: - モデル

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

    struct FoundPerson {
        let name: String
        let foundLocation: String

        var documentID: String {
            return name.replacingOccurrences(of: " ", with: "_") + "_found"
        }
    }

    // MARK: - 入力フィールドのリセット

    func resetFields() {
        let textFields = [
            nameTextField,
            ageTextField,
            clothesTextField,
            lastSeenTextField,
            reporterTextField,
            foundNameTextField,
            foundLocationTextField
        ]
        textFields.forEach { $0.text = "" }
        view.endEditing(true)
    }

    // MARK: - アクション

    @objc func registerMissingPerson() {
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

//            FirestoreManager.shared.insertMissingPerson(person) { success in
//                if success {
//                    print("迷子情報の登録が完了しました")
//                    self.resetFields()
//                } else {
//                    print("登録に失敗しました")
//                }
//            }
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }

    @objc func registerFoundPerson() {
        guard let name = foundNameTextField.text, !name.isEmpty,
              let location = foundLocationTextField.text, !location.isEmpty else {
            print("名前と見つかった場所を入力してください")
            return
        }

        let alert = UIAlertController(title: "発見情報登録",
                                      message: "この情報を登録しますか？",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "はい", style: .default, handler: { _ in
            let found = FoundPerson(name: name, foundLocation: location)

//            FirestoreManager.shared.insertFoundPerson(found) { success in
//                if success {
//                    print("発見情報の登録が完了しました")
//                    self.resetFields()
//                } else {
//                    print("発見情報の登録に失敗しました")
//                }
//            }
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }
}
