//
//  RentRequestViewController.swift
//  Jitensha_iOS
//
//  Created by Vladimir Marinov on 05.06.16.
//  Copyright © 2016 Vladimir Marinov. All rights reserved.
//

import Foundation
import BXProgressHUD
import UIKit

class RentRequestViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var expirationTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: IBActions
    /*!
     * @discussion Called when Cancel button pressed
     */
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    /*!
     * @discussion Called when Request button pressed
     */
    @IBAction func requestPressed(sender: AnyObject) {
        BXProgressHUD.showHUDAddedTo(self.view);
        RentService.sharedInstance.rentABikeWithCompletionHandler( numberTextField.text!, cardName: nameTextField.text!, expiration: expirationTextField.text!, code: codeTextField.text!) { (error) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                BXProgressHUD.hideHUDForView(self.view);
                if ((error) != nil) {
                    let alert = UIAlertController(title: Constants.errorTitleResponse, message: error, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: Constants.dismissButtonLabel, style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: Constants.successRentedTitleResponse, message: error, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: Constants.dismissButtonLabel, style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.dismissViewControllerAnimated(false, completion: nil);

                }
            })
        }
        
    }
}