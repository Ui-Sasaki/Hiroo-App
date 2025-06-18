import UIKit

struct ScheduleItem {
    let time: String
    let description: String?
}

class ScheduleCell: UITableViewCell {
    
    static let identifier = "ScheduleCell"
    
    private let clockIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "clock"))
        iv.tintColor = .gray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let verticalLine: UIView = {
        let line = UIView()
        line.backgroundColor = .systemGray4
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(verticalLine)
        contentView.addSubview(clockIcon)
        contentView.addSubview(timeLabel)
        contentView.addSubview(detailLabel)
        
        NSLayoutConstraint.activate([
            verticalLine.widthAnchor.constraint(equalToConstant: 1),
            verticalLine.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            verticalLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            
            clockIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            clockIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            clockIcon.widthAnchor.constraint(equalToConstant: 16),
            clockIcon.heightAnchor.constraint(equalToConstant: 16),
            
            timeLabel.leadingAnchor.constraint(equalTo: clockIcon.trailingAnchor, constant: 16),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            detailLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            detailLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: ScheduleItem) {
        timeLabel.text = item.time
        detailLabel.text = item.description
        detailLabel.isHidden = item.description == nil
    }
}

class TimeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    
    private let schedule: [ScheduleItem] = [
        .init(time: "8:00 AM", description: nil),
        .init(time: "8:15 AM", description: nil),
        .init(time: "8:30 AM", description: nil),
        .init(time: "8:40 AM", description: "Student Sales"),
        .init(time: "9:00 AM", description: nil),
        .init(time: "9:15 AM", description: nil),
        .init(time: "9:30 AM", description: "Start accepting visitors"),
        .init(time: "9:45 AM", description: nil),
        .init(time: "10:00 AM", description: "Second day begins"),
        .init(time: "10:15 AM", description: nil),
        .init(time: "10:30 AM", description: nil),
        .init(time: "10:45 AM", description: nil),
        .init(time: "11:00 AM", description: nil),
        .init(time: "11:15 AM", description: nil),
        .init(time: "11:30 AM", description: nil),
        .init(time: "11:45 AM", description: nil),
        .init(time: "12:00 PM", description: nil),
        .init(time: "12:15 PM", description: nil),
        .init(time: "12:30 PM", description: nil),
        .init(time: "12:45 PM", description: nil),
        .init(time: "1:00 PM", description: nil),
        .init(time: "1:15 PM", description: nil),
        .init(time: "1:30 PM", description: nil),
        .init(time: "1:45 PM", description: nil),
        .init(time: "2:00 PM", description: nil),
        .init(time: "2:15 PM", description: nil),
        .init(time: "2:30 PM", description: nil),
        .init(time: "2:45 PM", description: nil),
        .init(time: "3:00 PM", description: "Second day ends"),
        .init(time: "3:15 PM", description: nil),
        .init(time: "3:30 PM", description: nil),
        .init(time: "3:45 PM", description: nil),
        .init(time: "3:45–4:00 PM", description: "Closing ceremony")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Schedule"
        view.backgroundColor = .systemBackground
        
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.identifier, for: indexPath) as? ScheduleCell else {
            return UITableViewCell()
        }
        cell.configure(with: schedule[indexPath.row])
        return cell
    }
}
