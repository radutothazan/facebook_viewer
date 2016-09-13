//
//  Photo.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 30/08/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class PhotoData: Mappable {
    var data: [Photo]?
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        data <- map["data"]
    }
}

class Photo: Mappable {
    var pictureURL: String?
    var name: String?
    var picture: UIImage?
    
    init(picture: UIImage, name: String) {
        self.picture = picture
        self.name = name
    }
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        pictureURL <- map["images.0.source"]
        name    <- map["name"]
        self.picture = UIImage(data: NSData(contentsOfURL: NSURL(string: pictureURL!)!)!)
    }
}