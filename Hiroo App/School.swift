//
//  School.swift
//  Hiroo App
//
//  Created by 井上　希稟 on 2025/07/16.
//

import Foundation
enum School: String {
    case hiroo = "hiroo"
    case koishikawa = "hirookoishikawa"
}

extension UserDefaults {
    private static let key = "selectedSchool"
    var selectedSchool: School {
        get {
            if let raw = string(forKey: Self.key),
               let s = School(rawValue: raw) {
                return s
            }
            return .hiroo
        }
        set {
            set(newValue.rawValue, forKey: Self.key)
        }
    }
}
