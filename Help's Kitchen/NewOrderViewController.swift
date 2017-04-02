//
//  NewOrderViewController.swift
//  Help's Kitchen
//
//  Created by Stephen Ulmer on 4/1/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit

class NewOrderViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        let newFoodController = NewFoodViewController()
        
        let tabOne = CustomNavigationController(rootViewController: newFoodController)
        
        let tabOneBarItem = UITabBarItem(title: "Food", image: nil, selectedImage: nil)
        
        tabOne.tabBarItem = tabOneBarItem
        
        let newDrinkController = NewDrinkViewController()
        
        let tabTwo = CustomNavigationController(rootViewController: newDrinkController)
        
        let tabTwoBarItem = UITabBarItem(title: "Drink", image: nil, selectedImage: nil)
        
        tabTwo.tabBarItem = tabTwoBarItem
        
        self.viewControllers = [tabOne, tabTwo]
    }

    

}
