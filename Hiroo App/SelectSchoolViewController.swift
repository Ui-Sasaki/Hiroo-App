//
//  SelectSchoolViewController.swift
//  Hiroo App
//
//  Created by 井上　希稟 on 2025/07/16.
//

import UIKit

class SelectSchoolViewController: UIViewController {
    var saveData: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupUI()
        setupActions()
        animateEntrance()
        spawnBubbles()
    }
    
    @objc func selectHiroo() {
        UserDefaults.standard.selectedSchool = .hiroo
        switchToHome()
    }
    @objc func selectKoishikawa() {
        UserDefaults.standard.selectedSchool = .koishikawa
        switchToHome()
    }
    
    private func switchToHome() {
        if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            scene.setRootToHome(animated: true)
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "広尾"
        label.font = UIFont.systemFont(ofSize: 64, weight: .heavy)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gakuenButton = GameMenuButton(
        title: "広尾学園",
        color: UIColor(red: 0.75, green: 0.95, blue: 0.75, alpha: 1.0),
        icon: "graduationcap.fill"
    )
    
    private let koishikawaButton = GameMenuButton(
        title: "広尾小石川",
        color: UIColor(red: 0.65, green: 0.85, blue: 0.65, alpha: 1.0),
        icon: "building.columns.fill"
    )
    
    private let footerLabel: UILabel = {
        let label = UILabel()
        label.text = "© Hiroo App 2025"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.9, green: 1.0, blue: 0.9, alpha: 1.0).cgColor,
            UIColor(red: 0.75, green: 0.95, blue: 0.75, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(gakuenButton)
        view.addSubview(koishikawaButton)
        view.addSubview(footerLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            gakuenButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 150),
            gakuenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gakuenButton.widthAnchor.constraint(equalToConstant: 280),
            gakuenButton.heightAnchor.constraint(equalToConstant: 100),
            
            koishikawaButton.topAnchor.constraint(equalTo: gakuenButton.bottomAnchor, constant: 30),
            koishikawaButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            koishikawaButton.widthAnchor.constraint(equalTo: gakuenButton.widthAnchor),
            koishikawaButton.heightAnchor.constraint(equalTo: gakuenButton.heightAnchor),
            
            footerLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            footerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupActions() {
        gakuenButton.addTarget(self, action: #selector(selectHiroo), for: .touchUpInside)
        koishikawaButton.addTarget(self, action: #selector(selectKoishikawa), for: .touchUpInside)
    }
    
    private func animateEntrance() {
        [titleLabel, gakuenButton, koishikawaButton, footerLabel].forEach { $0.alpha = 0 }
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut) {
            self.titleLabel.alpha = 1
        }
        UIView.animate(withDuration: 1.0, delay: 0.4, options: .curveEaseOut) {
            self.gakuenButton.alpha = 1
        }
        UIView.animate(withDuration: 1.0, delay: 0.7, options: .curveEaseOut) {
            self.koishikawaButton.alpha = 1
        }
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseOut) {
            self.footerLabel.alpha = 1
        }
    }
    
    // MARK: - Bubble Animation
    private func spawnBubbles() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            self.createBubble()
        }
    }
    private func createBubble() {
        let size = CGFloat.random(in: 20...60)
        let startX = CGFloat.random(in: 0...(self.view.bounds.width - size))
        let startY = -size // start above the screen
        
        let bubble = UIView(frame: CGRect(x: startX, y: startY, width: size, height: size))
        
        // Mix of pastel colors for variety 🎨
        let colors: [UIColor] = [
            UIColor.systemGreen.withAlphaComponent(0.3),
            UIColor.white.withAlphaComponent(0.25),
            UIColor.systemMint.withAlphaComponent(0.3)
        ]
        bubble.backgroundColor = colors.randomElement()
        bubble.layer.cornerRadius = size / 2
        
        // Add bubble above gradient but below main UI
        self.view.insertSubview(bubble, at: 1)
        
        let duration = TimeInterval.random(in: 4...7)
        let endY = self.view.bounds.height + size
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn], animations: {
            bubble.frame.origin.y = endY
            bubble.alpha = 0.1
        }, completion: { _ in
            bubble.removeFromSuperview()
        })
    }
}

// MARK: - Game Style Button
class GameMenuButton: UIButton {
    init(title: String, color: UIColor, icon: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = color
        layer.cornerRadius = 22
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 3, height: 4)
        layer.shadowRadius = 6
        
        // Icon + text
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .bold)
        let image = UIImage(systemName: icon, withConfiguration: config)
        setImage(image, for: .normal)
        setTitle(" " + title, for: .normal)
        
        tintColor = .black
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        // Tap animation
        addTarget(self, action: #selector(animateTap), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateRelease), for: [.touchUpInside, .touchCancel, .touchDragExit])
    }
    
    @objc private func animateTap() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func animateRelease() {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
            self.transform = .identity
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
