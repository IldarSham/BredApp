//
//  SettingsCell.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 24.03.2024.
//

import UIKit

struct SettingsCellModel {
    let optionName: String
    let color: UIColor
    
    init(optionName: String, color: UIColor = .black) {
        self.optionName = optionName
        self.color = color
    }
}

class SettingsCell: UITableViewCell {
    
    // MARK: - Properties
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constructHierarchy()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with model: SettingsCellModel) {
        optionLabel.text = model.optionName
        optionLabel.textColor = model.color
    }
    
    // MARK: - Private Methods
    
    private func constructHierarchy() {
        contentView.addSubview(optionLabel)
    }
    
    private func activateConstraints() {
        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            optionLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            optionLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            optionLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            optionLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
