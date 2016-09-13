//
//  User.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 30/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    var firstName : String!
    var lastName : String!
    var imageString : String?
    var coverPhoto: String?
    
    init(){
    }
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map){
        firstName   <- map["first_name"]
        lastName    <- map["last_name"]
        imageString <- map["picture.data.url"]
        coverPhoto  <- map["cover.source"]
    }
}