//
//  NewFoodViewController.swift
//  Help's Kitchen
//
//  Created by Stephen Ulmer on 4/2/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit
import Firebase

class NewFoodViewController: CustomTableViewController {
    
    let ref = FIRDatabase.database().reference(fromURL: DataAccess.URL)
    
    struct FoodType {
        var type: String!
        var items: [MenuItem]!
    }
    
    var appetizers = FoodType()
    var desserts = FoodType()
    var entrees = FoodType()
    var sides = FoodType()
    
    var foodArray = [FoodType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))

        // Do any additional setup after loading the view.
    }
    
    func initOrderStructs() {
        
        orderArray = [OrderStatus]()
        
        placedOrders.status = "Placed"
        inProgressOrders.status = "In Progress"
        readyOrders.status = "Ready"
        seeKitchenOrders.status = "See Kitchen"
        
        placedOrders.orders = [Order]()
        inProgressOrders.orders = [Order]()
        readyOrders.orders = [Order]()
        seeKitchenOrders.orders = [Order]()
        
        orderArray.append(placedOrders)
        orderArray.append(inProgressOrders)
        orderArray.append(readyOrders)
        orderArray.append(seeKitchenOrders)
        
    }
    
    func initFoodTypes() {
        
        foodArray = [FoodType]()
        
        appetizers.type = "Appetizers"
        desserts.type = "Desserts"
        entrees.type = "Entrees"
        sides.type = "Sides"
        
        appetizers.items = [MenuItem]()
        desserts.items = [MenuItem]()
        entrees.items = [MenuItem]()
        sides.items = [MenuItem]()
        
        foodArray.append(appetizers)
        foodArray.append(desserts)
        foodArray.append(entrees)
        foodArray.append(sides)
    }
    
    func fetchFoods(){
        
        ref.child("Menu").child("Food").observeSingleEvent(of: .value, with: { (snapshot) in
            
            initFoodTypes()
            
            for eachFoodType in snapshot.children {
                let thisFoodType = eachFoodType as! FIRDataSnapshot
                
                switch thisFoodType.key {
                case "Appetizers":
                    appetizers.items
                }
            }
            
        })
        
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
