//
//  UserService.swift
//  Jitensha_iOS
//
//  Created by Vladimir Marinov on 04.06.16.
//  Copyright © 2016 Vladimir Marinov. All rights reserved.
//

import Foundation


public class UserService : NSObject {
    
    private var userInfo : UserModel!
    
    // MARK: Singleton Support
    class var sharedInstance : UserService {
        
        struct Singleton {
            static let instance = UserService()
        }
        
        if Singleton.instance.userInfo == nil {
            // Initialize new userInfo object
            Singleton.instance.userInfo = UserModel(username: Constants.emptyString, password: Constants.emptyString, token: Constants.emptyString )
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
            assert(self === UserService.sharedInstance, "Only one instance of SingletonClass allowed!")
        }
    }
    /*!
     * @discussion Save active user in the service
     * @param user Logged User
     * @return void
     */
    public func loginUser(user: UserModel) -> () {
        UserService.sharedInstance.userInfo = user;
    }
    // MARK: isLoggedIn
    /*!
     * @discussion Check if user is already logged in
     * @return YES if user is logged in
     */
    public func isLoggedIn() -> Bool {
        if let info = UserService.sharedInstance.userInfo {
            return info.token != (Constants.emptyString);
        }
        return false;
    }

}