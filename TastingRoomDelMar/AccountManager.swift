//
//  AccountManager.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/22/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ParseCrashReporting
import ParseFacebookUtilsV4


class AccountManager: NSObject {

    static let sharedInstance = AccountManager()
    
    // ----------
    
    override init() {
        super.init()
        
        // Initialize
        
    }
    
    // FACEBOOK LOGIN
    @available(iOS 8.0, *)
    func loginWithFacebook(view: UIViewController) {
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email"], block: { (user: PFUser?, error: NSError?) -> Void in
            
            // Failure
            if error != nil {
                AlertManager.sharedInstance.displayAlert(view, title: "Error", message: (error?.localizedDescription)!)
                return
                
                // Success
            } else if FBSDKAccessToken.currentAccessToken() != nil {
                
                if let user = user {
                    
                    // Doesn't Exist
                    if user.isNew {
                        
                        AlertManager.sharedInstance.pushNotificationsAlert()
                        
                        view.performSegueWithIdentifier("fbsignin", sender: view)
                        
                        
                        // Does Exist
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            view.performSegueWithIdentifier("fblogin", sender: view)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        })
        
    }
    
    
    
}