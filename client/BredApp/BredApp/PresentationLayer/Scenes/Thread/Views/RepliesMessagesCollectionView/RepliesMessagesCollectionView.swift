//
//  RepliesMessagesCollectionView.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 16.03.2024.
//

import UIKit

protocol RepliesMessagesCollectionViewDelegate: AnyObject {
    func didTapReplyMessageIdButton(messageId: Int)
}

class RepliesMessagesCollectionView: DynamicHeightCollectionView {
    
    // MARK: - Properties
    
    weak var customDelegate: RepliesMessagesCollectionViewDelegate?
    
    private var messagesIds: [Int] = []
    
    // MARK: - Initialization
    
    init() {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        layout.minimumInteritemSpacing = 3
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        super.init(frame: .zero, collectionViewLayout: layout)
        contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        dataSource = self
        delegate = self
        register(ReplyMessageCell.self, forCellWithReuseIdentifier: ReplyMessageCell.reuseIdentifier)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods

    override func layoutSubviews() {
        super.layoutSubviews()
        frame.size.height = contentSize.height
    }
    
    func setMessagesIds(_ messagesIds: [Int]) {
        self.messagesIds = messagesIds
        reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension RepliesMessagesCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messagesIds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReplyMessageCell.reuseIdentifier, for: indexPath) as! ReplyMessageCell
        cell.configure(with: messagesIds[indexPath.item])
        return cell
    }
}

extension RepliesMessagesCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        customDelegate?.didTapReplyMessageIdButton(messageId: messagesIds[indexPath.item])
    }
}
