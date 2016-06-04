//
//  LoginService.swift
//  Jitensha_iOS
//
//  Created by Vladimir Marinov on 04.06.16.
//  Copyright © 2016 Vladimir Marinov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class AuthService : NSObject {

    
    // MARK: Singleton Support
    class var sharedInstance : AuthService {
        
        struct Singleton {
            static let instance = AuthService()
        }
        
        
        return Singleton.instance
    }
    
    override init() {
        super.init()
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(0.1 * Double(NSEC_PER_SEC))
        ), dispatch_get_main_queue()) {
            assert(self === AuthService.sharedInstance, "Only one instance of SingletonClass allowed!")
        }
    }
    // MARK:Login
    
    /*!
     * @discussion Login method with handler
     * @param username Username
     * @param password Password
     * @param completionHandler Completion method to catch loagin process
     */
    public func loginWithCompletionHandler(username: String, password: String, completionHandler: ((error: String?) -> Void)!) -> () {
        let parameters = [
            Constants.emailKeyString: username, //email
            Constants.passworKeyString: password //password
        ]
        let url = String(format: "%@%@", Constants.baseUrl, Constants.loginAPIUrl);
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                if let value: AnyObject = response.result.value {
                    //Handle the results as JSON
                    let post = JSON(value)
                    if post[Constants.accessTokenKeyString].string != nil {
                        let accessToken = post[Constants.accessTokenKeyString].string;
                        UserService.sharedInstance.loginUser(UserModel(username: username, token: accessToken));
                        completionHandler(error: nil);
                    } else if post[Constants.messageKeyString].string != nil {
                        completionHandler(error: post[Constants.messageKeyString].string );
                    }
                    else if let _: AnyObject = response.result.error {
                        completionHandler(error:response.result.description);
                    }
                }
                else if let _: AnyObject = response.result.error {
                     completionHandler(error:response.result.description);
                }
                else {
                    completionHandler(error:Constants.invalidResponse);
                }
        }
        
    }
    /*!
     * @discussion Login method with handler
     * @param username Username
     * @param password Password
     * @param completionHandler Completion method to catch loagin process
     */
    public func registerWithCompletionHandler(username: String, password: String, completionHandler: ((error: String?) -> Void)!) -> () {
        let parameters = [
            Constants.emailKeyString: username, //email
            Constants.passworKeyString: password //password
        ]
        //   var statusCode: Int = 0
        let url = String(format: "%@%@", Constants.baseUrl, Constants.registerAPIUrl);
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                //  statusCode = (response.response?.statusCode)! //Gets HTTP status code, useful for debugging
                if let value: AnyObject = response.result.value {
                    //Handle the results as JSON
                    let post = JSON(value)
                    if post[Constants.accessTokenKeyString].string != nil {
                        let accessToken = post[Constants.accessTokenKeyString].string;
                        UserService.sharedInstance.loginUser(UserModel(username: username, token: accessToken));
                        completionHandler(error: nil);
                    } else if post[Constants.messageKeyString].string != nil {
                        completionHandler(error: post[Constants.messageKeyString].string );
                    }
                }
                else if let _: AnyObject = response.result.error {
                    completionHandler(error:response.result.description);
                }
                else {
                    completionHandler(error:Constants.invalidResponse);
                }
        }
        
    }
        // MARK:Logout
}