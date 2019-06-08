//
//  StyledTextKitRenderCacheKey.swift
//  StyledTextKit
//
//  Created by Ryan Nystrom on 12/14/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit

internal struct StyledTextRenderCacheKey: Hashable, Equatable {

    let width: CGFloat
    let attributedText: NSAttributedString
    let backgroundColor: UIColor?
    let maximumNumberOfLines: Int?

}
