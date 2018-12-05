//
//  ItemSetListViewController.swift
//  LoLInfo
//
//  Created by Scarpz on 28/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit

class ItemSetListViewController: UIViewController {

    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    // Search Controller to filter ItemSets
    private let search = UISearchController(searchResultsController: nil)
    // Array of ItemSet to be as a backup when search isn't active
    private var allItemSets = [ItemSet]()
    // Array of ItemSet to be used as data source for the tableView
    private var itemSets = [ItemSet]()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupItemSetListView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getAllItemSets()
    }
    
    
    // MARK: - Actions
    @IBAction func addNewItemSegue(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "AddItemSetSegue", sender: nil)
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewItemSetSegue" {
            
        }
    }
}


// MARK: - Private Methods
extension ItemSetListViewController {
    
    /// Method responsible to setup all the stuff of this View Controller
    /// Set all the information about the Table View Datasource and Delegate.
    /// It also set the Search mechanism and setup the Search Bar in the Navigation
    private func setupItemSetListView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.keyboardDismissMode = .onDrag
        
        // Set the search
        self.search.searchResultsUpdater = self
        self.search.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    /// Method responsible to load all the Item Sets, fill the data source and backup properties
    /// and reaload the Table View with the retrieved values
    private func getAllItemSets() {
        ItemSetServices.getAllItemSets { [unowned self] itemSets in
            if let validItemSets = itemSets {
                self.allItemSets = validItemSets
                self.itemSets = validItemSets

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}


// MARK: - Table View Methods
extension ItemSetListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemSets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemSetTableViewCell") as? ItemSetTableViewCell {
            cell.setup(itemSet: self.itemSets[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "ItemSetDetailSegue", sender: self.itemSets[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}


// MARK: - Search Results Updating Methods
extension ItemSetListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // Check the text and puts it in lowercase to avoid case sensitive errors on search
        if let text = searchController.searchBar.text?.lowercased() {
            
            // If it's not typed in the search, fill the datasourse with all the information
            if text.isEmpty {
                self.itemSets = self.allItemSets
            } else {
                // Otherwise filter the Item Set name (also lowercased) with the text in the search bar
                self.itemSets = self.allItemSets.filter({ $0.name.lowercased().contains(text) })
            }
        } else {
            self.itemSets = self.allItemSets
        }
        
        // Reloads the Table View
        self.tableView.reloadData()
        
        // If there is a Index Path with row 0 and section 0, scroll to this item
        if let _ = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
    }
}
