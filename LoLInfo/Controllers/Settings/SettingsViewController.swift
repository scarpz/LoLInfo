//
//  SettingsViewController.swift
//  LoLInfo
//
//  Created by Scarpz on 15/05/19.
//  Copyright © 2019 scarpz. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    // MARK: - Patch Cell
    @IBOutlet weak var patchLabel: UILabel!
    @IBOutlet weak var patchActivity: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getPatch()
    }
}


// MARK: - Private Methods
extension SettingsViewController {
    
    private func getPatch() {
        
        self.patchActivity.startAnimating()
        
        PatchServices.getPatch(patch: { [unowned self] patch in
            DispatchQueue.main.async {
                self.patchActivity.stopAnimating()
                self.patchLabel.text = patch
            }
        }) { [unowned self] error in
            DispatchQueue.main.async {
                self.createAlert(title: "Error", message: error.localizedDescription, action1Text: "Retry", action1: { [unowned self] _ in
                    self.getPatch()
                    }, action2Text: "Cancel", action2: nil)
            }
        }
    }
    
    private func createFeedbackAlert() {
        
        let alert = UIAlertController(title: "Feedback", message: nil, preferredStyle: .alert)
        
        alert.addTextField { nameTextField in
            nameTextField.placeholder = "What's your name?"
        }
        alert.addTextField { emailTextField in
            emailTextField.keyboardType = .emailAddress
            emailTextField.placeholder = "And your email?"
        }
        alert.addTextField { messageTextField in
            messageTextField.placeholder = "What do you want to share with us?"
        }
        
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { action in
            guard let name = alert.textFields?[0].text else { return }
            guard let email = alert.textFields?[1].text else { return }
            guard let message = alert.textFields?[2].text else { return }
            
            print(name)
            print(email)
            print(message)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: - Table View Methods
extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.createFeedbackAlert()
        }
    }
}
