//
//  ViewController.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 10/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit



class ViewController: UIViewController {

    var dict : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let accessToken = FBSDKAccessToken.currentAccessToken()
        
        if (accessToken == nil)
        {
            print("Not loggen in")
        }
        else
        {
            print("Logged in..")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func loginAction(sender: AnyObject) {
        
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["email"], handler: { (result, error)-> Void in
            if error == nil
            {
                let fbLoginResult:FBSDKLoginManagerLoginResult = result
                if fbLoginResult.grantedPermissions.contains("email")
                {
                    self.getFBUserData()
                }
            }
        })
    }
    
    func getFBUserData(){
        if FBSDKAccessToken.currentAccessToken() != nil
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if error == nil
                {
                    self.dict = result as! NSDictionary
                    print(result)
                    print(self.dict)
                    NSLog(self.dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String)
                }
            })
        }
    }
    
    

}

