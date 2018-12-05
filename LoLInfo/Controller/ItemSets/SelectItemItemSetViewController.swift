//
//  SelectItemItemSetViewController.swift
//  LoLInfo
//
//  Created by Scarpz on 30/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit

protocol ItemSelectionDelegate: class {
    func selectItem(item: Item)
}

class SelectItemItemSetViewController: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    // Array of Items to be as a backup when search isn't active
    private var allItems = [Item]()
    // Array of Items to be used as data source for the tableView
    private var items = [Item]()
    weak var delegate: ItemSelectionDelegate?
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSelectItemView()
        self.getAllItems()
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
                self.items = self.allItems
            } else {
                // Otherwise filter the Item name (also lowercased) with the text in the search bar
                self.items = self.allItems.filter({ $0.name.lowercased().contains(text) })
            }
        } else {
            self.items = self.allItems
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
        if segue.identifier == "ItemDetailSegue" {
            if let itemDetailVC = segue.destination as? ItemDetailViewController {
                if let item = sender as? Item {
                    itemDetailVC.item = item
                }
            }
        }
    }
    
}


// MARK: - Private Methods
extension SelectItemItemSetViewController {
    
    private func setupSelectItemView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.searchTextField.delegate = self
        
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAction)))
    }
    
    /// Method responsible to load all the Items, fill the data source and backup properties
    /// and reaload the Table View with the retrieved values
    private func getAllItems() {
        ItemServices.getAllItems { [unowned self] items in
            if let validItems = items {
                self.allItems = validItems
                self.items = validItems
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc private func dismissAction() {
        
        if searchTextField.isFirstResponder {
            self.searchTextField.resignFirstResponder()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}


// MARK: - Text Field Methods
extension SelectItemItemSetViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - Table View Methods
extension SelectItemItemSetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemSelectionTableViewCell") as? ItemSelectionTableViewCell {
            cell.setup(item: self.items[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            delegate.selectItem(item: self.items[indexPath.row])
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ItemDetailSegue", sender: self.items[indexPath.row])
    }
}
