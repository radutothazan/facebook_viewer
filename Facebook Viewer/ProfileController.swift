//
//  ProfileController.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 30/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class ProfileController: UIViewController {
    var user : User!
    var accessToken : FBSDKAccessToken!
    @IBOutlet weak var numeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        self.imageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.user.getImageString())!)!)
        numeLabel.text = self.user.getFirstName() + " " + self.user.getLastName()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func albumsAction(sender: AnyObject) {
        performSegueWithIdentifier("albumsSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "albumsSegue"{
            let vc = segue.destinationViewController as! AlbumController
            vc.accessToken = self.accessToken
            vc.titlu = "Albums"
    
        }
    }

    @IBAction func logOutAction(sender: AnyObject) {
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        performSegueWithIdentifier("logOutSegue", sender: self)
    }
    
    
    
    
}
