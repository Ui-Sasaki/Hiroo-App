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
    private static let schoolKey = "selectedSchool"
    private static let flagKey   = "hasSelectedSchool"

    var selectedSchool: School? {
        get {
            guard let raw = string(forKey: Self.schoolKey) else { return nil }
            return School(rawValue: raw)
        }
        set {
            if let s = newValue {
                set(s.rawValue, forKey: Self.schoolKey)
                set(true, forKey: Self.flagKey)
            } else {
                removeObject(forKey: Self.schoolKey)
                set(false, forKey: Self.flagKey)
            }
        }
    }

    var hasSelectedSchool: Bool {
        bool(forKey: Self.flagKey)
    }
}

extension School {
    var displayTitle: String {
        switch self {
        case .hiroo:        return "広尾学園"
        case .koishikawa:   return "広尾学園小石川"
        }
    }
    /// 画像アセットのファイル名（Assetsに入れておく）
    var carouselImages: [String] {
        switch self {
        case .hiroo:        return ["hiroo_1.JPG", "hiroo_2.JPG", "hiroo_3.JPG"]
        case .koishikawa:   return ["koishikawa_1.JPG", "koishikawa_1.JPG", "koishikawa_1.JPG"]
        }
    }
}
