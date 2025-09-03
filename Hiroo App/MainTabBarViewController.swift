import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        print("E: MainTabBar viewDidLoad")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("F: MainTabBar viewDidAppear")
    }
    
    
    private func setupTabBar() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let firstVC = sb.instantiateViewController(withIdentifier: "MissingPersonViewController") as! MissingPersonViewController
        let secondVC = sb.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let thirdVC = sb.instantiateViewController(withIdentifier: "CongestionViewController") as! CongestionViewController
        let fourthVC = sb.instantiateViewController(withIdentifier: "TimeTableViewController") as! TimeTableViewController
        
        firstVC.tabBarItem = UITabBarItem(title: "Missing", image: UIImage(systemName: "person.fill.questionmark"), tag: 0)
        secondVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 1)
        thirdVC.tabBarItem = UITabBarItem(title: "Congestion", image: UIImage(systemName: "person.2.fill"), tag: 2)
        fourthVC.tabBarItem = UITabBarItem(title: "Timetable", image: UIImage(systemName: "clock"), tag: 3)
        viewControllers = [
            UINavigationController(rootViewController: firstVC),
            UINavigationController(rootViewController: secondVC),
            UINavigationController(rootViewController: thirdVC),
            UINavigationController(rootViewController: fourthVC),
        ]
    }
}
