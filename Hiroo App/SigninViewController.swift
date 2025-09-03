import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import FirebaseStorage

class SigninViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SignInViewController")
        view.backgroundColor = .systemBackground
        setupUI()
        setupActions()
    }

    // MARK: - UI Components
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email"
        field.borderStyle = .roundedRect
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .trailing
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let orLabel: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let gmailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in with Google", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
        if let googleLogo = UIImage(named: "google_logo") ?? UIImage(systemName: "g.circle.fill") {
            let resizedLogo = googleLogo.withRenderingMode(.alwaysOriginal)
            button.setImage(resizedLogo, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(
            string: "Don't have an account? ",
            attributes: [.foregroundColor: UIColor.systemGray]
        )
        attributedTitle.append(NSAttributedString(
            string: "Sign Up",
            attributes: [.foregroundColor: UIColor.systemBlue, .font: UIFont.boldSystemFont(ofSize: 16)]
        ))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Setup UI
    private func setupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        scrollView.addSubview(stackView)

        let separatorStackView = createSeparatorWithLabel()

        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(forgotPasswordButton)
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(separatorStackView)
        stackView.addArrangedSubview(gmailButton)
        stackView.addArrangedSubview(signUpButton)

        stackView.setCustomSpacing(40, after: logoImageView)
        stackView.setCustomSpacing(30, after: separatorStackView)
        stackView.setCustomSpacing(20, after: gmailButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -80),

            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            gmailButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func createSeparatorWithLabel() -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let leftLine = UIView()
        leftLine.backgroundColor = .systemGray4
        leftLine.translatesAutoresizingMaskIntoConstraints = false

        let rightLine = UIView()
        rightLine.backgroundColor = .systemGray4
        rightLine.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(leftLine)
        containerView.addSubview(orLabel)
        containerView.addSubview(rightLine)

        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 30),

            leftLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            leftLine.trailingAnchor.constraint(equalTo: orLabel.leadingAnchor, constant: -10),
            leftLine.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            leftLine.heightAnchor.constraint(equalToConstant: 1),

            orLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            orLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            rightLine.leadingAnchor.constraint(equalTo: orLabel.trailingAnchor, constant: 10),
            rightLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            rightLine.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rightLine.heightAnchor.constraint(equalToConstant: 1)
        ])

        return containerView
    }

    // MARK: - Setup Actions
    private func setupActions() {
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        gmailButton.addTarget(self, action: #selector(gmailSignInTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc private func signInTapped() {
        print("signInTapped")
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter both email and password")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let user = result?.user else {
                print("ユーザー情報が取得できませんでした。")
                return
            }
            print("ログインに成功しました: \(user.uid)")
            print("ログイン成功！")
        }
    }

    @objc private func gmailSignInTapped() {
        view.endEditing(true)

        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let clientID = dict["CLIENT_ID"] as? String else {
            print("❌ Could not load CLIENT_ID from plist")
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            print("❌ Could not get root view controller")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            if let error = error {
                print("❌ Google Sign-In error: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("❌ No ID token from Google")
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    print("❌ Firebase Google Sign-In failed: \(error.localizedDescription)")
                } else {
                    print("✅ Signed in with Google: \(authResult?.user.email ?? "Unknown")")
                    self?.transitionToMainPage()
                }
            }
        }
    }

    @objc private func forgotPasswordTapped() {
        view.endEditing(true)

        let alert = UIAlertController(title: "Reset Password", message: "Enter your email to receive reset instructions.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }

        let send = UIAlertAction(title: "Send", style: .default) { _ in
            self.view.endEditing(true)
            guard let email = alert.textFields?.first?.text, !email.isEmpty else { return }

            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    print("Failed to send reset email: \(error.localizedDescription)")
                } else {
                    print("Reset email sent to \(email)")
                }
            }
        }

        alert.addAction(send)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func signUpTapped() {
        view.endEditing(true)
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }

    private func transitionToMainPage() {
        let mainVC = SelectSchoolViewController()
        let nav = UINavigationController(rootViewController: mainVC)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = nav
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
