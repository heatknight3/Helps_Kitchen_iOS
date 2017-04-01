//
//  NewReservationController.swift
//  Help's Kitchen
//
//  Created by Stephen Ulmer on 3/6/17.
//  Copyright © 2017 Stephen Ulmer. All rights reserved.
//

import UIKit
import Firebase

class NewReservationController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let ref = FIRDatabase.database().reference(fromURL: DataAccess.URL)
    
    var partySizeArray: [Int] {
        get{
            return [1,2,3,4,5,6,7,8]
        }
    }
    
    var pickedPartySize: Int? = 1
    
    let dateTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.date = NSDate.init() as Date
        picker.addTarget(self, action: #selector(dateTimeChanged), for: UIControlEvents.valueChanged)
        picker.minuteInterval = 5
        picker.setValue(CustomColor.Yellow500, forKey: "textColor")
        return picker
    }()
    
    let partySizePicker: UIPickerView = {
        let psp = UIPickerView()
        psp.translatesAutoresizingMaskIntoConstraints = false
        psp.setValue(CustomColor.Yellow500, forKey: "textColor")
        psp.tintColor = CustomColor.Yellow500
        
        return psp
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor.white
        
        return tf
    }()
    
    let errorLabel: UILabel = {
        let el = UILabel()
        el.textColor = UIColor.red
        
        
        return el
    }()
    
    func dateTimeChanged() {
        print(dateTimePicker.date)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(handleCreate))
        
        navigationItem.title = "Reservation"
        
        view.backgroundColor = UIColor.black
        
        view.addSubview(dateTimePicker)
        view.addSubview(partySizePicker)
        view.addSubview(nameTextField)
        
        setupDateTimePicker()
        setupPartySizePicker()
        setupNameTextField()
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleCreate() {
        
        var currentReservations: [String]?
    
        ref.child("ReservationQueue").observeSingleEvent(of: .value, with: {snapshot in
            
            var nameIsNotTaken = true
            
            currentReservations = snapshot.value as? [String]
            
            for res in currentReservations! {
                print(res.lowercased())
                print((self.nameTextField.text?.lowercased())!)
                
                if res.lowercased() == (self.nameTextField.text?.lowercased())! {
                    self.nameTextField.shake()
                    self.errorLabel.text = "Reservation name taken."
                    nameIsNotTaken = false
                }
            }
            
            if nameIsNotTaken {
            
                if currentReservations?[0] == "" {
                currentReservations?[0] = self.nameTextField.text!
                } else {
                currentReservations?.append(self.nameTextField.text!)
                }
            
                self.ref.child("ReservationQueue").setValue(currentReservations)
                
                let dateTime = self.dateTimePicker.date.description
                
                let partySize = self.pickedPartySize!
                
                self.ref.child("Reservations").child(self.nameTextField.text!).updateChildValues(["dateTime": dateTime, "partySize": partySize, "name":self.nameTextField.text!],withCompletionBlock: {(err, ref) in
                    
                    if err != nil {
                        print(err!)
                        return
                    }
                    
                    print("Saved user successfully")
                })
                
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func setupDateTimePicker() {
        dateTimePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        dateTimePicker.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        dateTimePicker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        dateTimePicker.bottomAnchor.constraint(equalTo: dateTimePicker.topAnchor, constant: 100).isActive = true
    }
    
    func setupPartySizePicker() {
        partySizePicker.delegate = self
        partySizePicker.dataSource = self
        partySizePicker.reloadAllComponents()
        
        partySizePicker.topAnchor.constraint(equalTo: dateTimePicker.bottomAnchor, constant: 50).isActive = true
        partySizePicker.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        partySizePicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        partySizePicker.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setupNameTextField(){
        nameTextField.topAnchor.constraint(equalTo: partySizePicker.bottomAnchor, constant: 50).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: 150).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return partySizeArray.count
    }
    
    
    internal func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let rowString = NSAttributedString(string: String(partySizeArray[row]), attributes: [NSForegroundColorAttributeName : CustomColor.Yellow500])
        
        return rowString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedPartySize = partySizeArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }

}

//Lucas's sexy ass animation (oh yas bby - Stephen)
extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
