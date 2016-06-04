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
    // API Predefines
    static let emailKeyString = "email"
    static let passworKeyString = "password"
    static let accessTokenKeyString = "accessToken"
    static let messageKeyString = "message"
    // Messages 
    static let invalidResponse = "Invalid Respose"
    static let errorTitleResponse = "Error"
    static let loginSuccessResponse = "Welcome"
    // segues
    static let kShowRegisterSegueId = "ShowRegisterSegue"
}