//
//  FullPictureController.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 30/06/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class FullPictureController: UIViewController {

    @IBOutlet weak var titlu: UILabel!
    @IBOutlet weak var imagine: UIImageView!
    var imagineURL : String!
    var user : User!
    var album : Album!
    var accessToken : FBSDKAccessToken!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagine.image = UIImage(data: NSData(contentsOfURL: NSURL(string: imagineURL)!)!)
        titlu.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backPictures"{
            let vc = segue.destinationViewController as! PicturesController
            vc.accessToken = self.accessToken
            vc.user = self.user
            vc.album = self.album
        }
    }
    
    @IBAction func backAction(sender: AnyObject) {
        performSegueWithIdentifier("backPictures", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
