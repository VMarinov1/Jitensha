//
//  RegisterViewController.swift
//  Jitensha_iOS
//
//  Created by Vladimir Marinov on 04.06.16.
//  Copyright © 2016 Vladimir Marinov. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register";
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        navigationController?.setNavigationBarHidden(false, animated: false);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func register(sender: AnyObject) {
        let username = self.loginTextField.text
        let password = self.passwordTextField.text
        AuthService.sharedInstance.registerWithCompletionHandler(username!, password: password!) { (error) -> Void in
            if ((error) != nil) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let alert = UIAlertController(title: Constants.errorTitleResponse, message: error, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.showMainForm();
                })
            }
        }
    }

}