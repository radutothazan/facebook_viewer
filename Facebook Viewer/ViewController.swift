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
    var accessToken : FBSDKAccessToken!
    let user = User()
    let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbLogOut()
        self.accessToken = FBSDKAccessToken.currentAccessToken()
        
        if (accessToken == nil)
        {
            print("Not loggen in")
            logInButton.hidden = false;
        }
        else
        {
            print("Logged in..")
            logInButton.hidden = true;
            performSegueWithIdentifier("logInSegue", sender: self)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logInSegue"{
            let vc = segue.destinationViewController as! ProfileController
            vc.user = self.user
            vc.accessToken = self.accessToken
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fbLogOut(){
        self.fbLoginManager.logOut()
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        
        //self.fbLoginManager.logInWithReadPermissions(["public_profile", "email", "user_friends","user_photos"], handler: { (result, error)-> Void in
        self.fbLoginManager.logInWithReadPermissions(["public_profile", "email", "user_friends","user_photos"], fromViewController: self, handler: { (result, error)-> Void in
            if error == nil
            {
                let fbLoginResult:FBSDKLoginManagerLoginResult = result
                if fbLoginResult.grantedPermissions.contains("email")
                {
                    self.getFBUserData()
                    self.performSegueWithIdentifier("logInSegue", sender: self)
                }
            }
        })
    }
    
    func getFBUserData(){
        if FBSDKAccessToken.currentAccessToken() != nil
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, picture.type(large)"]).startWithCompletionHandler({ (connection, result, error) -> Void in

                if error == nil
                {
                    self.dict = result as! NSDictionary
                    //print(result)
                    self.user.setFirstName(self.dict.valueForKey("first_name") as! String)
                    self.user.setLastName(self.dict.valueForKey("last_name")as! String)
                    self.user.setImageString((result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!)
                    //print(self.dict)
                    //NSLog(self.dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String)
                }
            })
            
            

        }
    }
    
    

}

