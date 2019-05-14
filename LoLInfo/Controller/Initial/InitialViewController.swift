//
//  InitialViewController.swift
//  LoLInfo
//
//  Created by Scarpz on 14/05/19.
//  Copyright © 2019 scarpz. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PatchServices.getPatch(patch: { [unowned self] _ in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "InitialSegue", sender: nil)
            }
        }, failure: { [unowned self] error in
            self.createAlert(title: "Error", message: error.localizedDescription)
        })
    }

}
