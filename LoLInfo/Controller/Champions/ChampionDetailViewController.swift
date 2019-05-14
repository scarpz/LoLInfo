//
//  ChampionDetailViewController.swift
//  LoLInfo
//
//  Created by Scarpz on 22/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit
import Nuke

class ChampionDetailViewController: UITableViewController {
    
    
    // MARK: - Outlets
    // Basic Info
    @IBOutlet weak var championThumb: UIImageView!
    @IBOutlet weak var championName: UILabel!
    @IBOutlet weak var championTitle: UILabel!
    
    // Info Bar to get a size of it
    @IBOutlet weak var infoBar: UIView!
    
    // Info
    @IBOutlet weak var attackConstraint: NSLayoutConstraint!
    @IBOutlet weak var defenseConstraint: NSLayoutConstraint!
    @IBOutlet weak var magicConstraint: NSLayoutConstraint!
    @IBOutlet weak var difficultyConstraint: NSLayoutConstraint!
    
    // Stats
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var manaLabel: UILabel!
    @IBOutlet weak var damageLabel: UILabel!
    @IBOutlet weak var armorLabel: UILabel!
    @IBOutlet weak var mrLabel: UILabel!
    @IBOutlet weak var moveSpeedLabel: UILabel!
    
    // Skills
    @IBOutlet weak var passiveSkill: UIImageView!
    @IBOutlet weak var qSkill: UIImageView!
    @IBOutlet weak var wSkill: UIImageView!
    @IBOutlet weak var eSkill: UIImageView!
    @IBOutlet weak var rSkill: UIImageView!
    
    // Skins
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    // MARK: - Properties
    var champion: Champion!
    let patch = PatchServices.getPatchFromUserDefaults()!
    private var loading: LoadingView!
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupChampionDetailView()
        self.loadChampionDetail()
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SkinSegue" {
            if let navBar = segue.destination as? UINavigationController {
                if let skinVC = navBar.viewControllers[0] as? SkinViewController {
                    if let skin = sender as? Skin {
                        skinVC.skin = skin
                    }
                }
            }
        } else if segue.identifier == "SkillSegue" {
            if let skillsVC = segue.destination as? SkillsViewController {
                if let championDetail = self.champion.championDetail {
                    skillsVC.passive = championDetail.passive
                    skillsVC.skills = championDetail.skills
                }
            }
        }
    }
}


// MARK: - Private Methods
extension ChampionDetailViewController {
    
    /// Method responsible to setup all the stuff of this View Controller
    /// Set all the information about the Collection View Datasource and Delegate.
    /// It also puts the name of the current Champion in the Nav Bar
    private func setupChampionDetailView() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let mainWindow = appDelegate.window else { return }
        
        self.loading = LoadingView(frame: mainWindow.frame)
        
