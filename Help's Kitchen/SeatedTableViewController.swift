//
//  SeatedTableViewController.swift
//  Help's Kitchen
//
//  Created by Stephen Ulmer on 3/31/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit

class SeatedTableViewController: UIViewController {
    
    var selectedTable: Table?
    
    let statusLabel: UILabel = {
        let sl = UILabel()
        sl.backgroundColor = CustomColor.Yellow500
        sl.translatesAutoresizingMaskIntoConstraints = false
        
        return sl
    }()
    
    let tableCapacityLabel: UILabel = {
        let psl = UILabel()
        psl.backgroundColor = CustomColor.Yellow500
        psl.translatesAutoresizingMaskIntoConstraints = false
        
        return psl
    }()
    
    let reservationNameLabel: UILabel = {
        let rnl = UILabel()
        rnl.backgroundColor = CustomColor.Yellow500
        rnl.translatesAutoresizingMaskIntoConstraints = false
        
        return rnl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        navigationItem.title = selectedTable?.name
        
        setLabelValues()
        
        view.addSubview(statusLabel)
        view.addSubview(tableCapacityLabel)
        view.addSubview(reservationNameLabel)
        
        setupStatusLabel()
        setupTableCapacityLabel()
        setupReservationNameLabel()
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func setLabelValues() {
        statusLabel.text = selectedTable?.status
        tableCapacityLabel.text = String(describing: (selectedTable?.capacity)!)
        reservationNameLabel.text = selectedTable?.reservationName
    }
    
    func setupStatusLabel() {
        statusLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        statusLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        statusLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        statusLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupTableCapacityLabel() {
        tableCapacityLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 50).isActive = true
        tableCapacityLabel.leftAnchor.constraint(equalTo: statusLabel.leftAnchor).isActive = true
        tableCapacityLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        tableCapacityLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupReservationNameLabel() {
        reservationNameLabel.topAnchor.constraint(equalTo: tableCapacityLabel.bottomAnchor, constant: 50).isActive = true
        reservationNameLabel.leftAnchor.constraint(equalTo: statusLabel.leftAnchor).isActive = true
        reservationNameLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        reservationNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
