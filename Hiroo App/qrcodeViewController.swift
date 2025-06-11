import Foundation
import UIKit

class QRCodeViewController: UIViewController {

    // MARK: - UI Components
    private let passcodeTextField = UITextField()
    private let generateButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    private let qrCodeImageView = UIImageView()
    private let statusLabel = UILabel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // MARK: - Properties
    private var currentQRCodeImage: UIImage?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad called")
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear called")
    }

    // MARK: - UI Setup
    private func setupUI() {
        title = "QRコード生成"
        view.backgroundColor = .systemBackground
        print("setupUI called")
        
        // ScrollView設定
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // テキストフィールドの設定
        passcodeTextField.placeholder = "パスコードを入力してください"
        passcodeTextField.borderStyle = .roundedRect
        passcodeTextField.keyboardType = .asciiCapable
        passcodeTextField.autocorrectionType = .no
        passcodeTextField.autocapitalizationType = .none
        passcodeTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // QRコード生成ボタン
        generateButton.setTitle("QRコード生成", for: .normal)
        generateButton.backgroundColor = .systemBlue
        generateButton.setTitleColor(.white, for: .normal)
        generateButton.layer.cornerRadius = 8
        generateButton.isEnabled = false
        generateButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 保存ボタン
        saveButton.setTitle("保存", for: .normal)
        saveButton.backgroundColor = .systemGreen
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.isHidden = true
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 共有ボタン
        shareButton.setTitle("共有", for: .normal)
        shareButton.backgroundColor = .systemOrange
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.layer.cornerRadius = 8
        shareButton.isHidden = true
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        // QRコード画像ビュー
        qrCodeImageView.contentMode = .scaleAspectFit
        qrCodeImageView.backgroundColor = .systemGray6
        qrCodeImageView.layer.cornerRadius = 8
        qrCodeImageView.layer.borderWidth = 1
        qrCodeImageView.layer.borderColor = UIColor.systemGray4.cgColor
        qrCodeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // ステータスラベル
        statusLabel.text = "パスコードを入力してQRコードを生成してください"
        statusLabel.textColor = .systemGray
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // サブビューを追加
        contentView.addSubview(passcodeTextField)
        contentView.addSubview(generateButton)
        contentView.addSubview(qrCodeImageView)
        contentView.addSubview(saveButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(statusLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // TextField constraints
            passcodeTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            passcodeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passcodeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passcodeTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Generate button constraints
            generateButton.topAnchor.constraint(equalTo: passcodeTextField.bottomAnchor, constant: 20),
            generateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            generateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            generateButton.heightAnchor.constraint(equalToConstant: 50),
            
            // QR Code ImageView constraints
            qrCodeImageView.topAnchor.constraint(equalTo: generateButton.bottomAnchor, constant: 30),
            qrCodeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            qrCodeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            qrCodeImageView.heightAnchor.constraint(equalToConstant: 300),
            
            // Save button constraints
            saveButton.topAnchor.constraint(equalTo: qrCodeImageView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Share button constraints
            shareButton.topAnchor.constraint(equalTo: qrCodeImageView.bottomAnchor, constant: 20),
            shareButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10),
            shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Status label constraints
            statusLabel.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        // テキストフィールドの変更を監視
        passcodeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        // ボタンのアクションを設定
        generateButton.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func textFieldDidChange() {
        // テキストが入力されたらボタンを有効にする
        generateButton.isEnabled = !(passcodeTextField.text?.isEmpty ?? true)
    }
    
    @objc private func generateButtonTapped() {
        guard let passcode = passcodeTextField.text, !passcode.isEmpty else {
            updateStatus("パスコードを入力してください", isError: true)
            return
        }
        
        // QRコード生成
        if let qrImage = generateQRCode(from: passcode) {
            currentQRCodeImage = qrImage
            qrCodeImageView.image = qrImage
            saveButton.isHidden = false
            shareButton.isHidden = false
            updateStatus("QRコードが生成されました", isError: false)
        } else {
            updateStatus("QRコードの生成に失敗しました", isError: true)
        }
    }
    
    @objc private func saveButtonTapped() {
        guard let image = currentQRCodeImage else {
            updateStatus("保存する画像がありません", isError: true)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func shareButtonTapped() {
        guard let image = currentQRCodeImage else {
            updateStatus("共有する画像がありません", isError: true)
            return
        }
        
        let activityViewController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        // iPadでの表示設定
        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = shareButton
            popover.sourceRect = shareButton.bounds
        }
        
        present(activityViewController, animated: true)
    }
    
    // MARK: - Helper Methods
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        
        filter.setValue(data, forKey: "inputMessage")
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        
        guard let output = filter.outputImage?.transformed(by: transform) else {
            return nil
        }
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(output, from: output.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    private func updateStatus(_ message: String, isError: Bool) {
        statusLabel.text = message
        statusLabel.textColor = isError ? .systemRed : .systemGreen
    }
    
    @objc private func imageSaveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        DispatchQueue.main.async {
            if let error = error {
                self.updateStatus("保存に失敗しました: \(error.localizedDescription)", isError: true)
            } else {
                self.updateStatus("写真ライブラリに保存されました", isError: false)
            }
        }
    }
}
