//
//  Album.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 29/06/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import Foundation
import ObjectMapper

class AlbumData: Mappable{
    var data: [Album]?
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map){
        data <- map["data"]
    }
}

class Album: Mappable{
    var id: String!
    var name: String!
    var cover: String!
    var count: Int!
    
    required init?(_ map: Map) {
    }
    
    init(name: String, cover: String, count: Int){
        self.name = name
        self.cover = cover
        self.count = count
    }
    
    func mapping(map: Map){
        id    <- map["id"]
        name  <- map["name"]
        cover <- map["picture.data.url"]
        count <- map["count"]
    }
}