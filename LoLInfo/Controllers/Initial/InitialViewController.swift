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
        
        self.getPatch()
    }
    
    private func getPatch() {
        PatchServices.getPatchFromServer(patch: { [unowned self] _ in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "InitialSegue", sender: nil)
            }
            }, failure: { [unowned self] error in
                DispatchQueue.main.async {
                    self.createAlert(title: "Error", message: error.localizedDescription, action1Text: "Retry", action1: { [unowned self] _ in
                        self.getPatch()
                        }, action2Text: "Cancel", action2: nil)
                }
        })
    }
    
}
