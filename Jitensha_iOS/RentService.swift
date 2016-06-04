//
//  RentService.swift
//  Jitensha_iOS
//
//  Created by Vladimir Marinov on 05.06.16.
//  Copyright © 2016 Vladimir Marinov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class RentService : NSObject {
    
    public private(set) var placesArray : NSMutableArray
    
    // MARK: Singleton Support
    class var sharedInstance : RentService {
        
        struct Singleton {
            static let instance = RentService()
        }
        
        return Singleton.instance
    }
    override init() {
        self.placesArray = NSMutableArray();
        super.init()
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(0.1 * Double(NSEC_PER_SEC))
        ), dispatch_get_main_queue()) {
            assert(self === RentService.sharedInstance, "Only one instance of SingletonClass allowed!")
        }
    }
    /*!
     * @discussion lrequest rent with card data
     * @param completionHandler Completion method to catch result process
     */
    public func rentABikeWithCompletionHandler( cardNumber: NSString, cardName: NSString, expiration: NSString, code: NSString,
        completionHandler: ((error: String?) -> Void)!) -> ()  {
        
        let url = String(format: "%@%@", Constants.baseUrl, Constants.rentAPIUrl);
        let headers:[String: String]  = [
            Constants.authorizationResults: UserService.sharedInstance.userInfo.token //token
        ];
        let parameters:[String: String]  = [
            Constants.numberKeyString: cardNumber as String,
            Constants.nameKeyString : cardName as String,
            Constants.expirationKeyString: expiration as String,
            Constants.codeKeyString: code as String
        ];
        Alamofire.request(.POST, url, parameters: parameters, headers: headers, encoding: .JSON)
            .responseJSON { response in
                if let value: AnyObject = response.result.value {
                    //Handle the results as JSON
                    let post = JSON(value)
                    if post[Constants.messageKeyString].string != nil {
                        completionHandler(error: nil );
                    }
                    else {
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

}