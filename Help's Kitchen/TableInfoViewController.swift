//
//  TableInfoViewController.swift
//  Help's Kitchen
//
//  Created by Stephen Ulmer on 2/23/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit
import Firebase

class TableInfoViewController: CustomTableViewController {
    
    let ref = FIRDatabase.database().reference(fromURL: DataAccess.URL)
    
    var selectedTable: Table?
    
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
        
        navigationItem.title = "Tables"
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : CustomColor.amber500]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Order", style: .plain, target: self, action: #selector(handleNewOrder))
        // Do any additional setup after loading the view.
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleNewOrder() {
        let orderController = NewOrderViewController()
        orderController.selectedTable = self.selectedTable
        
        present(orderController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
