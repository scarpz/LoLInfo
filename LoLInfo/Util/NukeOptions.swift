//
//  NukeOptions.swift
//  LoLInfo
//
//  Created by Scarpz on 21/11/18.
//  Copyright © 2018 scarpz. All rights reserved.
//

import Foundation
import Nuke

/// Struct to store all the options of placeholder and visual transition used in Nuke
///
/// - championLoading: Option to display a Champion placeholder while download the real image
/// - itemLoading: Option to display a Item placeholder while download the real image
/// - skillLoading: Option to display a Skill placeholder while download the real image
/// - skinLoading: Option to display a Skin placeholder while download the real image
struct NukeOptions {
    
    static let championLoading = ImageLoadingOptions(placeholder: #imageLiteral(resourceName: "championPlaceholder"), transition: .fadeIn(duration: 0.3))
    static let itemLoading = ImageLoadingOptions(placeholder: #imageLiteral(resourceName: "itemPlaceholder"), transition: .fadeIn(duration: 0.3))
    static let skillLoading = ImageLoadingOptions(placeholder: #imageLiteral(resourceName: "skillPlaceholder"), transition: .fadeIn(duration: 0.3))
    static let skinLoading = ImageLoadingOptions(placeholder: #imageLiteral(resourceName: "championPlaceholder"), transition: .fadeIn(duration: 0.3))
}
