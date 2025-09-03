//
//import UIKit
//import FirebaseAuth
//
//class SignInViewController: UIViewController {
//    
//    var statusLabel = UILabel()
//    var emailTextField = UITextField()
//    var passwordTextField = UITextField()
//    var signInButton = UIButton()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .white
//        view.addSubview(statusLabel)
//        view.addSubview(emailTextField)
//        view.addSubview(passwordTextField)
//        view.addSubview(signInButton)
//        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        statusLabel.text = "サインイン"
//        statusLabel.textAlignment = .center
//        statusLabel.frame = CGRect(x: 20,
//                                      y: 50,
//                                      width: view.frame.size.width - 40,
//                                      height: 50)
//        
//        emailTextField.placeholder = "メールアドレス"
//        emailTextField.backgroundColor = .white
//        emailTextField.autocapitalizationType = .none
//        emailTextField.layer.borderColor = UIColor.gray.cgColor
//        emailTextField.layer.borderWidth = 1
//        emailTextField.layer.cornerRadius = 10
//        emailTextField.leftViewMode = .always
//        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
//        emailTextField.frame = CGRect(x: 20,
//                                      y: 100,
//                                      width: view.frame.size.width - 40,
//                                      height: 50)
//        
//        passwordTextField.placeholder = "パスワード"
//        passwordTextField.backgroundColor = .white
//        passwordTextField.isSecureTextEntry = false
//        passwordTextField.autocapitalizationType = .none
//        passwordTextField.layer.borderColor = UIColor.gray.cgColor
//        passwordTextField.layer.borderWidth = 1
//        passwordTextField.layer.cornerRadius = 10
//        passwordTextField.leftViewMode = .always
//        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
//        passwordTextField.frame = CGRect(x: 20,
//                                         y: emailTextField.frame.origin.y + emailTextField.frame.size.height + 10,
//                                         width: view.frame.size.width - 40,
//                                         height: 50)
//        
//        signInButton.setTitle("サインイン", for: .normal)
//        signInButton.backgroundColor = .systemBlue
//        signInButton.layer.cornerRadius = 20
//        signInButton.tintColor = .white
//        signInButton.frame = CGRect(x: 20,
//                              y: passwordTextField.frame.origin.y + passwordTextField.frame.size.height + 10,
//                              width: view.frame.size.width - 40,
//                              height: 75)
//    }
//    @IBAction func toNEXT() {
//            performSegue(withIdentifier: "toNEXT", sender: nil)
//        }
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if segue.identifier == "toNEXT" {
//                let mapView = segue.destination as! koishikawamap
//            }
//        }
//
//    @objc func didTapSignInButton(){
//        guard let email = emailTextField.text, !email.isEmpty,
//              let password = passwordTextField.text, !password.isEmpty else{
//            print("メールアドレス,パスワードが入力されていません")
//            return
//        }
//        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
//            guard let strongSelf = self else {
//                return
//            }
//            guard error == nil else {
//                print("アカウントが存在しません")
//                strongSelf.signUp(email: email, password: password)
//                return
//            }
//            print("サインインしました")
//            strongSelf.view.backgroundColor = .systemGreen
//            strongSelf.statusLabel.text = "サインインしました"
//            strongSelf.statusLabel.textColor = .white
//            strongSelf.emailTextField.isHidden = true
//            strongSelf.passwordTextField.isHidden = true
//            strongSelf.signInButton.isHidden = true
//        })
//    }
//    
//    func signUp(email: String, password: String){
//        let alert = UIAlertController(title: "アカウント作成",
//                                      message: "新しくアカウントを作成しますか？",
//                                      preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "作成",
//                                      style: .default,
//                                      handler: { _ in
//            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self]result, error in
//                guard let strongSelf = self else {
//                    return
//                }
//                guard error == nil else {
//                    print("サインアップに失敗しました")
//                    return
//                }
//                print("サインアップしました")
//                strongSelf.view.backgroundColor = .systemGreen
//                strongSelf.statusLabel.text = "サインインしました"
//                strongSelf.statusLabel.textColor = .white
//                strongSelf.emailTextField.isHidden = true
//                strongSelf.passwordTextField.isHidden = true
//                strongSelf.signInButton.isHidden = true
//            })
//        }))
//        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { _ in }))
//        present(alert, animated: true)
//    }
//}
//
//
