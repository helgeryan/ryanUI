//
//  PartialTransparentView.swift
//  
//
//  Created by Ryan Helgeson on 7/13/23.
//

import Foundation
import UIKit

// MARK: - Class PartialTransparentView

class PartialTransparentView: UIView {
    var rectsArray: [CGRect]?

    convenience init(rectsArray: [CGRect]) {
        self.init()

        self.rectsArray = rectsArray

        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        isOpaque = false
    }

    override func draw(_ rect: CGRect) {
        backgroundColor?.setFill()
        UIRectFill(rect)

        guard let rectsArray = rectsArray else {
            return
        }

        for holeRect in rectsArray {
            let path = UIBezierPath(roundedRect: holeRect, cornerRadius: 10)

            let holeRectIntersection = rect.intersection(holeRect)

            UIRectFill(holeRectIntersection)

            UIColor.clear.setFill()
            UIGraphicsGetCurrentContext()?.setBlendMode(CGBlendMode.copy)
            path.fill()
        }
    }
}
