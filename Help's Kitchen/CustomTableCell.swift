//
//  CustomTableCell.swift
//  Help's Kitchen
//
//  Created by Stephen Ulmer on 2/15/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit

class CustomTableCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setColors() {
        self.textLabel?.textColor = CustomColor.Yellow500
        self.backgroundColor = UIColor.black
        self.textLabel?.alpha = 1
    }
    
    func setGreen() {
        
        
        self.textLabel?.textColor = CustomColor.green
        self.backgroundColor = UIColor.black
        
        self.textLabel?.alpha = 1
        UIView.animate(withDuration: 0.7, delay: 0.0, options: [.repeat, .autoreverse, ], animations:
            {
                self.textLabel?.alpha = 0
        }, completion: nil)
    }
    
    func flashColor() {
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            self.textLabel?.textColor = CustomColor.green
            self.backgroundColor = UIColor.black
        }
    }
    
    func setupTableNameLabel() {
        
    }

}


