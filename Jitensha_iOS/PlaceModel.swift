//
//  PlaceModel.swift
//  Jitensha_iOS
//
//  Created by Vladimir Marinov on 04.06.16.
//  Copyright © 2016 Vladimir Marinov. All rights reserved.
//

import Foundation
import CoreLocation


public class PlaceModel: NSObject {
    //public private(set) var placesArray : NSMutableArray

    public var id: String
    public var name: String
    public var location: CLLocation
    
     override init() {
        self.id = Constants.emptyString;
        self.name = Constants.emptyString;
        self.location = CLLocation(latitude: 0, longitude: 0);
        super.init();
    }
    /*!
     * @discussion Parse to Place object
     * @param parcObj AnyObject from server
     */
    public func parse(parcObj: AnyObject)  {
        let dict: NSDictionary = parcObj as! NSDictionary;
        self.id = dict["id"] as! String;
        self.name = dict["name"] as! String;
        let location:NSDictionary?  = dict["location"] as! NSDictionary?;
        if location != nil {
            let lat: Double = location!["lat"] as! Double;
            let lng: Double = location!["lng"] as! Double;
            self.location = CLLocation(latitude: lat, longitude: lng);
        }

    }

 }