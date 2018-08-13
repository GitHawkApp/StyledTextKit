//
//  BackgroundRenderingViewController.swift
//  Example
//
//  Created by Marcus Wu on 2018/6/14.
//  Copyright © 2018年 Marcus Wu. All rights reserved.
//

import UIKit
import StyledTextKit
import SafariServices

extension NSAttributedStringKey {
    
    public static let tapable = NSAttributedStringKey(rawValue: "tapable")
    
}

class BackgroundRenderingViewController: UIViewController {
    
    @IBOutlet weak var containter: UIView!
    
    lazy var styledTextView: StyledTextView = {
        let textView = StyledTextView()
        
        textView.delegate = self
        
        return textView
    }()
    
    let contentSizeCategory = UIApplication.shared.preferredContentSizeCategory
    
    let style = TextStyle(
        size: 20,
        attributes: [.foregroundColor: UIColor.red]
    )
    
    let styleLarge = TextStyle(
        size: 32,
        attributes: [.foregroundColor: UIColor.green]
    )
    
    let styleTapable = TextStyle(
        size: 16,
        attributes: [.foregroundColor: UIColor.orange,
                     .underlineStyle: 1]
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Background Rendering"
        
        containter.addSubview(styledTextView)
        
        DispatchQueue.global().async {
            let builder = StyledTextBuilder(text: "So ")
                .save()
                .add(style: self.style)
                .add(text: "good")
                .restore()
                .save()
                .add(style: self.styleLarge)
                .add(text: "👍!")
                .restore()
                .save()
                .add(style: self.styleTapable)
                .add(text: "Tap me to StyledTextKit GitHub", attributes: [.tapable: #selector(self.tapAction), .highlight: NSObject()])
            
            let renderer = StyledTextRenderer(string: builder.build(), contentSizeCategory: self.contentSizeCategory)
                .warm(width: 240) // warms the size cache
            
            DispatchQueue.main.async {
                self.styledTextView.configure(with: renderer, width: 240)
            }
        }
    }
    
    @objc private func tapAction() {
        present(SFSafariViewController(url: URL(string: "https://github.com/GitHawkApp/StyledTextKit")!), animated: true, completion: nil)
    }
    
}

extension BackgroundRenderingViewController: StyledTextViewDelegate {
    
    func didTap(view: StyledTextView, attributes: [NSAttributedStringKey : Any], point: CGPoint) {
        guard let action = attributes[.tapable] as? Selector else { return }

        perform(action)
    }
    
    func didLongPress(view: StyledTextView, attributes: [NSAttributedStringKey : Any], point: CGPoint) {}
    
}
