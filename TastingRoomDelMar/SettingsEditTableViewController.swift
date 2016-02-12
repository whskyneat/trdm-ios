//
//  SettingsEditTableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/11/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseUI

@objc
protocol SettingsEditTableViewDelegate {
    
}

class SettingsEditTableViewController: UITableViewController {
    
    var delegate: SettingsEditTableViewDelegate?
    
    var passedEditType: String!
    
    // User Selection Values
    var passedMessage: String!
    var passedPlaceholder: String!
    
    var fieldValue: String!
    
    @IBOutlet weak var editMessageTextView: UITextView!
    @IBOutlet weak var editValueTextField: UITextField!
    
    
// ---------------------------
    override func viewWillAppear(animated: Bool) {
        print("passedEditType is equal to: \(passedEditType)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Message
        editMessageTextView.text = passedMessage
        editMessageTextView.textAlignment = .Center
        editMessageTextView.font = UIFont(name: "OpenSans", size: 12)
        editMessageTextView.textColor = UIColor.grayColor()
        // Text Field
        editValueTextField.placeholder = passedPlaceholder
        editValueTextField.textAlignment = .Left
        editValueTextField.font = UIFont(name: "OpenSans", size: 20)
        editValueTextField.becomeFirstResponder()
        

        
        tableView.tableFooterView = UIView(frame: CGRectZero)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    

    
    func valueToSave() {
        
        if passedEditType == "First name" {
            
            fieldValue = editValueTextField.text
            PFUser.currentUser()?["firstName"] = fieldValue
            print("User changed their first name to: \(fieldValue)")
            
        } else if passedEditType == "Last name" {
            
            
        } else if passedEditType == "mobile number" {
            
            
        } else if passedEditType == "email" {
            
            
        } else if passedEditType == "password" {
            
            
        }
        
    }
    
    func saveValue() {
        
        print("fieldValue: \(fieldValue)")
        valueToSave()
        
        print("User: \(PFUser.currentUser())")
        
        PFUser.currentUser()?.saveInBackground()
        print("User has been updated successfully.")
        
    }

}
