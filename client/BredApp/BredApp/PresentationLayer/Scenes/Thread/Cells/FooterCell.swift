//
//  FooterCell.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 22.03.2024.
//

import UIKit

class FooterCell: UITableViewCell {
    
    // MARK: - Properties
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backButton, topButton, refreshButton])
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private(set) lazy var backButton: UIButton = {
        return makeButton(title: L.ThreadScreen.backButton.localized,
                          fontSize: 10,
                          contentExpansion: CGSize(width: 20, height: 5))
    }()
    
    private(set) lazy var topButton: UIButton = {
        return makeButton(title:  L.ThreadScreen.topButton.localized,
                          fontSize: 10,
                          contentExpansion: CGSize(width: 20, height: 5))
    }()
    
    private(set) lazy var refreshButton: UIButton = {
        return makeButton(title: L.ThreadScreen.refreshButton.localized,
                          fontSize: 10,
                          contentExpansion: CGSize(width: 20, height: 5))
    }()
    
    private(set) lazy var createMessageButton: UIButton = {
        return makeButton(title: L.ThreadScreen.createMessageButton.localized,
                          fontSize: 20,
                          contentExpansion: CGSize(width: 20, height: 10))
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
        contentView.addSubview(stackView)
        contentView.addSubview(createMessageButton)
    }
    
    private func activateConstraints() {
        activateConstraintsStackView()
        activateConstraintsCreateMessageButton()
    }
    
    private func activateConstraintsStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
        ])
    }
    
    private func activateConstraintsCreateMessageButton() {
        createMessageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createMessageButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            createMessageButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5),
            createMessageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    private func makeButton(title: String, fontSize: CGFloat, contentExpansion: CGSize) -> UIButton {
        let button = ContentExpandingButton(type: .roundedRect)
        button.contentExpansion = contentExpansion
        button.setTitle(title, for: .normal)
        let titleColor = #colorLiteral(red: 1, green: 0.4, blue: 0, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "PT Sans Bold", size: fontSize)
        button.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        button.layer.cornerRadius = 3.0
        button.layer.borderWidth = 1.5
        button.layer.borderColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        return button
    }
}
