//
//  Font.swift
//  StyledTextKit
//
//  Created by Ryan Nystrom on 2/19/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import UIKit

public enum Font: Hashable, Equatable {

    public enum SystemFont: Hashable, Equatable {
        case `default`
        case bold
        case italic
        case weighted(UIFont.Weight)
        case monospaced(UIFont.Weight)
    }

    case name(String)
    case descriptor(UIFontDescriptor)
    case system(SystemFont)

}
