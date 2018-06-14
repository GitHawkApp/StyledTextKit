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

class BackgroundRenderingViewController: UIViewController {
    
    @IBOutlet weak var containter: UIView!
    
    lazy var styledTextView: StyledTextView = {
        let textView = StyledTextView()
        
        textView.delegate = self
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Background Rendering"
        
        containter.addSubview(styledTextView)
        
        let width = styledTextView.bounds.width
        let contentSizeCategory = UIApplication.shared.preferredContentSizeCategory

        let style = TextStyle(
            size: 20,
            attributes: [.foregroundColor: UIColor.red]
        )
        
        let styleLarge = TextStyle(
            size: 32,
            attributes: [.foregroundColor: UIColor.green]
        )

        DispatchQueue.global().async {
            let builder = StyledTextBuilder(text: "So ")
                .save()
                .add(style: style)
                .add(text: "good")
                .restore()
                .save()
                .add(style: styleLarge)
                .add(text: "👍!")
                .restore()
                .add(text: "StyledTextKit", attributes: [.link: "https://github.com/GitHawkApp/StyledTextKit"])
            
            let renderer = StyledTextRenderer(string: builder.build(), contentSizeCategory: contentSizeCategory)
                .warm(width: width) // warms the size cache
            
            DispatchQueue.main.async {
                self.styledTextView.configure(with: renderer, width: width)
            }
        }
    }
    
}

extension BackgroundRenderingViewController: StyledTextViewDelegate {
    
    func didTap(view: StyledTextView, attributes: [NSAttributedStringKey : Any], point: CGPoint) {
        guard let link = attributes[.link] as? String else { return }

        present(SFSafariViewController(url: URL(string: link)!), animated: true, completion: nil)
    }
    
    func didLongPress(view: StyledTextView, attributes: [NSAttributedStringKey : Any], point: CGPoint) {}
    
}
