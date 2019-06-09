import UIKit
import StyledTextKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: StyledTextView!
    @IBOutlet weak var stateLabel: UILabel!

    private let style = TextStyle(
        size: 20,
        attributes: [.foregroundColor: UIColor.red]
    )

    private let styleLarge = TextStyle(
        size: 32,
        attributes: [.foregroundColor: UIColor.green]
    )

    private let styleTapable = TextStyle(
        size: 16,
        attributes: [.foregroundColor: UIColor.orange,
                     .underlineStyle: 1]
    )

    override func viewDidLoad() {
        super.viewDidLoad()

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
            .add(text: "Link1", attributes: [.highlight: "Link1"])
            .restore()
            .save()
            .add(text: "\n")
            .restore()
            .save()
            .add(style: self.styleTapable)
            .add(text: "Link2 ", attributes: [.highlight: "Link2"])
            .restore()

        let renderer = StyledTextRenderer(string: builder.build(),
                                          contentSizeCategory: .medium)

        textView.configure(with: renderer, width: 240)
        textView.delegate = self
    }
}

extension ViewController: StyledTextViewDelegate {

    func didTap(view: StyledTextView, attributes: NSAttributedStringAttributesType, point: CGPoint) {
        guard let linkContent = attributes[.highlight] as? String else { return }
        stateLabel.text = "didTap: \(linkContent)"
    }

    func didLongPress(view: StyledTextView, attributes: NSAttributedStringAttributesType, point: CGPoint) {
        guard let linkContent = attributes[.highlight] as? String else { return }
        stateLabel.text = "didLongPress: \(linkContent)"
    }

}
