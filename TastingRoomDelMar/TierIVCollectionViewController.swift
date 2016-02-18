//
//  TierIVCollectionViewController.swift
//  TastingRoomDelMar
//
//  Created by Tobias Robert Brysiewicz on 1/13/16.
//  Copyright © 2016 Taylor 5, LLC. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import ParseCrashReporting

@objc
protocol TierIVCollectionViewDelegate {
    func tagsArrayCreation()
    func tierIVCollectionQuery()
    func tierIVTableQuery()
    func reloadTable()
}

class TierIVCollectionViewController: UICollectionViewController {
    
    var TierIVViewControllerRef: TierIVViewController?
    
    var delegate: TierIVCollectionViewDelegate?
    
    var tierIVCollectionArray: [PFObject]!
    var collectionArray = [PFObject]() {
        didSet {
            tierIVCollectionArray = collectionArray
        }
    }
    
// ------------------

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tierIVCollectionArray.count + 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("tierIVCollectionCell", forIndexPath: indexPath) as! TierIVCollectionViewCell

        cell.titleLabel?.font = UIFont(name: "NexaRustScriptL-00", size: 14)
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).CGColor
        cell.layer.cornerRadius = 10.0
        cell.clipsToBounds = true
        
        // Show All Cell
        if indexPath.row == 0 {
            
            cell.titleLabel?.text = "Show All"
            
        // Every Other Collection Cell
        } else {
        
            let trueIndex = indexPath.row - 1
            cell.titleLabel?.text = self.tierIVCollectionArray[trueIndex]["name"] as? String
            
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 3
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (4 * hardCodedPadding)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! TierIVCollectionViewCell
        selectedCell.layer.cornerRadius = 10.0
        selectedCell.clipsToBounds = true
        selectedCell.contentView.backgroundColor = UIColor.blackColor()
        selectedCell.titleLabel?.textColor = UIColor.whiteColor()
        
        // Show All 
        if indexPath.row == 0 {
            if route.count == 4 {
                route.removeAtIndex(3)
            }
            delegate?.tagsArrayCreation()
            delegate?.tierIVTableQuery()
            delegate?.reloadTable()
            
        // Filter By Selection
        } else {
        
            let trueIndex = indexPath.row - 1
            if !route.contains(tierIVCollectionArray[trueIndex]) {
            
                route.append(tierIVCollectionArray[trueIndex])
            
                for var index = 0; index < route.count; ++index {
                    print("The Route has been increased to: \(route[index]["name"]).")
                }
                print("-----------------------")
            
            } else {
            
                print("This selection is already being shown.")
            
            }
        
            delegate?.tagsArrayCreation()
            delegate?.tierIVTableQuery()
            delegate?.reloadTable()
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let deselectedCell = collectionView.cellForItemAtIndexPath(indexPath)! as! TierIVCollectionViewCell
        deselectedCell.contentView.backgroundColor = UIColor.whiteColor()
        deselectedCell.titleLabel?.textColor = UIColor.blackColor()
        
        if route.count == 4 {
            route.removeAtIndex(3)
        }
        
        delegate?.tagsArrayCreation()

    }

}
