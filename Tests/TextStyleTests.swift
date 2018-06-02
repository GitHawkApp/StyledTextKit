//
//  TextStyleTests.swift
//  StyledTextKitTests
//
//  Created by Ryan Nystrom on 12/12/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import XCTest
@testable import StyledTextKit

class TextStyleTests: XCTestCase {
    
    func test_initializersPassed() {
        let style = TextStyle(
            font: .name("name"),
            size: 12,
            attributes: [.foregroundColor: UIColor.white],
            minSize: 11,
            maxSize: 13
        )
        XCTAssertEqual(style.size, 12)
        XCTAssertEqual(style.attributes[.foregroundColor] as! UIColor, UIColor.white)
        XCTAssertEqual(style.minSize, 11)
        XCTAssertEqual(style.maxSize, 13)
        switch style.font {
        case .name(let name): XCTAssertEqual(name, "name")
        default: XCTFail()
        }
    }

    func test_whenObjectsSame_thatHashHits() {
        XCTAssertEqual(
            TextStyle(
                font: .name("name"),
                size: 12,
                attributes: [.foregroundColor: UIColor.white],
                minSize: 11,
                maxSize: 13
                ).hashValue,
            TextStyle(
                font: .name("name"),
                size: 12,
                attributes: [.foregroundColor: UIColor.white],
                minSize: 11,
                maxSize: 13
                ).hashValue
        )
    }

    func test_whenNameDiffers_thatHashMisses() {
        XCTAssertNotEqual(
            TextStyle(
                size: 12,
                attributes: [.foregroundColor: UIColor.white],
                minSize: 11,
                maxSize: 13
                ).hashValue,
            TextStyle(
                font: .name("name"),
                size: 12,
                attributes: [.foregroundColor: UIColor.white],
                minSize: 11,
                maxSize: 13
                ).hashValue
        )
    }

    func test_whenSizeDiffers_thatHashMisses() {
        XCTAssertNotEqual(
            TextStyle(
                font: .name("name"),
                size: 12,
                attributes: [.foregroundColor: UIColor.white],
                minSize: 11,
                maxSize: 13
                ).hashValue,
            TextStyle(
                font: .name("name"),
                size: 13,
                attributes: [.foregroundColor: UIColor.white],
                minSize: 11,
                maxSize: 13
                ).hashValue
        )
    }

    func test_whenAttributeCountsDiffer_thatHashMisses() {
        XCTAssertNotEqual(
            TextStyle(
                font: .name("name"),
                size: 12,
                attributes: [.foregroundColor: UIColor.white],
                minSize: 11,
                maxSize: 13
                ).hashValue,
            TextStyle(
                font: .name("name"),
                size: 12,
                attributes: [.foregroundColor: UIColor.white, .backgroundColor: UIColor.black],
                minSize: 11,
                maxSize: 13
                ).hashValue
        )
    }

    func test_whenAttributesDiffer_thatNotEqual() {
        XCTAssertNotEqual(
            TextStyle(
                font: .name("name"),
                size: 12,
                attributes: [.foregroundColor: UIColor.white],
                minSize: 11,
                maxSize: 13
                ),
            TextStyle(
                font: .name("name"),
                size: 12,
                attributes: [.foregroundColor: UIColor.black],
                minSize: 11,
                maxSize: 13
                )
        )
    }

    func test_whenTypesDiffer_thatHashMisses() {
        XCTAssertNotEqual(
            TextStyle(
                font: .name("name"),
                size: 12,
                attributes: [.foregroundColor: UIColor.white],
                minSize: 11,
                maxSize: 13
                ).hashValue,
            TextStyle(
                font: .system(.default),
                size: 12,
                attributes: [.foregroundColor: UIColor.white],
                minSize: 11,
                maxSize: 13
                ).hashValue
        )
    }

    func test_whenMinSizeDiffers_thatHashMisses() {
        XCTAssertNotEqual(
            TextStyle(
                font: .name("name"),
                size: 12,
                attributes: [.foregroundColor: UIColor.white],
                minSize: 11,
                maxSize: 13
                ).hashValue,
            TextStyle(
                font: .name("name"),
                size: 12,
                attributes: [.foregroundColor: UIColor.white],
                minSize: 12,
                maxSize: 13
                ).hashValue
        )
    }

    func test_whenMaxSizeDiffers_thatHashMisses() {
        XCTAssertNotEqual(
            TextStyle(
                font: .name("name"),
                size: 12,
                attributes: [.foregroundColor: UIColor.white],
                minSize: 11,
                maxSize: 13
                ).hashValue,
            TextStyle(
                font: .name("name"),
                size: 12,
                attributes: [.foregroundColor: UIColor.white],
                minSize: 11,
                maxSize: 14
                ).hashValue
        )
    }
    
}
