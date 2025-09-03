//
//  CongestionViewController.swift
//  Hiroo App
//
//  Created by 井上　希稟 on 2025/07/23.
//

// 混雑状況を表示するViewController
import UIKit
import SideMenu

class CongestionViewController: UIViewController {
        let tableView = UITableView()
        let titleLabel = UILabel()
        
        private var booths: [Event] = []
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            loadBooths()
        }
    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemBackground
            
            titleLabel.font = .preferredFont(forTextStyle: .title2)
            titleLabel.numberOfLines = 0
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.backgroundColor = .red
            
            view.addSubview(titleLabel)
            view.addSubview(tableView)
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
                titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                
                tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
            
            configureTableView()
            loadBooths()
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "line.horizontal.3"),
                style: .plain,
                target: self,
                action: #selector(openMenu)
            )
        }
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            view.addSubview(titleLabel)
//                    view.addSubview(tableView)
//            configureTableView()
//            loadBooths()
//            navigationItem.leftBarButtonItem = UIBarButtonItem(
//                image: UIImage(systemName: "line.horizontal.3"),
//                style: .plain,
//                target: self,
//                action: #selector(openMenu)
//            )
//        }
        
        @objc private func openMenu() {
            if let menu = SideMenuManager.default.leftMenuNavigationController {
                present(menu, animated: true, completion: nil)
            }
        }
        
        private func configureTableView() {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "CongestionTableViewCell", bundle: nil), forCellReuseIdentifier: "CongestionCell")
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 80
        }
        private func loadBooths() {
            let school = UserDefaults.standard.selectedSchool
            titleLabel.text = (school == .hiroo)
            ? "広尾学園のイベント"
            : "広尾学園小石川のイベント"
            FirestoreManager.shared.fetchBoothEvents(for: school) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let list):
                    self.booths = list
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("error: \(error)")
                }
            }
        }
    }

// MARK: - UITableViewDataSource
extension CongestionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let count = booths.count
        return count
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CongestionCell",
            for: indexPath
        ) as! CongestionTableViewCell
        let event = booths[indexPath.row]
        cell.titleLabel.text = event.name
        cell.locationLabel.text = "場所: \(event.location)"
        
        let maxIcons = 3
        cell.updateIcons(occupied: event.congestion, max: maxIcons)
        return cell
    }
}
// MARK: - UITableViewDelegate
extension CongestionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let event  = booths[indexPath.row]
        let school = UserDefaults.standard.selectedSchool
        
        // DetailVC をインスタンス化してパラメータを渡し、push
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = sb
            .instantiateViewController(
                withIdentifier: "BoothDetailViewController"
            ) as? BoothDetailViewController
        else { return }
        
        detailVC.event  = event
        detailVC.school = school
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
