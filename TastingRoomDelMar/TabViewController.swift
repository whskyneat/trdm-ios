//
//  TabViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 2/3/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import Parse


class TabViewController: UIViewController {

    var nav: UINavigationBar?
    
    @IBOutlet weak var navigationTitle: UINavigationItem!

    var TabTableViewControllerRef: TabTableViewController?
    var TabFloatingTableViewControllerRef: TabFloatingTableViewController?
    
    var tab = TabManager.sharedInstance.currentTab
    var orders = CardManager.sharedInstance.currentCustomer
    

// ---------------
//    override func isViewLoaded() -> Bool {
//        // Guard against items indicator ever showing
//        TabManager.sharedInstance.removeItemsIndicator() // Not Fully Functional
//        return true
//    }
    
    override func viewWillAppear(animated: Bool) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TabManager.sharedInstance.setWineDiscountValues()
        print("Discount Wine Bottle Count: \(TabManager.sharedInstance.wineBottleCount)")
        TabManager.sharedInstance.setBeerDiscountValues()
        print("Discount Beer Bottle Count: \(TabManager.sharedInstance.beerBottleCount)")
        
        // Remove Indicator
        let currentWindow: UIWindow = UIApplication.sharedApplication().keyWindow!
        
        if let viewWithTag = currentWindow.viewWithTag(31) {
            viewWithTag.removeFromSuperview()
        }
        
        
        if printFlag {
            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@")
            print("TAB: \(tab)")
            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@")

            print("-----------------------------")
            print("Lines: \(tab.lines.count)")
            print("Orders: \(orders.orderId.count)")
            print("-----------------------------")
        }
        
        defaultScreen()

        // NAV BAR STYLES
        if let navBar = navigationController?.navigationBar {
            
            nav = navBar
            
            navigationTitle.title = "My Tab"
            nav?.barStyle = UIBarStyle.Black
            nav?.tintColor = UIColor.whiteColor()
            nav?.titleTextAttributes = [ NSFontAttributeName: UIFont.scriptFont(24)]
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backToMenu() {
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        
        // Add Indicator
        TabManager.sharedInstance.addItemsIndicator()
        
    }
    
    // Go To Add Payment
    func goToHistory() {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "HistoryStoryboard", bundle: nil)
        
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("History")
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func menu(sender: AnyObject) {
        
//        if let parentVC = self.parentViewController {
//            if let parentVC = parentVC as? PopoverViewController {
//                parentVC.dismissViewControllerAnimated(true, completion: nil)
//            }
//        }
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        
        // Add Indicator
        TabManager.sharedInstance.addItemsIndicator()
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        AlertManager.sharedInstance.reloadDelegate = self

        
        if segue.identifier == "tabTableEmbeded" {
            
            if let TabTableViewController = segue.destinationViewController as? TabTableViewController {
                
                self.TabTableViewControllerRef = TabTableViewController
                TabTableViewController.delegate = self


            }
        }
        
        if segue.identifier == "tabFloatingEmbeded" {
            
            if let TabFloatingTableViewController = segue.destinationViewController as? TabFloatingTableViewController {
                
                self.TabFloatingTableViewControllerRef = TabFloatingTableViewController
                TabFloatingTableViewController.delegate = self

                
            }
        }
    }
}


extension TabViewController: TabTableViewDelegate, TabFloatingTableViewDelegate, TabReloadDelegate {
    
    
    
