//
//  MainPage.swift
//  Hiroo App
//
//  Created by ard on 2025/06/04.
//
import UIKit

class MainPage: UIViewController {

    private let blossomLayer = UIView() // 🌸 behind all UI

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "広尾"
        label.font = UIFont.systemFont(ofSize: 54, weight: .heavy)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let welcomeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "welcome_ribbon") // 🖼 Add this image to Assets!
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let gakuenButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("広尾学園", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let koishikawaButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("広尾小石川", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemGreen
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGroupedBackground
        setupLayout()
        setupActions()
        animateSakuraBlossoms()
    }

    private func setupLayout() {
        // 🌸 Add background blossom layer first
        blossomLayer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blossomLayer)
        NSLayoutConstraint.activate([
            blossomLayer.topAnchor.constraint(equalTo: view.topAnchor),
            blossomLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blossomLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blossomLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        view.addSubview(titleLabel)
        view.addSubview(welcomeImage)
        view.addSubview(gakuenButton)
        view.addSubview(koishikawaButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            welcomeImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            welcomeImage.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -20),
            welcomeImage.widthAnchor.constraint(equalToConstant: 140),
            welcomeImage.heightAnchor.constraint(equalToConstant: 50),

            gakuenButton.topAnchor.constraint(equalTo: welcomeImage.bottomAnchor, constant: 150),
            gakuenButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            gakuenButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            gakuenButton.heightAnchor.constraint(equalToConstant: 60),

            koishikawaButton.topAnchor.constraint(equalTo: gakuenButton.bottomAnchor, constant: 25),
            koishikawaButton.leadingAnchor.constraint(equalTo: gakuenButton.leadingAnchor),
            koishikawaButton.trailingAnchor.constraint(equalTo: gakuenButton.trailingAnchor),
            koishikawaButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func setupActions() {
        gakuenButton.addTarget(self, action: #selector(openGakuen), for: .touchUpInside)
        koishikawaButton.addTarget(self, action: #selector(openKoishikawa), for: .touchUpInside)
    }

    @objc private func openGakuen() {
        let vc = HirooGakuenViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func openKoishikawa() {
        let vc = HirooKoishikawaViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    // 🌸 Constant sakura fall
    private func animateSakuraBlossoms() {
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
            let label = UILabel()
            label.text = "🌸"
            label.font = UIFont.systemFont(ofSize: CGFloat.random(in: 20...34))
            let startX = CGFloat.random(in: 0...self.view.bounds.width)
            label.frame = CGRect(x: startX, y: -40, width: 40, height: 40)
            self.blossomLayer.addSubview(label)

            let endX = startX + CGFloat.random(in: -50...50)
            let duration = Double.random(in: 6...10)

            UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear], animations: {
                label.frame = CGRect(x: endX, y: self.view.bounds.height + 40, width: 40, height: 40)
                label.alpha = 0.0
            }, completion: { _ in
                label.removeFromSuperview()
            })
        }
    }
}
