//
//  ViewController.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 10/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController{
    
    var accessToken: String = ""
    var user : User!
    let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
    @IBOutlet weak var logInButton: UIButton!
    var defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logInButton.backgroundColor = UIColor.clearColor()
        self.logInButton.layer.cornerRadius = 15
        self.logInButton.layer.borderWidth = 1
        self.logInButton.layer.borderColor = UIColor(red: 2.0 / 255.0, green: 106.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0).CGColor
        
        if (defaults.stringForKey("accessToken") == nil || defaults.stringForKey("accessToken") == "")
        {
            print("Not loggen in")
            logInButton.hidden = false;
        }
        else
        {
            print("Logged in..")
            ApiCalls.getFBUserData(defaults.stringForKey("accessToken")!){ response in
                self.user = response
                self.performSegueWithIdentifier("logInSegue", sender: self)
            }
            logInButton.hidden = true;
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logInSegue"{
            let navController = segue.destinationViewController as! NavigationViewController
            let vc = navController.topViewController as! ProfileController
            self.accessToken = defaults.stringForKey("accessToken")!
            vc.user = self.user
            vc.accessToken = self.accessToken
            vc.defaults = self.defaults
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func fbLogOut(){
        defaults.setObject("", forKey: "accessToken")
        self.fbLoginManager.logOut()
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        self.fbLoginManager.logInWithPublishPermissions(["publish_actions"], fromViewController: self, handler: { (result, error)-> Void in
            if error == nil
            {
                let fbLoginResult:FBSDKLoginManagerLoginResult = result
                if fbLoginResult.grantedPermissions.contains("email")
                {
                    self.defaults.setObject(FBSDKAccessToken.currentAccessToken().tokenString, forKey: "accessToken")
                    ApiCalls.getFBUserData(self.defaults.stringForKey("accessToken")!){response in
                        self.user = response
                        self.performSegueWithIdentifier("logInSegue", sender: self)
                    }
                }
            }
        })
    }
}