    func defaultScreen() {
        
        // Default Empty Tab View
        if TabManager.sharedInstance.currentTab.lines.count < 1 {
            
            let tabView = self.view
            // Screen Bounds
            let windowWidth = self.view.bounds.size.width
            let windowHeight = self.view.bounds.size.height
            // Create View
            let windowView = UIView(frame: CGRectMake(0, 0, windowWidth, windowHeight))
            windowView.backgroundColor = UIColor.whiteColor()
            windowView.layer.zPosition = 98
            // Create TRDM Logo
            let TRDMLogo = "secondary-logomark-03_rgb_600_600"
            let TRDMImage = UIImage(named: TRDMLogo)
            let TRDMImageView = UIImageView(image: TRDMImage)
            TRDMImageView.frame = CGRectMake(0, 0, windowWidth * 0.8, windowWidth * 0.8)
            TRDMImageView.frame.origin.y = windowHeight / 6
            TRDMImageView.frame.origin.x = windowWidth * 0.1
            TRDMImageView.alpha = 0.1
            TRDMImageView.layer.zPosition = 99
            // Create Message Text View
            let messageTextView = UITextView(frame: CGRectMake(0, 0, windowWidth * 0.7, windowWidth / 2))
            messageTextView.frame.origin.y = windowHeight * 0.65
            messageTextView.frame.origin.x = windowWidth * 0.15
            
            
            if PFUser.currentUser()!.username != nil {
                messageTextView.text = "Looks like you don't have any items on your tab."
            } else {
                messageTextView.text = "Looks like you aren't logged in. Please log in to add items to your tab."
            }
            
            
            messageTextView.font = UIFont.basicFont(16)
            messageTextView.textColor = UIColor.grayColor()
            messageTextView.backgroundColor = UIColor.clearColor()
            messageTextView.userInteractionEnabled = false
            messageTextView.textAlignment = .Center
            messageTextView.layer.zPosition = 99
            
            
            
            
            // Add Created Views
            tabView.addSubview(windowView)
            tabView.addSubview(TRDMImageView)
            tabView.addSubview(messageTextView)

            
            if PFUser.currentUser()!.username != nil {
                // Create Back To Menu Button
                let menuButton = UIButton(frame: CGRectMake(0, 0, windowWidth * 0.4625, windowHeight / 10))
                menuButton.frame.origin.y = windowHeight * 0.78
                menuButton.frame.origin.x = windowWidth * 0.025
                menuButton.setTitle("Back to Menu", forState: .Normal)
                menuButton.layer.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).CGColor
                menuButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
                menuButton.titleLabel?.font = UIFont.scriptFont(20)
                menuButton.layer.cornerRadius = 12.0
                menuButton.clipsToBounds = true
                menuButton.addTarget(self, action: #selector(TabViewController.backToMenu), forControlEvents: UIControlEvents.TouchUpInside)
                menuButton.layer.zPosition = 99
                // Create Order History Button
                let historyButton = UIButton(frame: CGRectMake(0, 0, windowWidth * 0.4625, windowHeight / 10))
                historyButton.frame.origin.y = windowHeight * 0.78
                historyButton.frame.origin.x = (windowWidth * 0.05) + (windowWidth * 0.4625)
                historyButton.setTitle("Order History", forState: .Normal)
                historyButton.layer.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).CGColor
                historyButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
                historyButton.titleLabel?.font = UIFont.scriptFont(20)
                historyButton.layer.cornerRadius = 12.0
                historyButton.clipsToBounds = true
                historyButton.addTarget(self, action: #selector(TabViewController.goToHistory), forControlEvents: UIControlEvents.TouchUpInside)
                historyButton.layer.zPosition = 99
                
                
                tabView.addSubview(menuButton)
                tabView.addSubview(historyButton)
                
                
            } else {
                // Create Back To Menu Button
                let menuButton = UIButton(frame: CGRectMake(0, 0, windowWidth * 0.95, windowHeight / 10))
                menuButton.frame.origin.y = windowHeight * 0.78
                menuButton.frame.origin.x = windowWidth * 0.025
                menuButton.setTitle("Back to Menu", forState: .Normal)
                menuButton.layer.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).CGColor
                menuButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
                menuButton.titleLabel?.font = UIFont.scriptFont(20)
                menuButton.layer.cornerRadius = 12.0
                menuButton.clipsToBounds = true
                menuButton.addTarget(self, action: #selector(TabViewController.backToMenu), forControlEvents: UIControlEvents.TouchUpInside)
                menuButton.layer.zPosition = 99
                
                
                tabView.addSubview(menuButton)
                
                
            }
            
            
        }
    }
    
    func getView() -> UIView {
        
        let tabView = self.view
        
        return tabView
        
    }
    
    func getController() -> UIViewController {
        
        let tabController = self
        
        return tabController
    }
    
    func recalculateTotals() {
        
        self.TabFloatingTableViewControllerRef?.tableView.reloadData()
        
    }
    
    func recalculateLineItems() {
        
        self.TabTableViewControllerRef?.tableView.reloadData()
        
    }
}