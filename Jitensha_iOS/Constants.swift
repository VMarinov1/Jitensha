//
//  Constants.swift
//  Jitensha_iOS
//
//  Created by Vladimir Marinov on 04.06.16.
//  Copyright © 2016 Vladimir Marinov. All rights reserved.
//

import Foundation



public struct Constants{
    static let emptyString = ""
    // AIP URLs
    static let baseUrl = "http://localhost:8080"
    static let loginAPIUrl = "/api/v1/auth"
    static let placesAPIUrl = "/api/v1/places"
    static let registerAPIUrl = "/api/v1/register"
    static let rentAPIUrl = "/api/v1/rent"
    // API Predefines
    static let emailKeyString = "email"
    static let passworKeyString = "password"
    static let accessTokenKeyString = "accessToken"
    static let messageKeyString = "message"
    static let resultsKeyString = "results"
    static let numberKeyString = "number"
    static let nameKeyString = "name"
    static let expirationKeyString = "expiration"
    static let codeKeyString = "code"
    static let authorizationResults = "Authorization"
    
    static let MetersCutOff = 1000.0
    // Messages 
    static let invalidResponse = "Invalid Respose"
    static let errorTitleResponse = "Error"
    static let successRentedTitleResponse = "Rent Success"
    static let loginSuccessResponse = "Welcome"
    // Buttons 
    static let dismissButtonLabel = "Dismiss"
    // segues
    static let kShowRegisterSegueId = "ShowRegisterSegue"
    static let kShowMapSegueId = "ShowMapSegue"
    static let kShowRentPlaceSegueId = "ShowRentPlaceSegue"
    static let kShowRentHistorySegueId = "ShowRentHistorySegue"
    static let kShowRequestRentSegueId = "ShowRequestRentSegue"
}