//
//  NewItemSetViewController.swift
//  LoLInfo
//
//  Created by Scarpz on 28/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit
import Nuke

class NewItemSetViewController: UIViewController {

    
    // MARK: - Outlets
    @IBOutlet weak var itemSetTextField: UITextField!
    
    // With Champion
    @IBOutlet weak var championView: UIView!
    @IBOutlet weak var championThumb: UIImageView!
    @IBOutlet weak var championName: UILabel!
    
    // Without Champion
    @IBOutlet weak var noChampionView: UIView!
    
    // Items
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Properties
    var selectedChampion: Champion?
    var selectedItems = [Item]()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNewItemSetView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.displayRightView()
        self.displayChampion()
    }
    
    
    // MARK: - Actions
    @IBAction func saveItemSet(_ sender: UIBarButtonItem) {
        
        self.itemSetTextField.resignFirstResponder()
        
        if let itemSetName = self.itemSetTextField.text, !itemSetName.isEmpty {
            
            if let champion = self.selectedChampion, self.selectedItems.count > 0 && self.selectedItems.count <= 6 {
                
                let itemSet = ItemSet(name: itemSetName, date: Date(), champion: champion, items: self.selectedItems)
                
                do {
                    try ItemSetServices.saveItemSet(itemSet: itemSet)
                    self.navigationController?.popViewController(animated: true)
                } catch {
                    self.createAlert(title: "Oops", message: "An error has occurred when trying to save this Item Set. Please try again.")
                }
            } else {
                self.createAlert(title: "Oops", message: "There is an error in this Item Set. Or you didn't select a Champion or you didn't pick any Item. Please try again")
            }
        } else {
            self.createAlert(title: "Oops", message: "Please, choose a name for your Item Set.")
        }
    }
    
    
    @IBAction func championInfo(_ sender: UIButton) {
        self.itemSetTextField.resignFirstResponder()
        self.performSegue(withIdentifier: "ChampionDetailSegue", sender: self.selectedChampion)
    }

    @IBAction func selectChampion(_ sender: UIButton) {
        self.itemSetTextField.resignFirstResponder()
        self.performSegue(withIdentifier: "SelectChampionSegue", sender: nil)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectChampionSegue" {
            if let navBar = segue.destination as? UINavigationController {
                if let selectChampionVC = navBar.viewControllers[0] as? SelectChampionItemSetViewController {
                    selectChampionVC.delegate = self
                }
            }
        } else if segue.identifier == "ChampionDetailSegue" {
            if let championDetailVC = segue.destination as? ChampionDetailViewController {
                if let champion = sender as? Champion {
                    championDetailVC.champion = champion
                }
            }
        } else if segue.identifier == "SelectItemSegue" {
            if let navBar = segue.destination as? UINavigationController {
                if let selectItemVC = navBar.viewControllers[0] as? SelectItemItemSetViewController {
                    selectItemVC.delegate = self
                }
            }
        } else if segue.identifier == "ItemDetailSegue" {
            if let itemDetailVC = segue.destination as? ItemDetailViewController {
                if let item = sender as? Item {
                    itemDetailVC.item = item
                }
            }
        }
    }
}


// MARK: - Private Methods
extension NewItemSetViewController {
    
    /// Method responsible to setup all the stuff of this View Controller
    /// Set all the information about the Collection View and Text Field Datasource and Delegate.
    private func setupNewItemSetView() {
        
        self.itemSetTextField.delegate = self
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }
    
    /// Method responsible to check the existance of a Champion
    /// to display the right view between the one with the Champion
    /// and the one without it
    private func displayRightView() {
        self.championView.isHidden = (self.selectedChampion == nil)
        self.noChampionView.isHidden = (self.selectedChampion != nil)
    }
    
    /// Method responsible to display the selected Champion
    private func displayChampion() {
        if let validChampion = self.selectedChampion {
            if let validURL = URL(string: validChampion.thumbURL) {
                loadImage(with: validURL, options: NukeOptions.championLoading, into: self.championThumb)
            }
            self.championName.text = validChampion.name
        }
    }
}


// MARK: - Collection View Methods
extension NewItemSetViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedItems.count == 6 ? 6 : self.selectedItems.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemSetCollectionViewCell", for: indexPath) as? ItemSetCollectionViewCell {
            
            // If the Index Path IS NOT the same value as the total amount of the items in Selected Items Array,
            // display the item and set the delegate of it to this View Controller
            if indexPath.row != self.selectedItems.count {
                cell.setup(item: self.selectedItems[indexPath.row], delegate: self)
            } else {
                // Otherwise, setup it with nil values to display
                // the Add Item placeholder
                cell.setup(item: nil, delegate: nil)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.itemSetTextField.resignFirstResponder()
        
        // If the Index Path IS NOT the same value as the total amount of the items in Selected Items Array,
        // there is an Item in there and perform to the Detail of it
        if indexPath.row != self.selectedItems.count {
            self.performSegue(withIdentifier: "ItemDetailSegue", sender: self.selectedItems[indexPath.row])
        } else {
            // Otherwise, goes to the View to select a new Item
            self.performSegue(withIdentifier: "SelectItemSegue", sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 6) - 5
        return CGSize(width: width, height: width)
    }
}


// MARK: - Text Field Methods
extension NewItemSetViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - Champion Selection Delegate
extension NewItemSetViewController: ChampionSelectionDelegate {
    
    /// Method from Champion Selection Delegate to set the selected
    /// Champion to this view and show those information to the User
    ///
    /// - Parameter champion: Selected Champion to be displayed
    func selectChampion(champion: Champion) {
        self.selectedChampion = champion
        self.displayRightView()
        self.displayChampion()
    }
}


// MARK: - Item Selection Delegate
extension NewItemSetViewController: ItemSelectionDelegate {
    
    /// Method from Item Selection Delegate to set the selected
    /// Item to this view and show those information to the User
    /// only if there is not already 6 Items selected
    ///
    /// - Parameter item: Selected Item to be added to the list and displayed
    func selectItem(item: Item) {
        if self.selectedItems.count <= 5 {
            self.selectedItems.append(item)
            self.collectionView.reloadData()
        }
    }
}


// MARK: - Delete Item Cell Delegate
extension NewItemSetViewController: DeleteItemCellDelegate {
    
    /// Delegate method called when the Item is deleted via Collection View Cell delete action
    ///
    /// - Parameter cell: Current Collection View Cell
    func deleteItem(in cell: UICollectionViewCell) {
        
        // Gets the indexPath of the cell
        if let indexPath = self.collectionView.indexPath(for: cell) {
            
            // Remove the image from the datasource
            self.selectedItems.remove(at: indexPath.row)
            
            // Reload Collection View with the updated datasource
            self.collectionView.reloadData()
        }
    }
    
}
