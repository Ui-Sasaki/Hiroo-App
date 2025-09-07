//
//  TimeTableViewController.swift
//  Hiroo App
//
//  Created by 井上　希稟 on 2025/07/23.
//

import UIKit
import UserNotifications

// MARK: - TimeTableViewController
class TimeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let segmentedControl = UISegmentedControl(items: ["アリーナ", "サブアリーナ", "ステージ"])
    let tableView = UITableView()
    let redLineView = UIView()
    var redLineTimer: Timer?

    var events: [Event] = []
    private var allEvents: [Event] = []

    private let favoriteKey = "favoriteEventIDs"
    private var favoriteIDs: Set<String> {
        get {
            let arr = UserDefaults.standard.array(forKey: favoriteKey) as? [String] ?? []
            return Set(arr)
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: favoriteKey)
        }
    }
    private func isFavorite(_ id: String) -> Bool { favoriteIDs.contains(id) }
    private func setFavorite(_ on: Bool, for id: String) {
        if on { favoriteIDs.insert(id) } else { favoriteIDs.remove(id) }
    }
    private func toggleFavorite(_ id: String) -> Bool {
        if favoriteIDs.contains(id) {
            favoriteIDs.remove(id)
            return false
        } else {
            favoriteIDs.insert(id)
            return true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Timetable"

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, error in
            if let error = error { print("Notification permission error:", error) }
        }

        setupSegmentedControl()
        setupTableView()
        setupRedLine()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(openFavorites)
        )

        loadEvents()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startRedLineTimer()
        scrollToRedLine()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        redLineTimer?.invalidate()
    }

    func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(tabChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupRedLine() {
        redLineView.backgroundColor = .red
        redLineView.frame.size.height = 2
        redLineView.layer.zPosition = 999
        tableView.addSubview(redLineView)
    }


    func startRedLineTimer() {
        redLineTimer?.invalidate()
        redLineTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateRedLinePosition()
        }
        updateRedLinePosition()
    }

    func updateRedLinePosition() {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)

        let startHour = 9
        let blockDurationMinutes = 30
        let rowHeight: CGFloat = 60

        let totalMinutes = CGFloat((hour - startHour) * 60 + minute)
        let offset = (totalMinutes / CGFloat(blockDurationMinutes)) * rowHeight

        let x: CGFloat = 60
        redLineView.frame = CGRect(
            x: x,
            y: max(0, offset),
            width: tableView.frame.width - x,
            height: 2
        )
    }

    func scrollToRedLine() {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)

        let startHour = 9
        let blockDurationMinutes = 30
        let rowHeight: CGFloat = 60

        let totalMinutes = CGFloat((hour - startHour) * 60 + minute)
        let offset = (totalMinutes / CGFloat(blockDurationMinutes)) * rowHeight

        let yOffset = max(0, offset - 200)
        tableView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
    }

    private func loadEvents() {
        let school = UserDefaults.standard.selectedSchool ?? .hiroo
        FirestoreManager.shared.fetchevents(for: school) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                self.allEvents = list
                DispatchQueue.main.async {
                    self.updateFilterAndReload()
                    self.startRedLineTimer()
                    self.scrollToRedLine()
                }
            case .failure(let error):
                print("fetch error:", error)
            }
        }
    }

    private func updateFilterAndReload() {
        let selected = segmentedControl.selectedSegmentIndex
        let key: String? = {
            switch selected {
            case 0: return "アリーナ"
            case 1: return "サブアリーナ"
            case 2: return "ステージ"
            default: return nil
            }
        }()

        var filtered = allEvents
        if let key = key {
            filtered = filtered.filter { $0.location == key }
        }
        filtered.sort { $0.startTime < $1.startTime }

        self.events = filtered
        self.tableView.reloadData()

        if events.isEmpty {
            let label = UILabel()
            label.text = "イベントがありません"
            label.textAlignment = .center
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
    }

    func scheduleNotification(for event: Event) {
        let content = UNMutableNotificationContent()
        content.title = "イベントのお知らせ"
        content.body = "\(event.name) がもうすぐ始まります！"
        content.sound = .default

        let triggerDate = event.startTime.addingTimeInterval(-600) // 10分前
        let triggerTime = max(triggerDate.timeIntervalSinceNow, 1)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerTime, repeats: false)

        let request = UNNotificationRequest(identifier: event.id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule:", error)
            }
        }
    }

    @objc func tabChanged() {
        updateFilterAndReload()
        scrollToRedLine()
    }

    @objc func openFavorites() {
        let favs = allEvents
            .filter { isFavorite($0.id) }
            .sorted { $0.startTime < $1.startTime }
        let vc = FavoritesViewController()
        vc.favoriteEvents = favs
        vc.onUnstar = { [weak self] event in
            guard let self = self else { return }
            self.setFavorite(false, for: event.id)
            self.updateFilterAndReload()
        }
        navigationController?.pushViewController(vc, animated: true)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { events.count }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 60 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        cell.configure(with: event, isFavorite: isFavorite(event.id))
        cell.onStarTapped = { [weak self, weak cell] in
            guard let self = self else { return }
            let nowFav = self.toggleFavorite(event.id)
            cell?.updateStar(isFavorite: nowFav)

            if nowFav {
                self.scheduleNotification(for: event)
            } else {
                UNUserNotificationCenter.current()
                    .removePendingNotificationRequests(withIdentifiers: [event.id])
            }
        }
        return cell
    }
}


// MARK: - EventCell
class EventCell: UITableViewCell {

    let timeLabel = UILabel()
    let cardView = UIView()
    let titleLabel = UILabel()
    let starButton = UIButton(type: .system)
    var divider: UIView = UIView()

    var onStarTapped: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        timeLabel.font = .systemFont(ofSize: 12)
        timeLabel.textColor = .gray
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeLabel)

        cardView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cardView.layer.cornerRadius = 12
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)

        starButton.setImage(UIImage(systemName: "star"), for: .normal)
        starButton.translatesAutoresizingMaskIntoConstraints = false
        starButton.addTarget(self, action: #selector(starTapped), for: .touchUpInside)
        cardView.addSubview(starButton)

        divider.backgroundColor = .black
        divider.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(divider)

        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            timeLabel.widthAnchor.constraint(equalToConstant: 45),

            cardView.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 8),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),

            starButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            starButton.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),

            divider.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    func configure(with event: Event, isFavorite: Bool) {
        titleLabel.text = event.name
        timeLabel.text = event.startTime.formatted(date: .omitted, time: .shortened)
        updateStar(isFavorite: isFavorite)
    }

    func updateStar(isFavorite: Bool) {
        if isFavorite {
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            starButton.tintColor = .systemYellow
        } else {
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            starButton.tintColor = .black
        }
    }

    @objc func starTapped() {
        onStarTapped?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - FavoritesViewController
class FavoritesViewController: UITableViewController {

    var favoriteEvents: [Event] = []
    var onUnstar: ((Event) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "お気に入り"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteEvents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = favoriteEvents[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let timeText = event.startTime.formatted(date: .omitted, time: .shortened)
        cell.textLabel?.text = "\(timeText) - \(event.name)"
        cell.accessoryType = .checkmark
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = favoriteEvents[indexPath.row]

        let alert = UIAlertController(title: "お気に入りを解除しますか？", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        alert.addAction(UIAlertAction(title: "解除", style: .destructive, handler: { _ in
            self.favoriteEvents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.onUnstar?(event)
        }))
        present(alert, animated: true)
    }
}
