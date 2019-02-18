//
//  PresentingViewController.swift
//  SeguePerformerTests
//
//  Created by Drew Olbrich on 12/18/18.
//  Copyright 2019 Oath Inc.
//

import UIKit
import SeguePerformer

class PresentingViewController: UIViewController {

    lazy var seguePerformer = SeguePerformer(viewController: self)

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        seguePerformer.prepare(for: segue, sender: sender)
    }

}
