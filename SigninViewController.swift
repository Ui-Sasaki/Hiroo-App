import UIKit
import GoogleSignIn

class SigninViewController: UIViewController { 

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

    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        button.setTitle("  Sign in with Google", for: .normal)
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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupActions()
    }

    // MARK: - Setup
    private func setupUI() {
        view.addSubview(stackView)

        let separatorStackView = createSeparatorWithLabel()

        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(forgotPasswordButton)
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(separatorStackView)
        stackView.addArrangedSubview(gmailButton)

        stackView.setCustomSpacing(40, after: logoImageView)
        stackView.setCustomSpacing(30, after: separatorStackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
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

    private func setupActions() {
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        gmailButton.addTarget(self, action: #selector(gmailSignInTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc private func signInTapped() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please enter both email and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        print("Sign in with email: \(email)")
    }

    @objc private func gmailSignInTapped() {
        print("Google Sign-In tapped")
    }

    @objc private func forgotPasswordTapped() {
        print("Forgot password tapped")
    }
}
