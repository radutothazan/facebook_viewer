//
//  User.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 30/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit

class User{
    private var firstName : String!
    private var lastName : String!
    private var imageString : String!
    //private var accessToken : FBSDKAccessToken!
    
    func getFirstName() -> String{
        return self.firstName
    }
    func getLastName() -> String{
        return self.lastName
    }
    func getImageString() -> String{
        return self.imageString
    }
//    func getAccessToken() -> String{
//        retrun self.accessToken
//    }
    
    func setFirstName(firstName: String){
        self.firstName = firstName
    }
    func setLastName(lastName: String){
        self.lastName = lastName
    }
    func setImageString(imageString: String){
        self.imageString = imageString
    }
//    func setAccessToken(accessToken: FBSDKAccessToken){
//        self.accessToken = FBSDKAccessToken.currentAccessToken()
//    }
    
    
}