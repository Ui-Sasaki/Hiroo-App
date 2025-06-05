import UIKit

class MainPage: UIViewController {

    private let headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "graduationcap.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "広尾"
        label.font = UIFont.systemFont(ofSize: 44, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "ようこそ！\n広尾の世界観ががここから始まる"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let welcomeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "welcome_ribbon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let gakuenButton = LogoButton(imageName: "HirooGakuen", title: "広尾学園")
    private let koishikawaButton = LogoButton(imageName: "HirooKoishikawa", title: "広尾小石川")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground

        setupUI()
        setupActions()
        animateEntrance()
    }

    private func setupUI() {
        view.addSubview(headerImage)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(welcomeImage)
        view.addSubview(gakuenButton)
        view.addSubview(koishikawaButton)

        NSLayoutConstraint.activate([
            headerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            headerImage.widthAnchor.constraint(equalToConstant: 60),
            headerImage.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            welcomeImage.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            welcomeImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeImage.widthAnchor.constraint(equalToConstant: 160),
            welcomeImage.heightAnchor.constraint(equalToConstant: 60),

            gakuenButton.topAnchor.constraint(equalTo: welcomeImage.bottomAnchor, constant: 60),
            gakuenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gakuenButton.widthAnchor.constraint(equalToConstant: 280),
            gakuenButton.heightAnchor.constraint(equalToConstant: 60),

            koishikawaButton.topAnchor.constraint(equalTo: gakuenButton.bottomAnchor, constant: 20),
            koishikawaButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            koishikawaButton.widthAnchor.constraint(equalTo: gakuenButton.widthAnchor),
            koishikawaButton.heightAnchor.constraint(equalTo: gakuenButton.heightAnchor)
        ])
    }

    private func setupActions() {
        gakuenButton.addTarget(self, action: #selector(openGakuen), for: .touchUpInside)
        koishikawaButton.addTarget(self, action: #selector(openKoishikawa), for: .touchUpInside)
    }

    @objc private func openGakuen() {
        print("Tapped 広尾学園") // for debug
        let vc = HirooGakuenViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func openKoishikawa() {
        print("Tapped 広尾小石川") // for debug
        let vc = HirooKoishikawaViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func animateEntrance() {
        view.subviews.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.8) {
            self.view.subviews.forEach { $0.alpha = 1 }
        }
    }
}

// MARK: - Custom UIButton with Centered Logo + Text
class LogoButton: UIButton {
    init(imageName: String, title: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 14
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.borderWidth = 1
        clipsToBounds = true

        // Make sure internal views don't block touches
        isUserInteractionEnabled = true

        let logo = UIImageView(image: UIImage(named: imageName))
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.widthAnchor.constraint(equalToConstant: 36).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 36).isActive = true
        logo.isUserInteractionEnabled = false

        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false

        let hStack = UIStackView(arrangedSubviews: [logo, label])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.isUserInteractionEnabled = false

        addSubview(hStack)

        NSLayoutConstraint.activate([
            hStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            hStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            hStack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
