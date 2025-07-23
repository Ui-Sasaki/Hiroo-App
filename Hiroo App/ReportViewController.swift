//
//  ReportViewController.swift
//  Hiroo App
//
//  Created by 井上　希稟 on 2025/07/09.
//

import UIKit
import FirebaseFirestore

class ReportViewController: UITableViewController {
    
    var reports: [OccupancyReport] = []
    let db = Firestore.firestore()
    let eventId = "qip9eEy4kLvQKqRb2xa3" // ← あなたのイベントIDに変更

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "混雑状況"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        fetchReports()
    }
    
    func fetchReports() {
        db.collection("event").document(eventId)
            .collection("report")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching reports: \(error)")
                    return
                }
                
                self.reports = snapshot?.documents.compactMap { doc -> OccupancyReport? in
                    try? doc.data(as: OccupancyReport.self)
                } ?? []
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }

    // MARK: - TableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let report = reports[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        cell.textLabel?.text = "👥 \(report.occupancy)人 - \(formatter.string(from: report.timestamp))"
        return cell
    }
}
