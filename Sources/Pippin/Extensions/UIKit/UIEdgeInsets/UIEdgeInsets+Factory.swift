//
//  UIEdgeInsets+Factory.swift
//  InformedConsent
//
//  Created by Andrew McKnight on 8/9/17.
//  Copyright © 2017 Insight Therapeutics. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

    public init(all value: CGFloat) {
        self.top = value
        self.bottom = value
        self.left = value
        self.right = value
    }

    public init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.top = vertical
        self.bottom = vertical
        self.left = horizontal
        self.right = horizontal
    }

    public func inset(topDelta: CGFloat = 0, leftDelta: CGFloat = 0, bottomDelta: CGFloat = 0, rightDelta: CGFloat = 0) -> UIEdgeInsets {
        return UIEdgeInsets(top: top + topDelta, left: left + leftDelta, bottom: bottom + bottomDelta, right: right + rightDelta)
    }

}
