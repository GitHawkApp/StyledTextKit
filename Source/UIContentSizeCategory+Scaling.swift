//
//  UIContentSizeCategory+Scaling.swift
//  StyledTextKit
//
//  Created by Ryan Nystrom on 12/12/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit

internal extension UIContentSizeCategory {

    func scaledFontSize(forTextStyle style: UIFont.TextStyle) -> CGFloat {
        let scaledFont = UIFont.preferredFont(forTextStyle: style,
                                               compatibleWith: UITraitCollection(preferredContentSizeCategory: self))
        return scaledFont.pointSize
    }

    func approximateScaleFactor(forTextStyle style: UIFont.TextStyle) -> CGFloat {
        let defaultFontSize = UIContentSizeCategory.large.scaledFontSize(forTextStyle: style)
        return scaledFontSize(forTextStyle: style) / defaultFontSize
    }

}
