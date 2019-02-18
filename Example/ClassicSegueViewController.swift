//
//  ClassicSegueViewController.swift
//  Example
//
//  Created by Drew Olbrich on 12/18/18.
//  Copyright 2019 Oath Inc.
//

import UIKit

/// A view controller that demonstrates how SeguePerformerViewController would be
/// implemented using the traditional UIViewController prepare(for:sender:)
/// mechanism. To try out this class, replace the use of
/// SeguePerformerViewController with ClassicSegueViewController in Main.storyboard.
class ClassicSegueViewController: UIViewController {

    @IBOutlet weak var firstProgrammaticSegueButton: UIButton!
    @IBOutlet weak var secondProgrammaticSegueButton: UIButton!

    @IBAction func performFirstSegue(_ sender: Any) {
        performSegue(withIdentifier: "programmaticSegue", sender: sender)
    }

    @IBAction func performSecondSegue(_ sender: Any) {
        performSegue(withIdentifier: "programmaticSegue", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let programmaticViewController = segue.destination as? ProgrammaticViewController {
            prepare(programmaticViewController: programmaticViewController, for: segue, sender: sender)
        }

        if let interactiveViewController = segue.destination as? InteractiveViewController {
            prepare(interactiveViewController: interactiveViewController, for: segue, sender: sender)
        }
    }

    // Prepares for programmatic segues initiated with performSegue, whose destination
    // view controllers are of type ProgrammaticViewController.
    private func prepare(programmaticViewController: ProgrammaticViewController, for segue: UIStoryboardSegue, sender: Any?) {
        assert(segue.identifier == "programmaticSegue")

        guard let button = sender as? UIButton else {
            assertionFailure()
            return
        }

        assert(firstProgrammaticSegueButton != nil)
        assert(secondProgrammaticSegueButton != nil)

        switch button {
        case firstProgrammaticSegueButton:
            programmaticViewController.setSegueName("First")
        case secondProgrammaticSegueButton:
            programmaticViewController.setSegueName("Second")
        default:
            break
        }
    }

    // Prepares for interactive segues configured in Storyboard
    // whose destination view controllers are of type InteractiveViewController.
    private func prepare(interactiveViewController: InteractiveViewController, for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "thirdSegue":
            interactiveViewController.setSegueName("Third")
        case "fourthSegue":
            interactiveViewController.setSegueName("Fourth")
        default:
            assertionFailure()
        }
    }

}
