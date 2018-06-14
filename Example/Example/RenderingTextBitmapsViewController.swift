//
//  RenderingTextBitmapsViewController.swift
//  Example
//
//  Created by Marcus Wu on 2018/6/14.
//  Copyright © 2018年 Marcus Wu. All rights reserved.
//

import UIKit
import StyledTextKit

class RenderingTextBitmapsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Rendering Text Bitmaps"
        
        let style = TextStyle(
            size: 16,
            attributes: [.foregroundColor: UIColor.black]
        )
        
        let styleLarge = TextStyle(
            size: 24,
            attributes: [.foregroundColor: UIColor.green]
        )
        
        let foo = StyledText(storage: .text("foo"), style: style)
        let bar = StyledText(storage: .text(" bar"), style: styleLarge)
        let good = StyledText(storage: .text("👍"), style: styleLarge)
        let string = StyledTextString(styledTexts: [foo, bar, good])
        let renderer = StyledTextRenderer(
            string: string,
            contentSizeCategory: .large
        )
        let result = renderer.render(for: UIScreen.main.bounds.width)
        
        view.layer.contents = result.image
        view.layer.contentsGravity = kCAGravityCenter
    }
    
}
