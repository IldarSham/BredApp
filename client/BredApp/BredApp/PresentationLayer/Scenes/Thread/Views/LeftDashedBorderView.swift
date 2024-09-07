//
//  LeftDashedBorderView.swift
//  BredApp
//
//  Created by Ildar Shamsullin on 06.09.2024.
//

import UIKit

class LeftDashedBorderView: UIView {
    
    // MARK: - Properties
    private let leftDashedBorderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.orange.cgColor
        layer.lineDashPattern = [6, 6]
        layer.fillColor = nil
        return layer
    }()
        
    // MARK: - Initialization
    init(lineWidth: CGFloat) {
        super.init(frame: .zero)
        leftDashedBorderLayer.lineWidth = lineWidth
        layer.addSublayer(leftDashedBorderLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        leftDashedBorderLayer.path = path.cgPath
    }
}
