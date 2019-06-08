//
//  StyledTextStringTests.swift
//  Tests
//
//  Created by Ryan Nystrom on 11/10/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//
import XCTest
@testable import StyledTextKit

class StyledTextStringTests: XCTestCase {

    func test_cacheKeysEqual() {
        let text1 = StyledTextBuilder(text: "foo").add(text: "bar", traits: [.traitBold]).build()
        let text2 = StyledTextBuilder(text: "foo").add(text: "bar", traits: [.traitBold]).build()

        let key1 = StyledTextRenderCacheKey(
            width: 100,
            attributedText: text1.render(contentSizeCategory: .medium),
            backgroundColor: nil,
            maximumNumberOfLines: nil
        )
        let key2 = StyledTextRenderCacheKey(
            width: 100,
            attributedText: text2.render(contentSizeCategory: .medium),
            backgroundColor: nil,
            maximumNumberOfLines: nil
        )
        XCTAssertEqual(key1, key2)
    }

}
