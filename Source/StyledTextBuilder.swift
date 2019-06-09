//
//  StyledTextKitBuilder.swift
//  StyledTextKit
//
//  Created by Ryan Nystrom on 12/12/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation
import UIKit

public final class StyledTextBuilder: Hashable, Equatable {

    internal var styledTexts: [StyledText]
    internal var savedStyles = [TextStyle]()

    public convenience init(styledText: StyledText) {
        self.init(styledTexts: [styledText])
    }

    public convenience init(text: String) {
        self.init(styledText: StyledText(storage: .text(text)))
    }

    public convenience init(attributedText: NSAttributedString) {
        self.init(styledText: StyledText(storage: .attributedText(attributedText)))
    }

    public init(styledTexts: [StyledText]) {
        self.styledTexts = styledTexts
    }

    public var tipAttributes: NSAttributedStringAttributesType? {
        return styledTexts.last?.style.attributes
    }

    public var count: Int {
        return styledTexts.count
    }

    @discardableResult
    public func save() -> StyledTextBuilder {
        if let last = styledTexts.last?.style {
            savedStyles.append(last)
        }
        return self
    }

    @discardableResult
    public func restore() -> StyledTextBuilder {
        guard let last = savedStyles.last else { return self }
        savedStyles.removeLast()
        return add(styledText: StyledText(style: last))
    }

    @discardableResult
    public func add(styledTexts: [StyledText]) -> StyledTextBuilder {
        self.styledTexts += styledTexts
        return self
    }

    @discardableResult
    public func add(styledText: StyledText) -> StyledTextBuilder {
        return add(styledTexts: [styledText])
    }

    @discardableResult
    public func add(style: TextStyle) -> StyledTextBuilder {
        return add(styledText: StyledText(style: style))
    }

    @discardableResult
    public func add(
        text: String,
        traits: UIFontDescriptor.SymbolicTraits? = nil,
        attributes: NSAttributedStringAttributesType? = nil
        ) -> StyledTextBuilder {
        return add(storage: .text(text), traits: traits, attributes: attributes)
    }

    @discardableResult
    public func add(
        attributedText: NSAttributedString,
        traits: UIFontDescriptor.SymbolicTraits? = nil,
        attributes: NSAttributedStringAttributesType? = nil
        ) -> StyledTextBuilder {
        return add(storage: .attributedText(attributedText), traits: traits, attributes: attributes)
    }

    @discardableResult
    public func add(
        storage: StyledText.Storage = .text(""),
        traits: UIFontDescriptor.SymbolicTraits? = nil,
        attributes: NSAttributedStringAttributesType? = nil
        ) -> StyledTextBuilder {
        guard let tip = styledTexts.last else { return self }

        var nextAttributes = tip.style.attributes
        if let attributes = attributes {
            for (k, v) in attributes {
                nextAttributes[k] = v
            }
        }

        let nextStyle: TextStyle
        if let traits = traits {

            let tipFontDescriptor: UIFontDescriptor
            switch tip.style.font {
            case .descriptor(let descriptor): tipFontDescriptor = descriptor
            default: tipFontDescriptor = tip.style.font(contentSizeCategory: .medium).fontDescriptor
            }

            nextStyle = TextStyle(
                font: .descriptor(tipFontDescriptor.withSymbolicTraits(traits) ?? tipFontDescriptor),
                size: tip.style.size,
                attributes: nextAttributes,
                minSize: tip.style.minSize,
                maxSize: tip.style.maxSize
            )
        } else {
            nextStyle = TextStyle(
                font: tip.style.font,
                size: tip.style.size,
                attributes: nextAttributes,
                minSize: tip.style.minSize,
                maxSize: tip.style.maxSize
            )
        }

        return add(styledText: StyledText(storage: storage, style: nextStyle))
    }
    
    @discardableResult
    public func add(
        image: UIImage,
        options: [StyledText.ImageFitOptions] = [.fit, .center],
        attributes: NSAttributedStringAttributesType? = nil
        ) -> StyledTextBuilder {
        return add(storage: .image(image, options), attributes: attributes)
    }

    @discardableResult
    public func clearText() -> StyledTextBuilder {
        guard let tipStyle = styledTexts.last?.style else { return self }
        styledTexts.removeAll()
        return add(styledText: StyledText(style: tipStyle))
    }

    public func build(renderMode: StyledTextString.RenderMode = .trimWhitespaceAndNewlines) -> StyledTextString {
        return StyledTextString(styledTexts: styledTexts, renderMode: renderMode)
    }

    // MARK: Hashable

    public func hash(into hasher: inout Hasher) {
        styledTexts.forEach {
            hasher.combine($0)
        }
    }

    // MARK: Equatable

    public static func ==(lhs: StyledTextBuilder, rhs: StyledTextBuilder) -> Bool {
        return lhs === rhs
        || lhs.styledTexts == rhs.styledTexts
    }

}
