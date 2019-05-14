//
//  ItemListViewController.swift
//  LoLInfo
//
//  Created by Scarpz on 23/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {

    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var displayModeButton: UIBarButtonItem!
    
    
    // MARK: - Properties
    // Search Controller to filter Items
    private let search = UISearchController(searchResultsController: nil)
    // Array of Items to be as a backup when search isn't active
    private var allItems = [Item]()
    // Array of Items to be used as data source for the tableView and collectionView
    private var items = [Item]()
    // Property to control the display mode
    var isDisplayingAsTable: Bool = true
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupItemListView()
        self.getAllItems()
    }
    
    
    // MARK: - Actions
    /// Funcion called when pressed the Bar Button Item in the Nav Bar.
    /// It changes the icon between a list and grid icon
    /// and display the Table View and hide Collection View or vice-versa
    @IBAction func changeDisplayMode(_ sender: UIBarButtonItem) {
        
        self.isDisplayingAsTable = !self.isDisplayingAsTable

        self.displayModeButton.image = self.isDisplayingAsTable ? #imageLiteral(resourceName: "collectionIcon") : #imageLiteral(resourceName: "tableIcon")
        
        if self.isDisplayingAsTable {
            self.displayTableView()
        } else {
            self.displayCollectionView()
        }
    }
    
    
    // MARK: - Navigation
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
extension ItemListViewController {
    
    /// Method responsible to setup all the stuff of this View Controller
    /// Set all the information about the Collection View and Table View Datasource and Delegate.
    /// It also set the Search mechanism and setup the Search Bar in the Navigation
    private func setupItemListView() {
        
        self.tableView.isHidden = !self.isDisplayingAsTable
        self.collectionView.isHidden = self.isDisplayingAsTable
        self.collectionView.alpha = 0
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.keyboardDismissMode = .onDrag
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.keyboardDismissMode = .onDrag
        
        self.search.searchResultsUpdater = self
        self.search.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        
    }
    
    /// Method responsible to load all the Items, fill the data source and backup properties
    /// and reaload the Collection View / Table View with the retrieved values
    private func getAllItems() {
        ItemServices.getAllItems(itens: { [unowned self] items in
            
            self.allItems = items
            self.items = items
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.tableView.reloadData()
            }
        }) { [unowned self] error in
            self.createAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    /// Function to animate the view to hide the Table View
    /// and display the Collection View
    private func displayCollectionView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.alpha = 0
            self.tableView.isHidden = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.alpha = 1
                self.collectionView.isHidden = false
            })
        })
    }
    
    /// Function to animate the view to hide the Collection View
    /// and display the Table View
    private func displayTableView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.collectionView.alpha = 0
            self.collectionView.isHidden = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.alpha = 1
                self.tableView.isHidden = false
            })
        })
    }
}


// MARK: - Table View Methods
extension ItemListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell") as? ItemTableViewCell {
            cell.setup(item: self.items[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ItemDetailSegue", sender: self.items[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}


// MARK: - Collection View Methods
extension ItemListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as? ItemCollectionViewCell {
            cell.setup(item: items[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ItemDetailSegue", sender: self.items[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width / 4
        return CGSize(width: width - 5, height: width / 0.82)
    }

}


// MARK: - Search Results Updating Methods
extension ItemListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // Check the text and puts it in lowercase to avoid case sensitive errors on search
        if let text = searchController.searchBar.text?.lowercased() {
            
            // If it's not typed in the search, fill the datasourse with all the information
            if text.isEmpty {
                self.items = self.allItems
            } else {
                // Otherwise filter the champion name (also lowercased) with the text in the search bar
                self.items = self.allItems.filter({ $0.name.lowercased().contains(text) })
            }
        } else {
            self.items = self.allItems
        }
        
        // Reloads the Collection View
        self.collectionView.reloadData()
        
        // If there is a Index Path with row 0 and section 0 for the Collection View, scroll to this item
        if let _ = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
        // Reloads the Table View
        self.tableView.reloadData()
        
        // If there is a Index Path with row 0 and section 0 fot the Table View, scroll to this item
        if let _ = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}