        self.navigationItem.title = self.champion.name
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    /// Method responsible to get all the details about the selected Champion
    private func loadChampionDetail() {
        
        self.loading.show()
        
        ChampionServices.getChampionDetail(by: self.champion.stringId, championDetail: { [unowned self] championDetail in
            self.champion.championDetail = championDetail
            
            DispatchQueue.main.async {
                self.displayChampionDetails()
                self.collectionView.reloadData()
            }
        }) { [unowned self] error in
            DispatchQueue.main.async {
                self.createAlert(title: "Error", message: error.localizedDescription, action1Text: "Retry", action1: { [unowned self] _ in
                    self.loadChampionDetail()
                    }, action2Text: "Cancel", action2: { [unowned self] _ in
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                            self.loading.hide()
                        }
                })
            }
        }
    }
    
    /// Method responsible to display all the information about the Champion
    private func displayChampionDetails() {
        
        // Guarantees the image URL
        guard let thumbURL = URL(string: self.champion.thumbURL.replacingOccurrences(of: "{{patch}}", with: self.patch)) else {
            return
        }
        
        // Display the image (Nuke pod)
        loadImage(with: thumbURL, options: NukeOptions.championLoading, into: self.championThumb)
        
        // Fill the name and title of the Champion
        self.championName.text = self.champion.name
        self.championTitle.text = self.champion.title
        
        // Guarantees the details inside the Champion.
        // It's not 100% necessary because this function is called after
        // a verification of the API but just to make sure
        if let championDetail = self.champion.championDetail {
            
            // Display Infos (attack, defense, magic, difficulty)
            self.displayChampionInfo(infos: championDetail.info)
            // Display Stats (HP, Mana, Damage, etc)
            self.displayChampionStats(stats: championDetail.stats)
            // Display all the Skills of the Champion
            self.displaySkills(passive: championDetail.passive, skills: championDetail.skills)
            
            // Set the paging of Skins of tbe Champion
            self.pageControl.numberOfPages = championDetail.skins.count
        }
        
        self.loading.hide()
    }
    
    /// Method responsible to set up the bars of Champion Info
    /// (attack, defense, magic and difficulty)
    ///
    /// - Parameter infos: Champion Info
    private func displayChampionInfo(infos: ChampionInfo) {
        
        let size = self.infoBar.frame.width
        
        // Attack
        let attackSize = size * CGFloat(infos.attack) / 10
        self.attackConstraint.constant = size - attackSize
        
        // Defense
        let defenseSize = size * CGFloat(infos.defense) / 10
        self.defenseConstraint.constant = size - defenseSize
        
        // Magic
        let magicSize = size * CGFloat(infos.magic) / 10
        self.magicConstraint.constant = size - magicSize
        
        // Difficulty
        let difficultySize = size * CGFloat(infos.difficulty) / 10
        self.difficultyConstraint.constant = size - difficultySize
    }

    /// Method responsible to set up the values of Champion Stats
    /// (HP, MP, Damage, Armor, Magic Resist and Move Speed)
    ///
    /// - Parameter stats: Champion Stats
    private func displayChampionStats(stats: ChampionStats) {
        
        self.hpLabel.text = self.formatStat(baseValue: stats.hp, valuePerLevel: stats.hpPerLevel)
        self.manaLabel.text = self.formatStat(baseValue: stats.mp, valuePerLevel: stats.mpPerLevel)
        self.damageLabel.text = self.formatStat(baseValue: stats.damage, valuePerLevel: stats.damagePerLevel)
        self.armorLabel.text = self.formatStat(baseValue: stats.armor, valuePerLevel: stats.armorPerLevel)
        self.mrLabel.text = self.formatStat(baseValue: stats.magicResist, valuePerLevel: stats.mpPerLevel)
        self.moveSpeedLabel.text = self.formatStat(baseValue: stats.moveSpeed, valuePerLevel: nil)
    }
    
    /// Method responsible to display all the skills of the Champion
    ///
    /// - Parameters:
    ///   - passive: Passive Skill
    ///   - skills: Active Skills
    private func displaySkills(passive: Skill, skills: [Skill]) {
        
        // Guarantees all the string URLs
        if let passiveURL = URL(string: passive.thumbURL.replacingOccurrences(of: "{{patch}}", with: self.patch)),
            let qURL = URL(string: skills[0].thumbURL.replacingOccurrences(of: "{{patch}}", with: self.patch)),
            let wURL = URL(string: skills[1].thumbURL.replacingOccurrences(of: "{{patch}}", with: self.patch)),
            let eURL = URL(string: skills[2].thumbURL.replacingOccurrences(of: "{{patch}}", with: self.patch)),
            let rURL = URL(string: skills[3].thumbURL.replacingOccurrences(of: "{{patch}}", with: self.patch)) {
            
            // Fill the skill images (Nuke)
            loadImage(with: passiveURL, options: NukeOptions.skillLoading, into: self.passiveSkill)
            loadImage(with: qURL, options: NukeOptions.skillLoading, into: self.qSkill)
            loadImage(with: wURL, options: NukeOptions.skillLoading, into: self.wSkill)
            loadImage(with: eURL, options: NukeOptions.skillLoading, into: self.eSkill)
            loadImage(with: rURL, options: NukeOptions.skillLoading, into: self.rSkill)
        }
    }
    
    /// Method responsible to format the value of a status to display in the view
    /// in a right way
    ///
    /// - Parameters:
    ///   - baseValue: Base value of a stat
    ///   - valuePerLevel: Value earned per level of the stat
    /// - Returns: Returns a formatted String to be displayed in the view
    private func formatStat(baseValue: Double, valuePerLevel: Double?) -> String {
        if let validValuePerLevel = valuePerLevel {
            return "\(self.format(baseValue))\n(\(self.format(validValuePerLevel)) per level)"
        } else {
            return self.format(baseValue)
        }
    }
    
    /// Method to check the amount of decimal places, if the number is not natural
    ///
    /// - Parameter value: Value to be checked
    /// - Returns: A String value of the number without any decimal place or a number with only 2 decimal places
    private func format(_ value: Double) -> String {
        if value == rint(value) {
            return "\(Int(value))"
        } else {
            return String(format: "%.2f", value)
        }
    }
}


// MARK: - Table View Methods
extension ChampionDetailViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            self.performSegue(withIdentifier: "SkillSegue", sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: - Collection View Methods
extension ChampionDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.champion.championDetail?.skins.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkinCollectionViewCell", for: indexPath) as? SkinCollectionViewCell {
            
            if let skins = self.champion.championDetail?.skins {
                cell.setup(skin: skins[indexPath.row])
                return cell
            } else {
                return UICollectionViewCell()
            }
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let skins = self.champion.championDetail?.skins {
            self.performSegue(withIdentifier: "SkinSegue", sender: skins[indexPath.row])
        }
    }
    
    /// Method used to get the current visible cell of the Collection View and its index to select
    /// the right page of the Page Control
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint)
        
        self.pageControl.currentPage = visibleIndexPath?.row ?? 0
    }
}

