//
//  ViewControllersExtension.swift
//  LoLInfo
//
//  Created by Scarpz on 05/12/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Creates an default alert
    ///
    /// - Parameters:
    ///   - title: Title of the alert
    ///   - message: Message of the alert
    ///   - okButton: Text of the button. It's an "Ok" by default
    func createAlert(title: String?, message: String?, okButton: String = "Ok") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okButton, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createAlert(title: String?, message: String?, action1Text: String = "Ok", action1: ((UIAlertAction) -> Void)?, action2Text: String?, action2: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action1Text, style: .default, handler: action1))
        if let action2Text = action2Text {
            alert.addAction(UIAlertAction(title: action2Text, style: .default, handler: action2))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}
