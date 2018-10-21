//
//  StyledTextKitBuilderTests.swift
//  StyledTextKitTests
//
//  Created by Ryan Nystrom on 12/12/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import XCTest
@testable import StyledTextKit

class StyledTextBuilderTests: XCTestCase {
    
    func test_whenOneLevel() {
        let render = StyledTextBuilder(text: "foo")
            .build()
            .render(contentSizeCategory: .large)
        XCTAssertEqual(render.string, "foo")
    }

    func test_whenAddingString() {
        let render = StyledTextBuilder(text: "foo")
            .add(text: " bar")
            .build()
            .render(contentSizeCategory: .large)
        XCTAssertEqual(render.string, "foo bar")
    }

    func test_whenAddingAttributes() {
        let render = StyledTextBuilder(styledText: StyledText(storage: .text("foo"), style: TextStyle(font: .system(.bold))))
            .add(styledText: StyledText(storage: .text(" bar"), style: TextStyle(font: .system(.italic))))
            .build()
            .render(contentSizeCategory: .large)
        XCTAssertEqual(render.string, "foo bar")

        let font1 = render.attributes(at: 1, effectiveRange: nil)[.font] as! UIFont
        XCTAssertTrue(font1.fontDescriptor.symbolicTraits.contains(.traitBold))

        let font2 = render.attributes(at: 5, effectiveRange: nil)[.font] as! UIFont
        XCTAssertTrue(font2.fontDescriptor.symbolicTraits.contains(.traitItalic))
    }

    func test_whenAddingAttributes_withSavingState_thenRestoring() {
        let string = StyledTextBuilder(styledText: StyledText(storage: .text("foo"), style: TextStyle(font: .system(.bold))))
            .save()
            .add(styledText: StyledText(storage: .text(" bar"), style: TextStyle(font: .system(.italic))))
            .restore()
            .add(text: " baz")
            .build()
        XCTAssertEqual(string.allText, "foo bar baz")

        let render = string.render(contentSizeCategory: .large)
        XCTAssertEqual(render.string, "foo bar baz")

        let font1 = render.attributes(at: 1, effectiveRange: nil)[.font] as! UIFont
        XCTAssertTrue(font1.fontDescriptor.symbolicTraits.contains(.traitBold))
        XCTAssertFalse(font1.fontDescriptor.symbolicTraits.contains(.traitItalic))

        let font2 = render.attributes(at: 5, effectiveRange: nil)[.font] as! UIFont
        XCTAssertFalse(font2.fontDescriptor.symbolicTraits.contains(.traitBold))
        XCTAssertTrue(font2.fontDescriptor.symbolicTraits.contains(.traitItalic))

        let font3 = render.attributes(at: 9, effectiveRange: nil)[.font] as! UIFont
        XCTAssertTrue(font3.fontDescriptor.symbolicTraits.contains(.traitBold))
        XCTAssertFalse(font3.fontDescriptor.symbolicTraits.contains(.traitItalic))
    }
    
}
