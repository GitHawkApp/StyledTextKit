//
//  FastScrollingTableViewController.swift
//  Example
//
//  Created by Ryan Nystrom on 7/8/18.
//  Copyright © 2018 Marcus Wu. All rights reserved.
//

import UIKit
import StyledTextKit

extension UITableView {
    var contentInsetWidth: CGFloat {
        return bounds.width - safeAreaInsets.left - safeAreaInsets.right
    }
}

class StyledTextTableViewCell: UITableViewCell {

    let textView = StyledTextView()

    override func layoutSubviews() {
        super.layoutSubviews()
        textView.reposition(for: contentView.bounds.width)
    }

    func configure(_ renderer: StyledTextRenderer) {
        if textView.superview != contentView {
            contentView.addSubview(textView)
        }
        textView.configure(with: renderer, width: contentView.bounds.width)
    }

}

class FastScrollingTableViewController: UITableViewController {

    var data = [StyledTextRenderer]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StyledTextTableViewCell.self, forCellReuseIdentifier: "cell")

        // capture the width and content size while on the main queue
        let contentSizeCategory = UIApplication.shared.preferredContentSizeCategory
        let width = tableView.contentInsetWidth

        DispatchQueue.global().async {

            var tmp = [StyledTextRenderer]()
            for _ in 0..<1000 {
                let builder = StyledTextBuilder(styledText: StyledText(
                    text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.",
                    style: TextStyle(size: 18)
                ))
                let renderer = StyledTextRenderer(
                    string: builder.build(),
                    contentSizeCategory: contentSizeCategory,
                    inset: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
                    )
                    .warm(width: width) // calling warm pre-sizes the text for the given width
                tmp.append(renderer)
            }

            DispatchQueue.main.async { [weak self] in
                self?.data = tmp
                self?.tableView.reloadData()
            }

        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            // fixes layout issues with safeAreaInsets not changing alongside tableView's orientation (bounds.width)
            self.tableView.reloadData()
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return data[indexPath.row].viewSize(in: tableView.contentInsetWidth).height
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let cell = cell as? StyledTextTableViewCell {
            cell.configure(data[indexPath.row])
        }
        return cell
    }

}
