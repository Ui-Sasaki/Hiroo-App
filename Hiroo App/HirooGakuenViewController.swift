import UIKit

class HirooGakuenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "広尾学園"
        setupIconButtons()
    }
    
    private func setupIconButtons() {
        let icons = [
            ("Missing", UIImage(systemName: "person.fill.questionmark")!.withRenderingMode(.alwaysTemplate), #selector(missingTapped)),
            ("Map", UIImage(systemName: "map")!.withRenderingMode(.alwaysTemplate), #selector(mapTapped)),
            ("Congestion", UIImage(systemName: "person.2.fill")!.withRenderingMode(.alwaysTemplate), #selector(congestionTapped)),
            ("Timetable", UIImage(systemName: "clock")!.withRenderingMode(.alwaysTemplate), #selector(timetableTapped))
        ]
        
        // Container with pill shape
        let containerView = UIView()
        containerView.backgroundColor = .systemGray6
        containerView.layer.cornerRadius = 25
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 340),
            containerView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Horizontal stack for icon groups
        let mainStack = UIStackView()
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.distribution = .equalSpacing
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
        
        for (title, image, action) in icons {
            let verticalStack = UIStackView()
            verticalStack.axis = .vertical
            verticalStack.alignment = .center
            verticalStack.spacing = 6
            verticalStack.translatesAutoresizingMaskIntoConstraints = false
            
            let button = UIButton(type: .system)
            button.setImage(image, for: .normal)
            button.tintColor = .black
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .white
            button.layer.cornerRadius = 12
            button.addTarget(self, action: action, for: .touchUpInside)
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 50),
                button.heightAnchor.constraint(equalToConstant: 50)
            ])
            
            let label = UILabel()
            label.text = title
            label.font = .systemFont(ofSize: 12)
            label.textAlignment = .center
            label.textColor = .label
            
            verticalStack.addArrangedSubview(button)
            verticalStack.addArrangedSubview(label)
            mainStack.addArrangedSubview(verticalStack)
        }
    }
    
    // MARK: - Actions
    
    @objc func missingTapped() {
        navigationController?.pushViewController(MissingPersonViewController(), animated: true)
    }
    
    @objc func mapTapped() {
        navigationController?.pushViewController(hiroomap(), animated: true)
    }
    
    @objc func congestionTapped() {
        navigationController?.pushViewController(CongestionViewController(), animated: true)
    }
    
    @objc func timetableTapped() {
        navigationController?.pushViewController(TimeTableViewController(), animated: true)
    }
}
