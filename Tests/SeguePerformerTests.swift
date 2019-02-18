//
//  SeguePerformerTests.swift
//  SeguePerformerTests
//
//  Created by Drew Olbrich on 12/18/18.
//  Copyright 2019 Oath Inc.
//

import XCTest
@testable import SeguePerformer

class SeguePerformerTests: XCTestCase {

    private var window: UIWindow?
    private var presentingViewController: PresentingViewController?

    private let testSegueIdentifier = "testSegue"

    override func setUp() {
        let bundle = Bundle(for: SeguePerformerTests.self)
        let storyboard = UIStoryboard(name: "SeguePerformerTests", bundle: bundle)

        presentingViewController = storyboard.instantiateInitialViewController() as? PresentingViewController
        XCTAssertNotNil(presentingViewController)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.isHidden = false
        presentingViewController?.beginAppearanceTransition(true, animated: false)
        window?.rootViewController = presentingViewController
        presentingViewController?.endAppearanceTransition()
    }

    override func tearDown() {
        presentingViewController?.beginAppearanceTransition(false, animated: false)
        window?.rootViewController = nil
        presentingViewController?.endAppearanceTransition()
        window?.isHidden = true
        window = nil

        presentingViewController = nil
    }

    /// Tests that the performSegue preparation handler is called.
    func testPreparationHandler() {
        guard let presentingViewController = presentingViewController else {
            XCTFail("The presenting view controller is undefined.")
            return
        }

        var hasCalledPreparationHandler = false

        // Peform the test segue.
        presentingViewController.seguePerformer.performSegue(withIdentifier: testSegueIdentifier, sender: self) { (presentedViewController: PresentedViewController) in
            hasCalledPreparationHandler = true
        }

        // If this succeeds, we know that the preparation handler was called, which will be
        // the case if PresentingViewController.prepare(for:sender:) called
        // SeguePerformer.prepare(for:sender:), as expected.
        XCTAssert(hasCalledPreparationHandler)
    }

    /// Tests that the performSegue preparation handler can initialize the presented
    /// view controller state.
    func testPresentedViewControllerState() {
        guard let presentingViewController = presentingViewController else {
            XCTFail("The presenting view controller is undefined.")
            return
        }

        let testString = "whatever"

        // Peform the test segue, assigning a test string to the presented
        // view controller.
        presentingViewController.seguePerformer.performSegue(withIdentifier: testSegueIdentifier, sender: self) { (presentedViewController: PresentedViewController) in
            presentedViewController.testString = testString
        }

        // A view controller was presented.
        XCTAssertNotNil(presentingViewController.presentedViewController)

        // The presented view controller is of type PresentingViewController.
        let presentedViewController = presentingViewController.presentedViewController as? PresentedViewController
        XCTAssertNotNil(presentedViewController)

        // The test string we assigned in the preparation handler was correctly assigned to
        // PresentedViewController.
        XCTAssertEqual(presentedViewController?.testString, testString)
    }

}
