//
//  SignUpLogInTableViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/4/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseCrashReporting
import ParseFacebookUtilsV4
import Alamofire
import SwiftValidator



@objc
protocol SignUpLogInTableViewDelegate {
    func showSignUpButton()
    func hideSignUpButton()

}

class SignUpLogInTableViewController: UITableViewController {

    var signupActive = true
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registeredText: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var infoText: UITextView!
    
    var delegate: SignUpLogInTableViewDelegate?
    var containerViewController: SignUpViewController?
    
    var currentUser: PFUser?
    
    let validator = Validator()
    
    var emailIsValid: Bool = false
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var SignUpViewControllerRef: SignUpViewController?

// ------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.becomeFirstResponder()
        
        tableView.scrollEnabled = true
        
        validator.registerField(emailTextField, rules: [RequiredRule(), MinLengthRule(length: 2), MaxLengthRule(length: 14)])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
// ----------------------
// SAVE USER DATA
// ----------------------
    func saveUser() {
        
        let user = PFUser()
        
        user.username = emailTextField.text as String!
        user.email = emailTextField.text as String!
        user.password = passwordTextField.text as String!
        
        user.signUpInBackgroundWithBlock({ (success, error) -> Void in
            
            self.activityStop()
            
            if  error == nil {
                
                print("Successfully saved user data.")
                self.performSegueWithIdentifier("signup", sender: self)
                
            } else {
                
                print("Failed to save user data.")
                self.displayAlert("Failed Signup", message: "Please try again later.")
                
            }
            
        })
        
    }
    
// ------------------
// ALTERNATE LOGIN AND SIGN UP
// ------------------
    @IBAction func login(sender: AnyObject) {
        
        if signupActive == true {
            
            infoText.text = "Provide your email and password below to login."
            registeredText.text = "Don't have an account?"
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            signupActive = false
            
        } else {
            
            infoText.text = "Tell us a little bit about yourself. We'd love to get to know you!"
            registeredText.text = "Already Registered?"
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            signupActive = true
            
        }
    }
   
// ----------------------
// ACTIVITY START FUNCTION
// ----------------------
    func activityStart() {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
// ----------------------
// ACTIVITY STOP FUNCTION
// ----------------------
    func activityStop() {
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
// ----------------------
// ALERT FUNCTION
// ----------------------
    @available(iOS 8.0, *)
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            print("Ok")
        })
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
}


extension SignUpLogInTableViewController: ValidationDelegate {
    
    func validationSuccessful() {
        
        // submit the form 
        print("Validation Successful")
        self.emailIsValid = true
        delegate?.showSignUpButton()
        
    }
    
    func validationFailed(errors:[UITextField:ValidationError]) {
        
        // turn the fields to red
        print("Validation Failed")
        self.emailIsValid = false
        delegate?.hideSignUpButton()
        
    }
    
}