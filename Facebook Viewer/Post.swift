//
//  Post.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 30/06/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit

class Post{
    
    private var story: String!
    private var picture: String!
    
    init(story: String, picture: String){
        self.story = story
        self.picture = picture
    }
    init(story:String){
        self.story = story
    }
    init(picture: String){
        self.picture = picture
    }
    
    
    func getStory() -> String{
        return self.story
    }
    func getPicture() -> String{
        return self.picture
    }
    
    func setStory(story: String){
        self.story = story
    }
    func setPicture(picture: String){
        self.picture = picture
    }
    
    
    
    
    
}