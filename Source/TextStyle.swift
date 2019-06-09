//
//  TextStyle.swift
//  StyledTextKit
//
//  Created by Ryan Nystrom on 12/12/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit

public struct TextStyle: Hashable, Equatable {

    public let font: Font
    public let size: CGFloat
    public let attributes: NSAttributedStringAttributesType
    public let minSize: CGFloat
    public let maxSize: CGFloat
    public let scalingTextStyle: UIFont.TextStyle

    public init(
        font: Font = .system(.default),
        size: CGFloat = UIFont.systemFontSize,
        attributes: NSAttributedStringAttributesType = [:],
        minSize: CGFloat = 0,
        maxSize: CGFloat = .greatestFiniteMagnitude,
        scalingTextStyle: UIFont.TextStyle = .body
        ) {
        self.font = font
        self.size = size
        self.attributes = attributes
        self.minSize = minSize
        self.maxSize = maxSize
        self.scalingTextStyle = scalingTextStyle
    }

    public func font(contentSizeCategory: UIContentSizeCategory) -> UIFont {
        let calculatedSize: CGFloat

        if #available(iOS 11.0, *) {
            let metrics = UIFontMetrics(forTextStyle: scalingTextStyle)
            calculatedSize = metrics.scaledValue(for: size, compatibleWith: UITraitCollection(preferredContentSizeCategory: contentSizeCategory))
        } else {
            calculatedSize = size * contentSizeCategory.approximateScaleFactor(forTextStyle: scalingTextStyle)
        }

        let preferredSize = min(max(calculatedSize, minSize), maxSize)

        switch font {
        case .name(let name):
            guard let font = UIFont(name: name, size: preferredSize) else {
                print("WARNING: Font with name \"\(name)\" not found. Falling back to system font.")
                return UIFont.systemFont(ofSize: preferredSize)
            }
            return font
        case .descriptor(let descriptor): return UIFont(descriptor: descriptor, size: preferredSize)
        case .system(let system):
            switch system {
            case .default: return UIFont.systemFont(ofSize: preferredSize)
            case .bold: return UIFont.boldSystemFont(ofSize: preferredSize)
            case .italic: return UIFont.italicSystemFont(ofSize: preferredSize)
            case .weighted(let weight): return UIFont.systemFont(ofSize: preferredSize, weight: weight)
            case .monospaced(let weight): return UIFont.monospacedDigitSystemFont(ofSize: preferredSize, weight: weight)
            }
        }
    }

}
