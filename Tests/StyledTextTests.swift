//
//  StyledTextKitTests.swift
//  StyledTextKitTests
//
//  Created by Ryan Nystrom on 12/12/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import XCTest
@testable import StyledTextKit

class StyledTextTests: XCTestCase {
    
    func test_renderingStyledText_fromString_toAttributedString() {
        let style = TextStyle(
            size: 12,
            attributes: [.foregroundColor: UIColor.white]
        )
        let text = StyledText(storage: .text("foo"), style: style)
        let render = text.render(contentSizeCategory: .large)
        XCTAssertEqual(render.string, "foo")

        let attributes = render.attributes(at: 1, effectiveRange: nil)
        XCTAssertEqual(attributes[.foregroundColor] as! UIColor, UIColor.white)

        let font = attributes[.font] as! UIFont
        XCTAssertEqual(font.familyName, UIFont.systemFont(ofSize: 1).familyName)
        XCTAssertEqual(font.pointSize, 12)
    }

    func test_renderingStyledText_fromNSAttributedString_toAttributedString() {
        let style = TextStyle(
            size: 12,
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 10),
            ]
        )
        let attributedString = NSAttributedString(string: "foo", attributes: [
            .foregroundColor: UIColor.red,
            .font: UIFont.boldSystemFont(ofSize: 20),
            ])
        let text = StyledText(storage: .attributedText(attributedString), style: style)
        let render = text.render(contentSizeCategory: .large)
        XCTAssertEqual(render.string, "foo")

        let attributes = render.attributes(at: 1, effectiveRange: nil)
        XCTAssertEqual(attributes[.foregroundColor] as! UIColor, UIColor.red)
        XCTAssertEqual(attributes[.font] as! UIFont, UIFont.boldSystemFont(ofSize: 20))
    }

    func test_renderingStyledText_fromNSAttributedString_toAttributedString_whenEmpty() {
        let attributedString = NSAttributedString(string: "", attributes: [
            .foregroundColor: UIColor.red,
            .font: UIFont.boldSystemFont(ofSize: 20),
            ])
        let text = StyledText(storage: .attributedText(attributedString), style: TextStyle())
        let render = text.render(contentSizeCategory: .large)
        XCTAssertEqual(render.string, "")
    }
    
}
