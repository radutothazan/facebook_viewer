//
//  ApiCalls.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 02/09/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class ApiCalls{
    class func getFBUserData(accessToken: String,completion: User -> Void){
        Alamofire.request(.GET, "https://graph.facebook.com/me?access_token=\(accessToken)", parameters: ["fields": "first_name, last_name, picture.type(large), cover"]).responseJSON(completionHandler: { (response) in
            let user = Mapper<User>().map(response.result.value)
            completion(user!)
        })
    }
    
    class func getFeed(accessToken: String, completion: ([Post]?, NSError?) -> Void){
        Alamofire.request(.GET, "https://graph.facebook.com/me/feed?access_token=\(accessToken)",parameters: ["fields": "story,picture,message", "limit": "15"]).responseObject { (response: Response<PostsData, NSError>) in
            if response.result.error == nil{
                let data = response.result.value
                if let data = data?.data{
                    var posts : [Post] = []
                    for post in data{
                        let postForArray = post
                        posts.append(postForArray)
                    }
                    completion(posts, response.result.error)
                }
            }
            else {
                completion([], response.result.error)
            }
        }
    }
}

