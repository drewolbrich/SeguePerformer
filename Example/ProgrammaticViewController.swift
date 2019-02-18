//
//  ProgrammaticViewController.swift
//  Example
//
//  Created by Drew Olbrich on 12/18/18.
//  Copyright 2019 Oath Inc.
//

import UIKit

class ProgrammaticViewController: UIViewController {

    @IBOutlet weak var segueNameLabel: UILabel!

    func setSegueName(_ text: String?) {
        loadViewIfNeeded()
        segueNameLabel.text = text
    }

}
