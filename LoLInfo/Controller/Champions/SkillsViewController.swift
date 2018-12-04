//
//  SkillsViewController.swift
//  LoLInfo
//
//  Created by Scarpz on 27/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import UIKit
import Nuke

class SkillsViewController: UITableViewController {
    
    
    // MARK: - Outlets
    // Passive
    @IBOutlet weak var passiveImage: UIImageView!
    @IBOutlet weak var passiveName: UILabel!
    @IBOutlet weak var passiveDescription: UILabel!
    
    // Skills
    @IBOutlet var skillsImage: [UIImageView]!
    @IBOutlet var skillsName: [UILabel]!
    @IBOutlet var skillsDescription: [UILabel]!
    
    
    // MARK: - Properties
    var passive: Skill!
    var skills = [Skill]()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displaySkills()
    }
}


// MARK: - Private Methods
extension SkillsViewController {
    
    private func displaySkills() {
        
        if let passiveURL = URL(string: self.passive.thumbURL) {
            loadImage(with: passiveURL, options: NukeOptions.skillLoading, into: self.passiveImage)
        }
        self.passiveName.text = self.passive.name
        self.passiveDescription.text = self.passive.description.formatRiotDescription()
        
        for index in 0..<self.skills.count {
            
            if let skillURL = URL(string: self.skills[index].thumbURL) {
                loadImage(with: skillURL, options: NukeOptions.skillLoading, into: self.skillsImage[index])
            }
            self.skillsName[index].text = self.skills[index].name
            self.skillsDescription[index].text = self.skills[index].description.formatRiotDescription()
        }
    }
}


// MARK: - Table View Metohds
extension SkillsViewController {
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
