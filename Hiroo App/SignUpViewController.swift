import UIKit
import PhotosUI
import FirebaseAuth
import FirebaseStorage

class SignUpViewController: UIViewController, PHPickerViewControllerDelegate {

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
        imageView.image = UIImage(systemName: "person.badge.plus")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameField = makeTextField(placeholder: "Full Name")
    private let emailField = makeTextField(placeholder: "Email", keyboard: .emailAddress, capitalize: .none, correct: .no)
    private let passwordField = makeSecureTextField(placeholder: "Password")
    private let confirmPasswordField = makeSecureTextField(placeholder: "Confirm Password")

    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "By signing up, you agree to our Terms of Service and Privacy Policy"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupActions()

        //tap somewhere random to get rid of the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logoImageView.layer.cornerRadius = logoImageView.frame.width / 2
    }

    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(stackView)

        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(confirmPasswordField)
        stackView.addArrangedSubview(signUpButton)
        stackView.addArrangedSubview(termsLabel)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),

            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        logoImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        logoImageView.addGestureRecognizer(tapGesture)
    }

    private func setupActions() {
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }

    @objc private func selectProfileImage() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self?.presentPhotoPicker()
                    } else {
                        self?.showAlert(message: "写真ライブラリのアクセスが許可されていません")
                    }
                }
            }
        case .authorized, .limited:
            presentPhotoPicker()
        case .denied, .restricted:
            showAlert(message: "写真ライブラリのアクセスが拒否されました。設定から許可を変更してください。")
        @unknown default:
            break
        }
    }

    private func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            if let image = image as? UIImage {
                DispatchQueue.main.async {
                    self?.logoImageView.image = image
                }
            }
        }
    }

    @objc private func signUpTapped() {
        guard let name = nameField.text, !name.isEmpty,
              let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordField.text, !confirmPassword.isEmpty else {
            showAlert(message: "Please fill in all fields")
            return
        }

        guard password == confirmPassword else {
            showAlert(message: "Passwords do not match")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.showAlert(message: error.localizedDescription)
                return
            }

            guard let self = self, let user = result?.user else { return }

            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name

            if let image = self.logoImageView.image,
               let imageData = image.jpegData(compressionQuality: 0.75),
               image != UIImage(systemName: "person.badge.plus") {
                let storageRef = Storage.storage().reference().child("profile_images/\(user.uid).jpg")
                storageRef.putData(imageData, metadata: nil) { _, error in
                    if let error = error {
                        self.showAlert(message: "Failed to upload profile image: \(error.localizedDescription)")
                        return
                    }

                    storageRef.downloadURL { url, _ in
                        if let url = url {
                            changeRequest.photoURL = url
                        }
                        changeRequest.commitChanges { _ in }
                    }
                }
            } else {
                changeRequest.commitChanges { _ in }
            }

            user.sendEmailVerification { error in
                if let error = error {
                    self.showAlert(message: "Failed to send verification email: \(error.localizedDescription)")
                    return
                }

                let alert = UIAlertController(
                    title: "Thank You!",
                    message: "Thank you for signing up! A verification email has been sent. Please verify your email to log in.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alert, animated: true)
            }
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

private func makeTextField(placeholder: String, keyboard: UIKeyboardType = .default, capitalize: UITextAutocapitalizationType = .sentences, correct: UITextAutocorrectionType = .default) -> UITextField {
    let field = UITextField()
    field.placeholder = placeholder
    field.borderStyle = .roundedRect
    field.keyboardType = keyboard
    field.autocapitalizationType = capitalize
    field.autocorrectionType = correct
    field.translatesAutoresizingMaskIntoConstraints = false
    return field
}

private func makeSecureTextField(placeholder: String) -> UITextField {
    let field = makeTextField(placeholder: placeholder)
    field.isSecureTextEntry = true
    return field
}
