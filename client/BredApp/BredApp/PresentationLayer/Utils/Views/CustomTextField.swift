//
//  CustomTextField.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 24.12.2023.
//

import UIKit

class CustomTextField: UITextField {
    
    // MARK: - Properties
    
    /// Increase the size vertically to reserve space for the bottom line
    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: super.intrinsicContentSize.width,
            height: super.intrinsicContentSize.height + Constants.paddingForBottomLine
        )
    }
    
    private let separatorView: UIView = {
        let view = SeparatorView()
        view.backgroundColor = .orange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var placeholder: String? {
        get { super.placeholder }
        set { setPlaceholder(newValue) }
    }
    
    var lineColor: UIColor? {
        get { separatorView.backgroundColor }
        set { separatorView.backgroundColor = newValue }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.contentVerticalAlignment = .top
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Setup
    
    func setupUI() {
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.widthAnchor.constraint(equalTo: self.widthAnchor),
            separatorView.topAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setPlaceholder(_ placeholder: String?) {
        guard let placeholder = placeholder else { return }
        
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)]
        )
    }
}

// MARK: - Constants
extension CustomTextField {
    
    enum Constants {
        static let paddingForBottomLine: CGFloat = 10
    }
}
