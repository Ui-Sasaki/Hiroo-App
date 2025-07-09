//
//  Report.swift
//  Hiroo App
//
//  Created by 井上　希稟 on 2025/07/09.
//

import Foundation
import FirebaseFirestore
struct OccupancyReport: Identifiable, Codable {
    @DocumentID var id: String?
    var occupancy: Int
    var studentId: String
    var timestamp: Date
}
