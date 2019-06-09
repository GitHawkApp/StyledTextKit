//
//  StyledTextKitResult.swift
//  StyledTextKit
//
//  Created by Ryan Nystrom on 3/17/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import Foundation
import UIKit

public struct StyledTextString: Hashable, Equatable {

    public enum RenderMode {
        case trimWhitespaceAndNewlines
        case trimWhitespace
        case preserve
    }

    public let styledTexts: [StyledText]
    public let renderMode: RenderMode

    public init(styledTexts: [StyledText], renderMode: RenderMode = .trimWhitespaceAndNewlines) {
        self.styledTexts = styledTexts
        self.renderMode = renderMode
    }

    public var allText: String {
        return styledTexts.reduce("", { $0 + $1.text })
    }

    public func render(contentSizeCategory: UIContentSizeCategory) -> NSAttributedString {
        let result = NSMutableAttributedString()
        styledTexts.forEach { result.append($0.render(contentSizeCategory: contentSizeCategory)) }
        switch renderMode {
        case .trimWhitespaceAndNewlines: return result.trimCharactersInSet(charSet: CharacterSet.whitespacesAndNewlines)
        case .trimWhitespace: return result.trimCharactersInSet(charSet: CharacterSet.whitespaces)
        case .preserve: return result
        }
    }

}
