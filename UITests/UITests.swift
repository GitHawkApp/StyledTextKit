import XCTest

class UITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
    }

    func test_tapLink() {
        let app = XCUIApplication()
        let textviewElement = app.otherElements["textView"]
        let statelabelElement = app.otherElements["stateLabel"]

        textviewElement.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
            .tap()
        XCTAssertEqual(statelabelElement.label, "didTap: Link1")

        textviewElement.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.4))
            .tap()
        XCTAssertEqual(statelabelElement.label, "didTap: Link2")
    }
}
