//
//  SeguePerformer.swift
//  SeguePerformer
//
//  Created by Drew Olbrich on 12/18/18.
//  Copyright 2019 Oath Inc.
//
//  Distributed under the MIT License.
//
//  Get the latest version from:
//  https://github.com/drewolbrich/SeguePerformer
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

/// A class that initiates segues using closures for view controller preparation.
///
/// Unlike UIKit's `UIViewController.performSegue(withIdentifier:sender:)`, which
/// relies on `UIViewController.prepare(for:sender:)` to configure the new view
/// controller before it is presented,
/// `SeguePerformer.peformSegue(withIdentifier:sender:preparationHandler:)` provides
/// this functionality via a trailing closure parameter.
///
/// The advantage of this approach is that the view controller preparation logic is
/// declared locally to the `performSegue` call, rather than independently in
/// `prepare(for:sender:)`, which can become especially awkward in the context of
/// multiple `performSegue` calls.
///
/// # Example
///
///     class MyPresentingViewController: UIViewController {
///
///         lazy var seguePerformer = SeguePerformer(viewController: self)
///
///         func performMySegue(with myPropertyValue: Int) {
///             performSegue(withIdentifier: "mySegue", sender: self) {
///                 (myViewController: MyViewController) in
///                 myViewController.myProperty = myPropertyValue
///             }
///         }
///
///         override func prepare(for segue: UIStoryboardSegue,
///             sender: Any?) {
///             seguePerformer.prepare(for: segue, sender: sender)
///         }
///
///     }
public class SeguePerformer {

    private weak var presentingviewController: UIViewController?

    private var segueIdentifier: String?
    private var seguePreparationHandler: ((_ segue: UIStoryboardSegue) -> Bool)?

    /// Returns an object that can be used to initiate segues from the specified view
    /// controller.
    ///
    /// - Parameter viewController: The view controller whose storyboard file will act
    ///     as a source of segues later initiated by
    ///     `performSegue(withIdentifier:sender:preparationHandler:)`.
    public init(viewController: UIViewController) {
        self.presentingviewController = viewController
    }

    /// Initiates a segue with the specified identifer, using a closure to configure the
    /// destination view controller.
    ///
    /// For this method to work properly, the caller must provide an implementation of
    /// `UIViewController.prepare(for:sender:)` which calls
    /// `SeguePerformer.prepare(for:sender:)`.
    ///
    /// Additionally, the trailing closure's view controller parameter type must be
    /// explicitly declared and must match that of the segue's destination view
    /// controller.
    ///
    /// # Example
    ///
    ///     func performMySegue(with myPropertyValue: Int) {
    ///         performSegue(withIdentifier: "mySegue", sender: self) {
    ///             (myViewController: MyViewController) in
    ///             myViewController.myProperty = myPropertyValue
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - identifier: The string that identifies the triggered segue.
    ///   - sender: The object that initiates the segue.
    ///   - preparationHandler: The closure that is called to before the segue is performed.
    ///       - presentedViewController: The presented view controller. This parameter's type
    ///           must be explicitly declared and must match that of the segue's destination
    ///           view controller.
    public func performSegue<T>(withIdentifier identifier: String, sender: Any?, preparationHandler: ((_ presentedViewController: T) -> Void)?) where T: UIViewController {
        self.segueIdentifier = identifier

        self.seguePreparationHandler = { (segue: UIStoryboardSegue) in
            guard let presentedViewController = segue.destination as? T else {
                assertionFailure("The presented view controller is type \(type(of: segue.destination).self), which does not match the segue preparation handler parameter type \(T.self)")
                return false
            }
            preparationHandler?(presentedViewController)
            return true
        }

        presentingviewController?.performSegue(withIdentifier: identifier, sender: sender)
    }

    /// Calls the `preparationHandler` closure parameter passed earlier to
    /// `performSegue(withIdentifier:sender:preparationHandler:)`.
    ///
    /// This method must be called by `UIViewController.prepare(for:sender:)`, or
    /// otherwise the `preparationHandler` closure passeed to
    /// `performSegue(withIdentifier:sender:preparationHandler:)` will never be called.
    ///
    /// - Parameters:
    ///   - segue: The segue object containing information about the view controllers involved in the segue.
    ///   - sender: The object that initiated the segue.
    ///
    /// - Returns: `true` if the segue was initiated by an earlier call to
    ///     `performSegue(withIdentifier:sender:preparationHandler:)` or `false` if it was
    ///     initiated by a call to `UIViewController.prepare(for:sender:)`.
    @discardableResult public func prepare(for segue: UIStoryboardSegue, sender: Any?) -> Bool {
        guard segue.identifier == segueIdentifier else {
            return false
        }
        segueIdentifier = nil

        return seguePreparationHandler?(segue) ?? false
    }

}
