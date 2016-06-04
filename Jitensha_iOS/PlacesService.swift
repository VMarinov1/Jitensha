//
//  PlacesService.swift
//  Jitensha_iOS
//
//  Created by Vladimir Marinov on 04.06.16.
//  Copyright © 2016 Vladimir Marinov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class PlacesService : NSObject {

    public private(set) var placesArray : NSMutableArray
    
    // MARK: Singleton Support
    class var sharedInstance : PlacesService {
        
        struct Singleton {
            static let instance = PlacesService()
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
            assert(self === PlacesService.sharedInstance, "Only one instance of SingletonClass allowed!")
        }
    }
    /*!
     * @discussion Parse Places result from Dictionaty to Typed sctruct
     * @param param objects
     */
    func parsePlaces(objects: [AnyObject]){
        self.placesArray = NSMutableArray();
        for  object in objects{
            let place = PlaceModel();
            place.parse(object);
            self.placesArray.addObject(place);
        }
    }
    // MARK: Load Places
    /*!
     * @discussion load places with result handler
     * @param completionHandler Completion method to catch loagin process
     */
    public func loginPlacesWithCompletionHandler(completionHandler: ((error: String?) -> Void)!) -> ()  {
        let url = String(format: "%@%@", Constants.baseUrl, Constants.placesAPIUrl);
        let headers:[String: String]  = [
            Constants.authorizationResults: UserService.sharedInstance.userInfo.token //token
        ];
        Alamofire.request(.GET, url, headers: headers)
            .responseJSON { response in
                if let value: AnyObject = response.result.value {
                    //Handle the results as JSON
                    let get = JSON(value)
                     if get[Constants.resultsKeyString] != nil {
                        // parse object
                        let resData = get[Constants.resultsKeyString].arrayObject
                        self.parsePlaces(resData!);
                        // resData.ma
                        completionHandler(error: nil);
                    } else if get[Constants.messageKeyString].string != nil {
                        completionHandler(error: get[Constants.messageKeyString].string );
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