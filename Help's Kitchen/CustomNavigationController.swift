//
//  CustomNavigationController.swift
//  Help's Kitchen
//
//  Created by Stephen Ulmer on 2/15/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = CustomColor.Grey900
        navigationBar.tintColor = CustomColor.Yellow500
        navigationBar.isTranslucent = false
        
        let titleDict = [NSForegroundColorAttributeName: CustomColor.Yellow500]
        navigationBar.titleTextAttributes = titleDict
    }

}
