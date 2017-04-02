//
//  ServerOrderViewController.swift
//  Help's Kitchen
//
//  Created by Stephen Ulmer on 4/1/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit
import Firebase

class ServerOrderViewController: CustomTableViewController {
    
    let ref = FIRDatabase.database().reference(fromURL: DataAccess.URL)
    
    struct OrderStatus {
        var status: String!
        var orders: [Order]!
    }
    
    var placedOrders = OrderStatus()
    var inProgressOrders = OrderStatus()
    var readyOrders = OrderStatus()
    var seeKitchenOrders = OrderStatus()
    
    var orderArray = [OrderStatus]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Orders"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))

        // Do any additional setup after loading the view.
        fetchOrders()
    }
    
    func handleLogout() {
        do{
            try FIRAuth.auth()?.signOut()
        }catch let logoutError {
            print(logoutError)
        }
        dismiss(animated: true, completion: nil)
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
    
    func fetchOrders() {
        
        initOrderStructs()
        
        ref.child("OrderList").observe(.value, with: { (snapshot) in
            
            for eachStatus in snapshot.children {
                
                let thisStatus = (eachStatus as! FIRDataSnapshot)
                
                if let stringArray = thisStatus.value as! [String]? {
                    
                    switch thisStatus.key{
                        case "Placed":
                            self.placedOrders.orders = self.getOrdersWith(keyArray: stringArray)
                        case "InProgress":
                            self.inProgressOrders.orders = self.getOrdersWith(keyArray: stringArray)
                        case "Ready":
                            self.readyOrders.orders = self.getOrdersWith(keyArray: stringArray)
                        case "SeeKitchen":
                            self.seeKitchenOrders.orders = self.getOrdersWith(keyArray: stringArray)
                    default:
                        print("Uh oh")
                    }
                }
            }
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getOrdersWith(keyArray: [String]) -> [Order]{
        
        var orders = [Order]()
        
        for key in keyArray{
            
            if key != ""  {
            
                ref.child("Orders").child(key).observeSingleEvent(of: .value, with: {(snapshot) in
                    let order = Order()
                    
                    if let dict = snapshot.value as! [String: AnyObject]? {
                        order.setValuesForKeys(dict)
                    }
                    
                    orders.append(order)
                    
                }, withCancel: { (error) in
                    print(error)
                })
                
                ref.child("Orders").child(key).removeAllObservers()
            }
        }
        
        return orders
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CustomTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableCell
        
        cell.textLabel?.text = orderArray[indexPath.section].orders[indexPath.row].item
        cell.setColors()
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return orderArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return orderArray[section].status
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = CustomColor.Yellow500
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.black
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderArray[section].orders.count
    }
    
}
