//
//  CreateMessageCell.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 05.03.2024.
//

import UIKit

class CreateMessageCell: UITableViewCell {
    
    // MARK: - Properties
    
    private(set) var createMessageButton: UIButton = {
        let button = ContentExpandingButton(type: .roundedRect)
        button.contentExpansion = CGSize(width: 20, height: 10)
        button.setTitle(L.ThreadScreen.createMessageButton.localized, for: .normal)
        let titleColor = #colorLiteral(red: 1, green: 0.4, blue: 0, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "PT Sans Bold", size: 20)
        button.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        button.layer.cornerRadius = 3.0
        button.layer.borderWidth = 1.5
        button.layer.borderColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        return button
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        constructHierarchy()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func constructHierarchy() {
        contentView.addSubview(createMessageButton)
    }
    
    private func activateConstraints() {
        createMessageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createMessageButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            createMessageButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            createMessageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
}
