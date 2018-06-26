//
//  BudingAttributedStringViewController.swift
//  Example
//
//  Created by Marcus Wu on 2018/6/14.
//  Copyright © 2018年 Marcus Wu. All rights reserved.
//

import UIKit
import StyledTextKit

class BudingAttributedStringViewController: UIViewController {
  
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Building NSAttributedStrings"
    
        let attributedString = StyledTextBuilder(text: "Foo ")
            .save()
            .add(text: "bar", traits: [.traitBold])
            .restore()
            .add(text: " baz!")
            .build()
            .render(contentSizeCategory: .extraExtraExtraLarge)
        
        label.attributedText = attributedString
    }
    
}

