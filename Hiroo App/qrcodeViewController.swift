//
//  qrcodeViewController.swift
//  Hiroo App
//
//  Created by 井上　希稟 on 2025/06/06.
//

import Foundation
import UIKit

class QRCodeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var passcodeTextField: UITextField!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        title = "QRコード生成"
        
        // テキストフィールドの設定
        passcodeTextField.placeholder = "パスコードを入力してください"
        passcodeTextField.borderStyle = .roundedRect
        passcodeTextField.keyboardType = .asciiCapable
        passcodeTextField.autocorrectionType = .no
        passcodeTextField.autocapitalizationType = .none
        
        // QRコード生成ボタン
        generateButton.setTitle("QRコード生成", for: .normal)
        generateButton.backgroundColor = .systemBlue
        generateButton.setTitleColor(.white, for: .normal)
        generateButton.layer.cornerRadius = 8
        generateButton.isEnabled = false
        
        // 保存ボタン
        saveButton.setTitle("保存", for: .normal)
        saveButton.backgroundColor = .systemGreen
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.isHidden = true
        
        // 共有ボタン
        shareButton.setTitle("共有", for: .normal)
        shareButton.backgroundColor = .systemOrange
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.layer.cornerRadius = 8
        shareButton.isHidden = true
        
        // QRコード画像ビュー
        qrCodeImageView.contentMode = .scaleAspectFit
        qrCodeImageView.backgroundColor = .systemGray6
        qrCodeImageView.layer.cornerRadius = 8
        qrCodeImageView.layer.borderWidth = 1
        qrCodeImageView.layer.borderColor = UIColor.systemGray4.cgColor
        
        // ステータスラベル
        statusLabel.text = "パスコードを入力してQRコードを生成してください"
        statusLabel.textColor = .systemGray
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
    }
}
