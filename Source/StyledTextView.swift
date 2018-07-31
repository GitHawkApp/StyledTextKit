//
//  StyledTextKitView.swift
//  StyledTextKit
//
//  Created by Ryan Nystrom on 12/14/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit

public protocol StyledTextViewDelegate: class {
    func didTap(view: StyledTextView, attributes: [NSAttributedStringKey: Any], point: CGPoint)
    func didLongPress(view: StyledTextView, attributes: [NSAttributedStringKey: Any], point: CGPoint)
}

open class StyledTextView: UIView {

    open weak var delegate: StyledTextViewDelegate?
    open var gesturableAttributes = Set<NSAttributedStringKey>()
    open var drawsAsync = false

    private var renderer: StyledTextRenderer?
    private var tapGesture: UITapGestureRecognizer?
    private var longPressGesture: UILongPressGestureRecognizer?
    private var tapHighlightLayer = CAShapeLayer()
    private var highlightLayer = CAShapeLayer()
    private var contentsLayer = CALayer()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false

        layer.contentsGravity = kCAGravityTopLeft
        contentsLayer.contentsGravity = kCAGravityTopLeft

        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap(recognizer:)))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
        self.tapGesture = tap

        let long = UILongPressGestureRecognizer(target: self, action: #selector(onLong(recognizer:)))
        addGestureRecognizer(long)
        self.longPressGesture = long

        self.tapHighlightColor = UIColor.clear
        layer.addSublayer(tapHighlightLayer)
        
        self.highlightColor = UIColor.clear
        layer.addSublayer(highlightLayer)

        layer.addSublayer(contentsLayer)
    }

    public var tapHighlightColor: UIColor? {
        get {
            guard let color = tapHighlightLayer.fillColor else { return nil }
            return UIColor(cgColor: color)
        }
        set { tapHighlightLayer.fillColor = newValue?.cgColor }
    }

    private var tapHighlightPath: CGPath? {
        get {
            return tapHighlightLayer.path
        }
        set {
            tapHighlightLayer.path = newValue
            tapHighlightLayer.frame = bounds
        }
    }

    public var highlightColor: UIColor? {
        get {
            guard let color = highlightLayer.fillColor else { return nil }
            return UIColor(cgColor: color)
        }
        set { highlightLayer.fillColor = newValue?.cgColor }
    }
    
    private var highlightPath: CGPath? {
        get {
            return highlightLayer.path
        }
        set {
            highlightLayer.path = newValue
            highlightLayer.frame = bounds
        }
    }

    // MARK: Overrides
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        highlightTap(at: touch.location(in: self))
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        clearTapHighlight()
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        clearTapHighlight()
    }

    // MARK: UIGestureRecognizerDelegate

    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard (gestureRecognizer === tapGesture || gestureRecognizer === longPressGesture),
            let attributes = renderer?.attributes(at: gestureRecognizer.location(in: self)) else {
                return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        for attribute in attributes.attributes {
            if gesturableAttributes.contains(attribute.key) {
                return true
            }
        }
        return false
    }

    // MARK: Private API

    @objc func onTap(recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: self)
        guard let attributes = renderer?.attributes(at: point) else { return }
        delegate?.didTap(view: self, attributes: attributes.attributes, point: point)
    }

    @objc func onLong(recognizer: UILongPressGestureRecognizer) {
        let point = recognizer.location(in: self)
        guard recognizer.state == .began,
            let attributes = renderer?.attributes(at: point)
            else { return }

        delegate?.didLongPress(view: self, attributes: attributes.attributes, point: point)
    }

    private func highlightTap(at point: CGPoint) {
        guard let renderer = renderer,
            let attributes = renderer.attributes(at: point),
            attributes.attributes[.tapHighlight] != nil
            else { return }

        let storage = renderer.storage
        let maxLen = storage.length
        var min = attributes.index
        var max = attributes.index

        storage.enumerateAttributes(
            in: NSRange(location: 0, length: attributes.index),
            options: .reverse
        ) { (attrs, range, stop) in
            if attrs[.tapHighlight] != nil && min > 0 {
                min = range.location
            } else {
                stop.pointee = true
            }
        }

        storage.enumerateAttributes(
            in: NSRange(location: attributes.index, length: maxLen - attributes.index),
            options: []
        ){ (attrs, range, stop) in
            if attrs[.tapHighlight] != nil && max < maxLen {
                max = range.location + range.length
            } else {
                stop.pointee = true
            }
        }

        let range = NSRange(location: min, length: max - min)
        let path = highlightPath(for: range)

        tapHighlightPath = path?.cgPath
    }

    private func highlightPath(for range: NSRange) -> UIBezierPath? {
        guard let renderer = renderer else { return nil }

        var firstRect: CGRect = CGRect.null
        var bodyRect: CGRect = CGRect.null
        var lastRect: CGRect = CGRect.null

        let path = UIBezierPath()

        renderer.layoutManager.enumerateEnclosingRects(
            forGlyphRange: range,
            withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0),
            in: renderer.textContainer
        ) { (rect, stop) in
            if firstRect.isNull {
                firstRect = rect
            } else if lastRect.isNull {
                lastRect = rect
            } else {
                // We have a lastRect that was previously filled, now it needs to be dumped into the body
                bodyRect = lastRect.intersection(bodyRect)
                // and save the current rect as the new "lastRect"
                lastRect = rect
            }
        }

        if !firstRect.isNull {
            path.append(UIBezierPath(roundedRect: firstRect.insetBy(dx: -2, dy: -2), cornerRadius: 3))
        }
        if !bodyRect.isNull {
            path.append(UIBezierPath(roundedRect: bodyRect.insetBy(dx: -2, dy: -2), cornerRadius: 3))
        }
        if !lastRect.isNull {
            path.append(UIBezierPath(roundedRect: lastRect.insetBy(dx: -2, dy: -2), cornerRadius: 3))
        }

        return path
    }

    private func clearTapHighlight() {
        tapHighlightLayer.path = nil
    }

    private func setRenderResults(renderer: StyledTextRenderer, result: (CGImage?, CGSize)) {
        contentsLayer.contents = result.0
        contentsLayer.frame = CGRect(origin: CGPoint(x: renderer.inset.left, y: renderer.inset.top), size: result.1)


    }

    private func highlightIfNeeded() {
        let path = UIBezierPath()
        defer { highlightPath = path.cgPath }

        guard let renderer = renderer else { return }

        renderer.storage.enumerateAttributes(in: NSMakeRange(0, renderer.storage.length), options: .longestEffectiveRangeNotRequired) { attributes, range, _ in
            if attributes[.highlight] != nil {
                if let highlightPath = highlightPath(for: range) {
                    path.append(highlightPath)
                }
            }
        }
    }

    static var renderQueue = DispatchQueue(
        label: "com.whoisryannystrom.StyledText.renderQueue",
        qos: .default, attributes: DispatchQueue.Attributes(rawValue: 0),
        autoreleaseFrequency: .workItem,
        target: nil
    )

    // MARK: Public API

    open func configure(with renderer: StyledTextRenderer, width: CGFloat) {
        self.renderer = renderer
        layer.contentsScale = renderer.scale
        contentsLayer.contentsScale = renderer.scale
        reposition(for: width)
        accessibilityLabel = renderer.string.allText
        highlightIfNeeded()
    }

    open func reposition(for width: CGFloat) {
        defer { highlightIfNeeded() }
        guard let capturedRenderer = self.renderer else { return }
        // First, we check if we can immediately apply a previously cached render result.
        let cachedResult = capturedRenderer.cachedRender(for: width)
        if let cachedImage = cachedResult.image, let cachedSize = cachedResult.size {
            setRenderResults(renderer: capturedRenderer, result: (cachedImage, cachedSize))
            return
        }

        // We have to do a full render, so if we are drawing async it's time to dispatch:
        if drawsAsync {
            StyledTextView.renderQueue.async {
                // Compute the render result (sizing and rendering to an image) on a bg thread
                let result = capturedRenderer.render(for: width)
                DispatchQueue.main.async {
                    // If the renderer changed, then our computed result is now invalid, so we have to throw it out.
                    if capturedRenderer !== self.renderer { return }
                    // If the renderer hasn't changed, we're OK to actually apply the result of our computation.
                    self.setRenderResults(renderer: capturedRenderer, result: result)
                }
            }
        } else {
            // We're in fully-synchronous mode. Immediately compute the result and set it.
            let result = capturedRenderer.render(for: width)
            setRenderResults(renderer: capturedRenderer, result: result)
        }
    }
}
