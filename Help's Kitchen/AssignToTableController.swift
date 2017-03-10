//
//  AssignToTableController.swift
//  Help's Kitchen
//
//  Created by Stephen Ulmer on 2/17/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit
import Firebase

class AssignToTableController: CustomTableViewController {
    
    let ref = FIRDatabase.database().reference(fromURL: DataAccess.URL)
    
    var selectedTable: Table?
    
    var reservationIds = [String]()
    var reservations = [Reservation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: "cell")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        fetchSeatingQueue()

        // Do any additional setup after loading the view.
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchSeatingQueue() {
        
        ref.child("ReservationQueue").observe(.value, with: { (snapshot) in
            print(snapshot)
            self.reservationIds = ((snapshot.value) as! [String])
            
            
        })
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            for eachRes in snapshot.children {
                
                let thisRes = eachRes as! FIRDataSnapshot
                
                if (self.reservationIds.contains(thisRes.key)){
                    
                    if let dict = thisRes.value as? [String: AnyObject] {
                        
                        let tempReservation = Reservation()
                        
                        tempReservation.name = dict["name"] as? String
                        tempReservation.partySize = dict["partySize"] as? Int
                        tempReservation.key = thisRes.key
                        
                        self.reservations.append(tempReservation)
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //TODO: Add overrides for num section, etc.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = reservations[indexPath.row].name
        cell.textLabel?.textColor = CustomColor.amber500
        cell.backgroundColor = UIColor.black
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //add to table
        ref.child("Tables").child((selectedTable?.key)!).child("reservationName").setValue(reservations[indexPath.row].name)
        
        //change table status
        ref.child("Tables").child((selectedTable?.key)!).child("tableStatus").setValue("seated")
        
        //remove from seatingQueue
        removeUserFromQueue(index: indexPath.row)
    }
    
    func removeUserFromQueue(index: Int){
        
        var tempQueue = [String]()
        
        for res in reservations {
            tempQueue.append(res.key!)
        }
        
        if tempQueue.count == 1 {
            tempQueue[index] = ""
        }else {
            tempQueue.remove(at: index)
        }
        
        ref.child("ReservationQueue").setValue(tempQueue)
        
        dismiss(animated: true, completion: nil)
    }
    
}
