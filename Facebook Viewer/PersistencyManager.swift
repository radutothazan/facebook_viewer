//
//  PersistencyManager.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 02/09/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class PersistencyManager{
    var user: User!
    init(accessToken: String){
        
        alamofireGetFbUserData(accessToken)
        
    }
    func alamofireGetFbUserData(accessToken: String) -> User{
        Alamofire.request(.GET, "https://graph.facebook.com/me?access_token=\(accessToken)", parameters: ["fields": "first_name, last_name, picture.type(large), cover"]).responseJSON(completionHandler: { (response) in
            let newUser = Mapper<User>().map(response.result.value)
            self.user = newUser!
            //self.performSegueWithIdentifier("logInSegue", sender: self)
        })
        return self.user
    }
}