//
//  StyledTextKitRendererSnapshotTests.swift
//  StyledTextKitTests
//
//  Created by Ryan Nystrom on 12/14/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import XCTest
import Snap_swift
@testable import StyledTextKit

extension UIView {

    func mount(width: CGFloat, renderer: StyledTextRenderer) -> UIView {
        frame = CGRect(origin: .zero, size: renderer.size(in: width))
        layer.contents = renderer.render(for: width).image
        return self
    }

}

class SnapTests: XCTestCase {

    let testScale: CGFloat = 2
    let lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    let sizeCache = LRUCache<StyledTextRenderCacheKey, CGSize>(
        maxSize: 1000, // CGSize cache size always 1, treat as item count
        compaction: .default,
        clearOnWarning: true
    )
    let bitmapCache = LRUCache<StyledTextRenderCacheKey, CGImage>(
        maxSize: 1024 * 1024 * 20, // 20mb
        compaction: .default,
        clearOnWarning: true
    )

    override func setUp() {
        super.setUp()
        sizeCache.clear()
        bitmapCache.clear()
    }

    func test_lorem_100() {
        let string = StyledTextBuilder(text: lorem).build()
        let renderer = StyledTextRenderer(
            string: string,
            contentSizeCategory: .large,
            backgroundColor: .white,
            scale: testScale,
            sizeCache: sizeCache,
            bitmapCache: bitmapCache
        )
        expect(UIView().mount(width: 100, renderer: renderer)).toMatchSnapshot()
    }

    func test_lorem_200() {
        let string = StyledTextBuilder(text: lorem).build()
        let renderer = StyledTextRenderer(
            string: string,
            contentSizeCategory: .large,
            backgroundColor: .white,
            scale: testScale,
            sizeCache: sizeCache,
            bitmapCache: bitmapCache
        )
        expect(UIView().mount(width: 200, renderer: renderer)).toMatchSnapshot()
    }

    func test_lorem_300() {
        let string = StyledTextBuilder(text: lorem).build()
        let renderer = StyledTextRenderer(
            string: string,
            contentSizeCategory: .large,
            backgroundColor: .white,
            scale: testScale,
            sizeCache: sizeCache,
            bitmapCache: bitmapCache
        )
        expect(UIView().mount(width: 300, renderer: renderer)).toMatchSnapshot()
    }

    func test_complexBuilder() {
        let string = StyledTextBuilder(text: "Hello, ")
            .save()
            .add(text: "world!", traits: [.traitItalic, .traitBold])
            .restore()
            .add(text: " Pop back. ")
            .save()
            .add(styledText: StyledText(storage: .text("Tiny text. "), style: TextStyle(size: 6)))
            .add(styledText: StyledText(storage: .text("Big text. "), style: TextStyle(size: 20)))
            .restore()
            .add(text: "Background color.", traits: .traitBold, attributes: [.backgroundColor: UIColor.blue, .foregroundColor: UIColor.white])
            .build()
        let renderer = StyledTextRenderer(
            string: string,
            contentSizeCategory: .large,
            backgroundColor: .white,
            scale: testScale,
            sizeCache: sizeCache,
            bitmapCache: bitmapCache
        )
        expect(UIView().mount(width: 300, renderer: renderer)).toMatchSnapshot()
    }

    func test_clearBackground() {
        let string = StyledTextBuilder(text: lorem).build()
        let renderer = StyledTextRenderer(string: string, contentSizeCategory: .large, scale: testScale)
        let view = UIView()
        view.backgroundColor = .blue
        expect(view.mount(width: 300, renderer: renderer)).toMatchSnapshot()
    }
    
    func test_maxNumberOfLinesUnlimited() {
        let string = StyledTextBuilder(text: lorem).build()
        let renderer = StyledTextRenderer(
            string: string,
            contentSizeCategory: .large,
            backgroundColor: .white,
            scale: testScale,
            maximumNumberOfLines: 0,
            sizeCache: sizeCache,
            bitmapCache: bitmapCache
        )
        expect(UIView().mount(width: 300, renderer: renderer)).toMatchSnapshot()
    }
    
    func test_maxNumberOfLinesLimited() {
        let string = StyledTextBuilder(text: lorem).build()
        let renderer = StyledTextRenderer(
            string: string,
            contentSizeCategory: .large,
            backgroundColor: .white,
            scale: testScale,
            maximumNumberOfLines: 2,
            sizeCache: sizeCache,
            bitmapCache: bitmapCache
        )
        expect(UIView().mount(width: 300, renderer: renderer)).toMatchSnapshot()
    }
}
