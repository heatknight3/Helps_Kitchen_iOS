//
//  HostSeatingController.swift
//  Help's Kitchen
//
//  Created by Stephen Ulmer on 2/15/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit
import Firebase

class HostSeatingController: CustomTableViewController {
    
    let ref = FIRDatabase.database().reference(fromURL: DataAccess.URL)
    
    struct TableStatus {
        
        var status : String!
        var tables: [Table]!
    }
    var availableTables = TableStatus()
    var seatedTables = TableStatus()
    
    var tableArray = [TableStatus]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: "cell")
        fetchTables()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(handleNewReservation))
    }
    
    func handleLogout() {
        do{
            try FIRAuth.auth()?.signOut()
        }catch let logoutError {
            print(logoutError)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func handleNewReservation() {
        
        let newResController = NewReservationController()
        
        let navController = CustomNavigationController(rootViewController: newResController)
        
        present(navController, animated: true, completion: nil)
    }
    
    func initTableStructs() {
        
        tableArray = [TableStatus]()
        
        availableTables.status = "Available"
        seatedTables.status = "Seated"
        availableTables.tables = [Table]()
        seatedTables.tables = [Table]()
        
        tableArray.append(availableTables)
        tableArray.append(seatedTables)
    }
    
    func fetchTables() {
        
        ref.child("Tables").observe(.value, with: { (snapshot) in
            
            self.initTableStructs()
            
            print(snapshot)
            
            for eachTable in snapshot.children {
            
                let table = Table()
            
                if let dict = (eachTable as! FIRDataSnapshot).value as? [String : AnyObject] {
            
                    table.name = dict["name"] as! String?
                    table.key = (eachTable as!FIRDataSnapshot).key
                    table.status = dict["status"] as! String?
                    table.capacity = dict["capacity"] as! Int?
                    table.reservationName = dict["reservationName"] as! String?
            
                    if(table.status == "available"){
                        self.tableArray[0].tables.append(table)
                    }else if table.status == "seated"{
                        self.tableArray[1].tables.append(table)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tableArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableArray[section].status
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = CustomColor.UCFGold
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.black
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableArray[section].tables.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CustomTableCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableCell
        
        cell.textLabel?.text = tableArray[indexPath.section].tables[indexPath.row].name
        cell.setColors()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath[0] == 0 {
            let assignToTableController = AssignToTableController()
            assignToTableController.selectedTable = tableArray[indexPath.section].tables[indexPath.row]
            let navController = CustomNavigationController(rootViewController: assignToTableController)
            present(navController, animated: true, completion: nil)
        } else if indexPath[0] == 1 {
            let seatedController = SeatedTableViewController()
            seatedController.selectedTable = tableArray[indexPath.section].tables[indexPath.row]
            let navController = CustomNavigationController(rootViewController: seatedController)
            present(navController, animated: true, completion: nil)
        }
    }
}
