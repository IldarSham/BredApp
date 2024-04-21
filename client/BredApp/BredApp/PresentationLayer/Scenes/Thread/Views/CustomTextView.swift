//
//  CustomTextView.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 15.03.2024.
//

import UIKit

protocol CustomTextViewDelegate: AnyObject {
    func didSelectLink(_ link: CustomTextView.LinkType)
}

class CustomTextView: UITextView {
    
    // MARK: - Properties
    
    weak var customDelegate: CustomTextViewDelegate?
    
    override var text: String? {
        get { attributedText.string }
        set { setText(newValue) }
    }
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero, textContainer: .none)
        isEditable = false
        isSelectable = false
        isScrollEnabled = false
        linkTextAttributes = Constants.linkTextAttributes
        backgroundColor = .clear

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setText(_ text: String?) {
        guard let text = text else { return }
        do {
            attributedText = try resolveMessagesIds(in: text)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Gesture
    
    @objc
    private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let textView = gestureRecognizer.view as? UITextView else { return }
        guard let position = textView.closestPosition(to: gestureRecognizer.location(in: textView)) else { return }
        if let link = textView.textStyling(at: position, in: .forward)?[NSAttributedString.Key.link] {
            guard let link = LinkType(link: link as! String) else { return }
            customDelegate?.didSelectLink(link)
        }
    }
    
    // MARK: - Private Methods
    
    private func resolveMessagesIds(in text: String) throws -> NSAttributedString {
        let attr = NSAttributedString(string: text, attributes: Constants.textAttributes)
        let attrString = NSMutableAttributedString(attributedString: attr)
        let regex = try NSRegularExpression(pattern: "\\b>>\\d+\\b", options: [.useUnicodeWordBoundaries])
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        for match in matches {
            if let range = Range(match.range, in: text) {
                let messageId = text[range].trimmingCharacters(in: CharacterSet(charactersIn: ">>"))
                if let id = Int(messageId) {
                    attrString.addAttribute(.link,
                                            value: LinkType.message(id: id).asString,
                                            range: NSRange(range, in: text))
                }
            }
        }
        return attrString
    }
}

// MARK: - LinkType
extension CustomTextView {
    
    enum LinkType {
        case message(id: Int)
        
        init?(link: String) {
            let components = link.split(separator: ":")
            switch components[0] {
            case "message":
                guard let id = Int(components[1]) else {
                    return nil
                }
                self = .message(id: id)
            default:
                return nil
            }
        }
        
        var asString: String {
            switch self {
            case .message(let id):
                return "message:\(id)"
            }
        }
    }
}

// MARK: - Constants
extension CustomTextView {
    
    enum Constants {
        static let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
            .font: UIFont(name: "Trebuchet MS", size: 15)!]
        
        static let linkTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: #colorLiteral(red: 1, green: 0.4863291383, blue: 0, alpha: 1),
            .font: UIFont(name: "Trebuchet MS", size: 15)!]
    }
}
