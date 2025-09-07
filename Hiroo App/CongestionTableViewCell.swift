//
//  CongestionTableViewCell.swift
//  Hiroo App
//
//  Created by 井上　希稟 on 2025/07/23.
//

import UIKit

final class CongestionTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let iconsStackView = UIStackView()
    private var personIcons: [UIImageView] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        // タイトルラベル
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 場所ラベル
        locationLabel.font = .systemFont(ofSize: 14)
        locationLabel.textColor = .secondaryLabel
        contentView.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // アイコンのスタックビュー
        iconsStackView.axis = .horizontal
        iconsStackView.alignment = .center
        iconsStackView.distribution = .equalSpacing
        iconsStackView.spacing = 8
        contentView.addSubview(iconsStackView)
        iconsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // アイコンを3つ生成
        for _ in 0..<3 {
            let iv = UIImageView(image: UIImage(systemName: "person.fill"))
            iv.contentMode = .scaleAspectFit
            iv.tintColor = .systemGray4
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
            iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
            iconsStackView.addArrangedSubview(iv)
            personIcons.append(iv)
        }
        
        // AutoLayout
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            locationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            iconsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    // 更新処理
    func configure(event: Event) {
        titleLabel.text = event.name
        locationLabel.text = event.location
        updateIcons(occupied: event.congestion, max: 3)
    }
    
    func updateIcons(occupied: Int, max: Int) {
        for (i, iv) in personIcons.enumerated() {
            iv.tintColor = (i < occupied) ? .systemRed : .systemGray4
        }
    }
}
