//
//  ProfileController.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 30/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//
import UIKit
import FBSDKLoginKit

class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user : User!
    var accessToken : String = ""
    @IBOutlet weak var albumsButton: UIButton!
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var numeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var refresh : UIRefreshControl!
    var dict : NSDictionary!
    var posts : [Post] = []
    var defaults = NSUserDefaults.standardUserDefaults()
    let indicator:UIActivityIndicatorView = UIActivityIndicatorView  (activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        prepareView()
        refreshAction()
    }
    
    func prepareView(){
        self.albumsButton.backgroundColor = UIColor.clearColor()
        self.albumsButton.layer.cornerRadius = 15
        self.albumsButton.layer.borderWidth = 1
        self.albumsButton.layer.borderColor = UIColor(red: 2.0 / 255.0, green: 106.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0).CGColor
        
        let button: UIButton = UIButton.init(type: UIButtonType.Custom)
        button.setTitle("⏻", forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont(name: "UnicodeIECsymbol", size: 25)
        button.titleLabel?.textColor = UIColor.whiteColor()
        button.addTarget(self, action: #selector(self.logOutButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRectMake(0, 0, 25, 25)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        indicator.color = UIColor .blackColor()
        indicator.frame = CGRectMake(0.0, 0.0, 10.0, 10.0)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        indicator.startAnimating()
        
        refresh = UIRefreshControl()
        refresh.tintColor = UIColor.blackColor()
        refresh.addTarget(self, action: #selector(self.refreshAction), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refresh)
        
        self.coverPhoto.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.user.coverPhoto!)!)!)
        self.imageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.user.imageString!)!)!)
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        numeLabel.text = self.user.firstName + " " + self.user.lastName
        tableView.allowsSelection = false
    }
    
    func logOutButtonPressed(){
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        performSegueWithIdentifier("logOutSegue", sender: self)
    }
    
    func refreshAction(){
        ApiCalls.getFeed(self.accessToken) { (response) in
            if response.1 == nil{
                self.posts  = response.0!
                self.tableView.reloadData()
            }
            else {
                let alertController = UIAlertController(title: "API Call Fail", message: response.1?.localizedDescription, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "Retry", style: .Default, handler: {(alert: UIAlertAction!) in
                    self.refreshAction()
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        refresh.endRefreshing()
    }
    
    @IBAction func albumsAction(sender: AnyObject) {
        performSegueWithIdentifier("pushAlbum", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushAlbum"{
            let vc = segue.destinationViewController as! AlbumController
            vc.accessToken = self.accessToken
            vc.titlu = "Albums"
            vc.user = self.user
        }
        if segue.identifier == "logOutSegue"{
            let vc = segue.destinationViewController as! ViewController
            self.defaults.setObject("", forKey: "accessToken")
            vc.defaults = self.defaults
            vc.accessToken = ""
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
        pictureCell.story!.text = posts[indexPath.row].story
        pictureCell.message!.text = posts[indexPath.row].message
        if posts[indexPath.row].picture != ""{
            pictureCell.picture?.image = UIImage(data: NSData(contentsOfURL: NSURL(string: posts[indexPath.row].picture!)!)!)
        }
        else{
            pictureCell.picture?.image = UIImage(named: "Unknown")
        }
        self.indicator.stopAnimating()
        self.indicator.hidesWhenStopped = true
        
        return pictureCell
    }
    
}
