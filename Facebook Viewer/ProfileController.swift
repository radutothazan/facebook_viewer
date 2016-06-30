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


class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user : User!
    var accessToken : FBSDKAccessToken!
    @IBOutlet weak var numeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var dict : NSDictionary!
    var posts : [Post] = []
    
    let indicator:UIActivityIndicatorView = UIActivityIndicatorView  (activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        indicator.color = UIColor .blackColor()
        indicator.frame = CGRectMake(0.0, 0.0, 10.0, 10.0)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        indicator.startAnimating()
        
        super.viewDidLoad()
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        self.imageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.user.getImageString())!)!)
        numeLabel.text = self.user.getFirstName() + " " + self.user.getLastName()
        FBSDKGraphRequest(graphPath: "me/feed", parameters: ["fields": "story,picture"], HTTPMethod: "GET").startWithCompletionHandler({ (connection, result, error) -> Void in
            self.dict = result as! NSDictionary
            let rows = (self.dict.objectForKey("data")?.count!)! as Int
            for i in 0 ... rows-1{
                let story = self.dict.objectForKey("data")?.valueForKey("story")![i]
                let picture = self.dict.objectForKey("data")?.valueForKey("picture")![i]
                if picture !== NSNull() && story !== NSNull(){
                    let post = Post(story: story as! String, picture: picture as! String)
                    self.posts.append(post)
                }
//                if picture === NSNull() && story !== NSNull(){
//                    let post = Post(story: story as! String, picture: "1")
//                    self.posts.append(post)
//                }
//                if story === NSNull() && picture !== NSNull(){
//                    let post = Post(story: "1", picture: picture as! String)
//                    self.posts.append(post)
//                }
                self.tableView.reloadData()
            }
            
            
        })
        
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
            vc.user = self.user
    
        }
    }
    

    @IBAction func logOutAction(sender: AnyObject) {
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        performSegueWithIdentifier("logOutSegue", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let pictureCell = tableView.dequeueReusableCellWithIdentifier("pictureCell", forIndexPath: indexPath) as! FeedPictureCell
        pictureCell.story.text = posts[indexPath.row].getStory()
        pictureCell.picture.image = UIImage(data: NSData(contentsOfURL: NSURL(string: posts[indexPath.row].getPicture())!)!)
        
        self.indicator.stopAnimating()
        self.indicator.hidesWhenStopped = true
        
        return pictureCell
    }
    
    
    
}
