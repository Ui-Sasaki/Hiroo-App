import UIKit
import UserNotifications

struct Event {
    let id: String
    let title: String
    let startDate: Date
    var isFavorite: Bool = false
}

class TimeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let segmentedControl = UISegmentedControl(items: ["アリーナ", "サブアリーナ", "ステージ"])
    let tableView = UITableView()
    let redLineView = UIView()
    var redLineTimer: Timer?

    var events: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "広尾学園"

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }

        setupSegmentedControl()
        setupTableView()
        setupRedLine()
        loadDummyEvents()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startRedLineTimer()
        scrollToRedLine()
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
        redLineTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.updateRedLinePosition()
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

        redLineView.frame = CGRect(
            x: 60,
            y: offset,
            width: tableView.frame.width - 60,
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

    func loadDummyEvents() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"

        let startTime = formatter.date(from: "2025/07/10 09:00")!
        var generatedEvents: [Event] = []

        for i in 0..<30 {
            let eventTime = Calendar.current.date(byAdding: .minute, value: i * 30, to: startTime)!
            let title = (i % 2 == 0) ? "オープニング" : "ライブ"
            generatedEvents.append(Event(id: "\(i)", title: title, startDate: eventTime))
        }

        events = generatedEvents
        tableView.reloadData()
    }

    @objc func tabChanged() {
        print("Switched to tab \(segmentedControl.selectedSegmentIndex)")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        cell.configure(with: event)
        cell.onStarTapped = { [weak self] in
            self?.handleStarTapped(for: event)
        }
        return cell
    }

    func handleStarTapped(for event: Event) {
        if event.isFavorite {
            let alert = UIAlertController(title: "お気に入りを解除しますか？", message: "通知も取り消されます", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
            alert.addAction(UIAlertAction(title: "解除", style: .destructive, handler: { _ in
                if let index = self.events.firstIndex(where: { $0.id == event.id }) {
                    self.events[index].isFavorite = false
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [event.id])
                    self.tableView.reloadData()
                }
            }))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "お気に入りに登録しますか？", message: "イベントの10分前に通知します", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
            alert.addAction(UIAlertAction(title: "登録", style: .default, handler: { _ in
                if let index = self.events.firstIndex(where: { $0.id == event.id }) {
                    self.events[index].isFavorite = true
                    self.scheduleNotification(for: self.events[index])
                    self.tableView.reloadData()
                }
            }))
            present(alert, animated: true)
        }
    }

    func scheduleNotification(for event: Event) {
        let content = UNMutableNotificationContent()
        content.title = "イベントのお知らせ"
        content.body = "\(event.title) がもうすぐ始まります！"
        content.sound = .default

        let triggerDate = event.startDate.addingTimeInterval(-600)
        let triggerTime = max(triggerDate.timeIntervalSinceNow, 1)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerTime, repeats: false)

        let request = UNNotificationRequest(identifier: event.id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule: \(error)")
            }
        }
    }
}

// MARK: - Custom Cell

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

    func configure(with event: Event) {
        titleLabel.text = event.title
        timeLabel.text = event.startDate.formatted(date: .omitted, time: .shortened)

        if event.isFavorite {
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
