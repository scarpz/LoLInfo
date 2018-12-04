//
//  ChampionListViewController.swift
//  LoLInfo
//
//  Created by Scarpz on 21/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit

class ChampionListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Properties
    // Search Controller to filter Champions
    private let search = UISearchController(searchResultsController: nil)
    // Array of champions to be as a backup when search isn't active
    private var allChampions = [Champion]()
    // Array of champions to be used as data source for the tableView
    private var champions = [Champion]()

    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupChampionListView()
        self.getAllChampions()
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Check the identifier to fill the champion property in Champion Detail VC
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
extension ChampionListViewController {
    
    /// Method responsible to setup all the stuff of this View Controller
    /// Set all the information about the Collection View Datasource and Delegate.
    /// It also set the Search mechanism and setup the Search Bar in the Navigation
    private func setupChampionListView() {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // Set the search
        self.search.searchResultsUpdater = self
        self.search.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    /// Method responsible to load all the Champions, fill the data source and backup properties
    /// and reaload the Collection View with the retrieved values
    private func getAllChampions() {
        ChampionServices.getAllChampions { [unowned self] champions in
            if let validChampions = champions {
                self.allChampions = validChampions
                self.champions = validChampions
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}


// MARK: - Collection View Methods
extension ChampionListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.champions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChampionCell", for: indexPath) as? ChampionCell {
            cell.setup(champion: self.champions[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ChampionDetailSegue", sender: self.champions[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width / 3
        return CGSize(width: width - 10, height: width / 0.9)
    }
    
    
}


// MARK: - Search Results Updating Methods
extension ChampionListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // Check the text and puts it in lowercase to avoid case sensitive errors on search
        if let text = searchController.searchBar.text?.lowercased() {
            
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
        
        // Reloads the Collection View
        self.collectionView.reloadData()
        
        // If there is a Index Path with row 0 and section 0, scroll to this item
        if let _ = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
    }
}
