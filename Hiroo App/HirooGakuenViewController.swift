import UIKit

class HirooGakuenViewController: UIViewController {

    private let tabBarVC = UITabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "広尾学園"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "<- Back",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )

        setupTabBar()
        embedTabBar()
    }

    @objc func backButtonTapped() {
        guard let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate else { return }

        let mainPage = MainPage()
        let nav = UINavigationController(rootViewController: mainPage)
        sceneDelegate.window?.rootViewController = nav
    }
    
    private func setupTabBar() {
        let firstVC = MissingPersonViewController()
        firstVC.tabBarItem = UITabBarItem(title: "Missing", image: UIImage(systemName: "person.fill.questionmark"), tag: 0)

        let secondVC = hiroomap()
        secondVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 1)

        let thirdVC = CongestionViewController()
        thirdVC.tabBarItem = UITabBarItem(title: "Congestion", image: UIImage(systemName: "person.2.fill"), tag: 2)

        let fourthVC = TimeTableViewController()
        fourthVC.tabBarItem = UITabBarItem(title: "Timetable", image: UIImage(systemName: "clock"), tag: 3)

        tabBarVC.setViewControllers([firstVC, secondVC, thirdVC, fourthVC], animated: false)
    }

    private func embedTabBar() {
        addChild(tabBarVC)
        view.addSubview(tabBarVC.view)
        tabBarVC.view.frame = view.bounds
        tabBarVC.didMove(toParent: self)
    }
}
