//
//  StartingPageViewController.swift
//  Hiroo App
//
//  Created by ard on 2025/06/05.
//
import UIKit
import UserNotifications

class StartingPageViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hiroo App"
        label.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let hirooGakuenImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "HirooGakuen"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let hirooKoishikawaImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "HirooKoishikawa"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let crossLabel: UILabel = {
        let label = UILabel()
        label.text = "×"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "広尾の世界へようこそ"
        label.font = UIFont.systemFont(ofSize: 22)
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let newUserButton = StartingPageViewController.makeGreenButton(title: "はじめての方はこちら")
    private let loginButton = StartingPageViewController.makeGreenButton(title: "ログインする方はこちら")

    private let logoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 20
        stack.distribution = .equalCentering
        stack.alpha = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let partyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🎉", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var sparkleEmitter: CAEmitterLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 239/255, green: 252/255, blue: 239/255, alpha: 1)
        setupLayout()
        setupActions()
        requestNotificationPermission()
        animateEntrance()
    }

    private func setupLayout() {
        logoStack.addArrangedSubview(hirooGakuenImage)
        logoStack.addArrangedSubview(crossLabel)
        logoStack.addArrangedSubview(hirooKoishikawaImage)

        [titleLabel, logoStack, welcomeLabel, newUserButton, loginButton, partyButton].forEach {
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            logoStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 55),
            logoStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hirooGakuenImage.widthAnchor.constraint(equalToConstant: 100),
            hirooKoishikawaImage.widthAnchor.constraint(equalToConstant: 100),
            hirooGakuenImage.heightAnchor.constraint(equalToConstant: 100),
            hirooKoishikawaImage.heightAnchor.constraint(equalToConstant: 100),

            welcomeLabel.topAnchor.constraint(equalTo: logoStack.bottomAnchor, constant: 100),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            newUserButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            newUserButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newUserButton.widthAnchor.constraint(equalToConstant: 250),
            newUserButton.heightAnchor.constraint(equalToConstant: 50),

            loginButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 40),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: newUserButton.widthAnchor),
            loginButton.heightAnchor.constraint(equalTo: newUserButton.heightAnchor),

            partyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            partyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func animateEntrance() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseOut], animations: {
            self.titleLabel.alpha = 1
        }, completion: { _ in
            self.addSparkEmitter(around: self.titleLabel)
        })

        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
            self.logoStack.alpha = 1
        })

        UIView.animate(withDuration: 0.8, delay: 1.0, options: [.curveEaseInOut], animations: {
            self.welcomeLabel.alpha = 1
            self.newUserButton.alpha = 1
            self.loginButton.alpha = 1
        })
    }

    private func addSparkEmitter(around label: UILabel) {
        guard let sparkleCG = emojiToImage("✨", fontSize: 40)?.cgImage else { return }

        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: label.center.x, y: label.frame.midY + 5)
        emitter.emitterShape = .circle
        emitter.emitterSize = CGSize(width: label.bounds.width + 10, height: label.bounds.height + 4)

        let cell = CAEmitterCell()
        cell.contents = sparkleCG
        cell.birthRate = 3
        cell.lifetime = 2.0
        cell.velocity = 25
        cell.velocityRange = 10
        cell.scale = 0.15
        cell.scaleRange = 0.05
        cell.alphaSpeed = -0.3
        cell.emissionRange = .pi * 2

        emitter.emitterCells = [cell]
        view.layer.addSublayer(emitter)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                emitter.removeFromSuperlayer()
            }
            let fade = CABasicAnimation(keyPath: "opacity")
            fade.fromValue = 1
            fade.toValue = 0
            fade.duration = 1.0
            emitter.add(fade, forKey: "fadeOut")
            CATransaction.commit()
        }
    }

    @objc private func didTapParty() {
        sparkleEmitter?.removeFromSuperlayer()
        sparkleEmitter = createSparkEmitterFullScreen()
        view.layer.addSublayer(sparkleEmitter!)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            guard let emitter = self.sparkleEmitter else { return }
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                emitter.removeFromSuperlayer()
                self.sparkleEmitter = nil
            }
            let fade = CABasicAnimation(keyPath: "opacity")
            fade.fromValue = 1
            fade.toValue = 0
            fade.duration = 1.0
            emitter.add(fade, forKey: "fadeOut")
            CATransaction.commit()
        }
    }

    private func createSparkEmitterFullScreen() -> CAEmitterLayer {
        guard let sparkleCG = emojiToImage("✨", fontSize: 40)?.cgImage else { return CAEmitterLayer() }

        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        emitter.emitterShape = .rectangle
        emitter.emitterSize = view.bounds.size

        let cell = CAEmitterCell()
        cell.contents = sparkleCG
        cell.birthRate = 10
        cell.lifetime = 2.5
        cell.velocity = 80
        cell.velocityRange = 50
        cell.scale = 0.2
        cell.scaleRange = 0.1
        cell.alphaSpeed = -0.3
        cell.emissionRange = .pi * 2

        emitter.emitterCells = [cell]
        return emitter
    }

    private func emojiToImage(_ emoji: String, fontSize: CGFloat = 30) -> UIImage? {
        let size = CGSize(width: fontSize, height: fontSize)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        (emoji as NSString).draw(in: CGRect(origin: .zero, size: size), withAttributes: [
            .font: UIFont.systemFont(ofSize: fontSize)
        ])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    private func setupActions() {
        newUserButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        partyButton.addTarget(self, action: #selector(didTapParty), for: .touchUpInside)
    }

    @objc private func didTapSignUp() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func didTapSignIn() {
        let vc = SigninViewController_2()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ Notification error: \(error)")
            } else {
                print("🔔 Notification granted: \(granted)")
            }
        }
    }

    private static func makeGreenButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(red: 224/255, green: 255/255, blue: 224/255, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.green.cgColor
        button.layer.cornerRadius = 12
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
