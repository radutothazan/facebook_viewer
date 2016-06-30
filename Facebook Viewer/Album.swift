//
//  Album.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 29/06/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit

class Album{
    private var id : String!
    private var name : String!
    private var cover : String!
    private var count: Int!
    
    init(){
    }
    init(id: String, name: String, cover: String, count: Int){
        self.id = id
        self.name = name
        self.cover = cover
        self.count = count
    }
    
    func getId() -> String{
        return self.id
    }
    func getName() -> String{
        return self.name
    }
    func getCover() -> String{
        return self.cover
    }
    func getCount() -> Int{
        return self.count
    }
    
    func setId(id: String){
        self.id = id
    }
    func setName(name: String){
        self.name = name
    }
    func setCover(cover: String){
        self.cover = cover
    }
    func setCount(count: Int){
        self.count = count
    }
    
}