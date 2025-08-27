//
//  CongestionTableViewCell.swift
//  Hiroo App
//
//  Created by 井上　希稟 on 2025/07/23.
//

import UIKit
class CongestionTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var iconsStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateIcons(occupied: Int, max: Int) {
        for (i, v) in iconsStackView.arrangedSubviews.enumerated() {
            guard let iv = v as? UIImageView else { continue }
            iv.image = UIImage(systemName: "person.fill")
            iv.tintColor = (i < occupied)
            ? .systemRed
            : .systemGray4
        }
    }
}

