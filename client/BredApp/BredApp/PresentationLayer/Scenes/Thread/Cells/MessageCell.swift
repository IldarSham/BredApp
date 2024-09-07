//
//  MessageCell.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 04.03.2024.
//

import UIKit

struct MessageCellModel {
    let isOwnMessage: Bool
    let isReplyToYourMessage: Bool
    let username: String
    let date: String
    let messageId: Int
    let messageNumber: Int
    let photoCellData: [PhotoCellModel]?
    let content: String
    let repliesByIds: [Int]?
}

class MessageCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var didTapMessageIdButton: (() -> Void)?
    
    private lazy var messageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [messageDetailsStackView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.layer.cornerRadius = 3.0
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.masksToBounds = true
        return stackView
    }()
    
    private lazy var leftBorderView: UIView = {
        let leftBorder = UIView()
        leftBorder.backgroundColor = UIColor.orange
        return leftBorder
    }()
    
    private lazy var leftDashedBorderView = LeftDashedBorderView(lineWidth: 4.5)

    private lazy var messageDetailsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, dateLabel, messageIdButton, messageNumberLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Trebuchet MS", size: 12)
        label.textColor = #colorLiteral(red: 0.3647058824, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Trebuchet MS", size: 12)
        label.textColor = #colorLiteral(red: 0.3647058824, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
        return label
    }()
    
    private lazy var messageIdButton: UIButton = {
        let button = ContentSizeButton()
        button.titleLabel?.font = UIFont(name: "Trebuchet MS", size: 12)
        let titleColor = #colorLiteral(red: 0.3647058824, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.addTarget(self, action: #selector(handleMessageIdButtonTap), for: .touchUpInside)
        return button
    }()
    
    private let messageNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Trebuchet MS", size: 12)
        label.textColor = #colorLiteral(red: 0.4705882353, green: 0.6, blue: 0.1333333333, alpha: 1)
        label.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        return label
    }()
    
    private lazy var photoCollectionView = PhotoCollectionView()
    
    private lazy var textView = CustomTextView()
    
    private lazy var repliesMessagesCollectionView = RepliesMessagesCollectionView()
    
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
    
    // MARK: - Public Methods

    override func prepareForReuse() {
        super.prepareForReuse()
        leftBorderView.removeFromSuperview()
        leftDashedBorderView.removeFromSuperview()
        photoCollectionView.removeFromSuperview()
        textView.removeFromSuperview()
        repliesMessagesCollectionView.removeFromSuperview()
    }

    func configure(
        with model: MessageCellModel,
        delegate: MessageCellDelegate,
        onTapMessageIdButton: @escaping () -> Void
    ) {
        /// Set message appearance
        if model.messageNumber == 1 {
            setStyleForFirstMessage()
        } else if model.isOwnMessage {
            setStyleForOwnMessage()
        } else if model.isReplyToYourMessage {
            setStyleForReplyToYourMessage()
        } else {
            setStyleForOtherMessage()
        }

        /// Configure message details
        usernameLabel.text = model.username
        dateLabel.text = model.date
        messageIdButton.setTitle("№\(model.messageId)", for: .normal)
        messageNumberLabel.text = "\(model.messageNumber)"
        
        /// Configure PhotoCollectionView
        if let photoCellData = model.photoCellData {
            messageStackView.addArrangedSubview(photoCollectionView)
            photoCollectionView.setData(photoCellData)
            photoCollectionView.customDelegate = delegate
        }
        
        /// Configure TextView
        messageStackView.addArrangedSubview(textView)
        textView.text = model.content
        textView.customDelegate = delegate
            
        /// Configure RepliesMessagesCollectionView
        if let repliesByIds = model.repliesByIds {
            messageStackView.addArrangedSubview(repliesMessagesCollectionView)
            repliesMessagesCollectionView.setMessagesIds(repliesByIds)
            repliesMessagesCollectionView.customDelegate = delegate
        }
        
        didTapMessageIdButton = onTapMessageIdButton
        
        messageStackView.layoutIfNeeded()
    }
    
    func select() {
        self.messageStackView.alpha = 0.1
        
        UIView.animate(withDuration: 1.0) {
            self.messageStackView.alpha = 1.0
        }
    }

    // MARK: - Private Methods
    
    private func constructHierarchy() {
        contentView.addSubview(messageStackView)
    }
    
    @objc
    private func handleMessageIdButtonTap() {
        didTapMessageIdButton?()
    }
}

// MARK: - Appearance
extension MessageCell {
    
    func setStyleForFirstMessage() {
        messageStackView.backgroundColor = .clear
    }
    
    func setStyleForOwnMessage() {
        messageStackView.backgroundColor = #colorLiteral(red: 0.9485717416, green: 0.8699709773, blue: 0.8173323274, alpha: 1)
        messageStackView.layoutMargins.left = 7.0
        messageStackView.addSubview(leftBorderView)
        activateConstraintsLeftBorderView()
    }
    
    func setStyleForReplyToYourMessage() {
        messageStackView.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        messageStackView.layoutMargins.left = 7.0
        messageStackView.addSubview(leftDashedBorderView)
        activateConstraintsLeftDashedBorderView()
    }
    
    func setStyleForOtherMessage() {
        messageStackView.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
    }
}

// MARK: - Layout
extension MessageCell {
    
    private func activateConstraintsLeftBorderView() {
        leftBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftBorderView.leadingAnchor.constraint(equalTo: messageStackView.leadingAnchor),
            leftBorderView.widthAnchor.constraint(equalToConstant: 2),
            leftBorderView.topAnchor.constraint(equalTo: messageStackView.topAnchor),
            leftBorderView.bottomAnchor.constraint(equalTo: messageStackView.bottomAnchor),
        ])
    }
    
    private func activateConstraintsLeftDashedBorderView() {
        leftDashedBorderView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leftDashedBorderView.leadingAnchor.constraint(equalTo: messageStackView.leadingAnchor),
            leftDashedBorderView.topAnchor.constraint(equalTo: messageStackView.topAnchor),
            leftDashedBorderView.bottomAnchor.constraint(equalTo: messageStackView.bottomAnchor),
        ])
    }
    
    private func activateConstraints() {
        messageStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            messageStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            messageStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            messageStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
        ])
    }
}

protocol MessageCellDelegate: PhotoCollectionViewDelegate, CustomTextViewDelegate, RepliesMessagesCollectionViewDelegate {}
