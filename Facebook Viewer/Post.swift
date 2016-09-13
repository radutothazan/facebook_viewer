//
//  Post.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 30/06/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import Foundation
import ObjectMapper

class PostsData: Mappable{
    var data: [Post]?
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map){
        data <- map["data"]
    }
}

class Post: Mappable{
    
    var story: String?
    var picture: String?
    var message : String?
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map){
        story   <- map["story"]
        picture <- map["picture"]
        message <- map["message"]
        if picture == nil{
            picture = ""
        }
    }
}