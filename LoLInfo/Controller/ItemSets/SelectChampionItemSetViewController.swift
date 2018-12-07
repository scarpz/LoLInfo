//
//  SelectChampionItemSetViewController.swift
//  LoLInfo
//
//  Created by Scarpz on 29/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit

protocol ChampionSelectionDelegate: class {
    /// Method from Champion Selection Delegate to set the selected
    /// Champion to this view and show those information to the User
    ///
    /// - Parameter champion: Selected Champion to be displayed
    func selectChampion(champion: Champion)
}

class SelectChampionItemSetViewController: UIViewController {

    
    // MARK: - Outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    // Array of champions to be as a backup when search isn't active
    private var allChampions = [Champion]()
    // Array of champions to be used as data source for the tableView
    private var champions = [Champion]()
    weak var delegate: ChampionSelectionDelegate?
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSelectChampionView()
        self.getAllChampions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    //MARK: - Actions
    @IBAction func performSearch(_ sender: UITextField) {
        
        // Check the text and puts it in lowercase to avoid case sensitive errors on search
        if let text = sender.text?.lowercased() {
            
            // If it's not typed in the search, fill the datasourse with all the information
            if text.isEmpty {
                self.champions = self.allChampions
            } else {
                // Otherwise filter the champion name (also lowercased) with the text in the search bar
                self.champions = self.allChampions.filter({ $0.name.lowercased().contains(text) })
            }
        } else {
            self.champions = self.allChampions
        }
        
        // Reloads the Table View
        self.tableView.reloadData()
        
        // If there is a Index Path with row 0 and section 0, scroll to this item
        if let _ = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    
    // MARK: - Nagivation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChampionDetailSegue" {
            if let championDetailVC = segue.destination as? ChampionDetailViewController {
                if let champion = sender as? Champion {
                    championDetailVC.champion = champion
                }
            }
        }
    }
    
}


// MARK: - Private Methods
extension SelectChampionItemSetViewController {
    
    /// Method responsible to setup all the stuff of this View Controller
    /// Set all the information about the Table View and Text Field Datasource and Delegate.
    /// It also set a Gesture Recognizer to the Background view to perform its actions
    private func setupSelectChampionView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.searchTextField.delegate = self
        
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAction)))
    }
    
    /// Method responsible to load all the Champions, fill the data source and backup properties
    /// and reaload the Table View with the retrieved values
    private func getAllChampions() {
        ChampionServices.getAllChampions { [unowned self] champions in
            if let validChampions = champions {
                self.allChampions = validChampions
                self.champions = validChampions
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    /// Method responsible to see what is to be dismissed.
    /// If the search is active, the action dismiss it.
    /// If not, dismiss the modal View Controller
    @objc private func dismissAction() {
        
        if searchTextField.isFirstResponder {
            self.searchTextField.resignFirstResponder()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}


// MARK: - Text Field Methods
extension SelectChampionItemSetViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - Table View Methods
extension SelectChampionItemSetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.champions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChampionSelectionTableViewCell") as? ChampionSelectionTableViewCell {
            cell.setup(champion: self.champions[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            delegate.selectChampion(champion: self.champions[indexPath.row])
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ChampionDetailSegue", sender: self.champions[indexPath.row])
    }
}
