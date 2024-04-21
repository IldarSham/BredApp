//
//  ReplyMessageCell.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 16.03.2024.
//

import UIKit

class ReplyMessageCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let messageIdLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 1, green: 0.4863111973, blue: 0, alpha: 1)
        label.font = UIFont(name: "Trebuchet MS", size: 12)
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        constructHierarchy()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with messageId: Int) {
        messageIdLabel.text = ">>\(messageId)"
    }
    
    // MARK: - Private Methods
    
    private func constructHierarchy() {
        contentView.addSubview(messageIdLabel)
    }
    
    private func activateConstraints() {
        messageIdLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            messageIdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            messageIdLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            messageIdLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
