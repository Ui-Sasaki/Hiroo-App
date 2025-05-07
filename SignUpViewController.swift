import UIKit
import PhotosUI
import FirebaseAuth
import FirebaseStorage

class SignUpViewController: UIViewController, PHPickerViewControllerDelegate {
    
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
        imageView.image = UIImage(systemName: "person.badge.plus")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Full Name"
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .words
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
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
    
    private let confirmPasswordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Confirm Password"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.addSubview(stackView)
    
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(confirmPasswordField)
        stackView.addArrangedSubview(signUpButton)
        stackView.addArrangedSubview(termsLabel)
        
        stackView.setCustomSpacing(40, after: logoImageView)
        stackView.setCustomSpacing(10, after: signUpButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Enable interaction and add gesture
        logoImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        logoImageView.addGestureRecognizer(tapGesture)
        logoImageView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        logoImageView.layer.cornerRadius = logoImageView.frame.width/2
    }
    
    private func setupActions() {
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
    
    // MARK: - Image Picker
    
    @objc private func selectProfileImage() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            if let image = image as? UIImage {
                DispatchQueue.main.async {
                    self?.logoImageView.image = image
                }
            }
        }
    }
    
    // MARK: - Actions
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
        
        // Create user
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.showAlert(message: error.localizedDescription)
                return
            }
            
            guard let user = result?.user else { return }
            
            // Upload profile image if available
            if let image = self?.logoImageView.image,
               let imageData = image.jpegData(compressionQuality: 0.75) {
                
                let storageRef = Storage.storage().reference().child("profile_images/\(user.uid).jpg")
                storageRef.putData(imageData, metadata: nil) { metadata, error in
                    if let error = error {
                        self?.showAlert(message: "Failed to upload profile image: \(error.localizedDescription)")
                        return
                    }
                    
                    storageRef.downloadURL { url, error in
                        guard let downloadURL = url else {
                            self?.showAlert(message: "Could not retrieve image URL.")
                            return
                        }
                        
                        let changeRequest = user.createProfileChangeRequest()
                        changeRequest.displayName = name
                        changeRequest.photoURL = downloadURL
                        changeRequest.commitChanges { error in
                            if let error = error {
                                self?.showAlert(message: "Profile update failed: \(error.localizedDescription)")
                            } else {
                                self?.showAlert(message: "Sign up successful! ✅")
                            }
                        }
                    }
                }
            } else {
                // No image selected, just update display name
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let error = error {
                        self?.showAlert(message: "Profile update failed: \(error.localizedDescription)")
                    } else {
                        self?.showAlert(message: "Sign up successful! ✅")
                    }
                }
            }
        }
    }
}
