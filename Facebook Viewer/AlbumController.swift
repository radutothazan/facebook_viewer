//
//  AlbumController.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 30/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class AlbumController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var user : User!
    var dict : NSDictionary!
    var albume : [Album] = []
    var accessToken : FBSDKAccessToken!
    @IBOutlet weak var titleLabel: UILabel!
    var titlu : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = self.titlu
        loadAlbums()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadAlbums(){
        FBSDKGraphRequest(graphPath: "me/albums", parameters: ["fields": "id, name, count, cover_photo, picture"], HTTPMethod: "GET").startWithCompletionHandler({ (connection, result, error) -> Void in
            self.dict = result as! NSDictionary
            //print(self.dict)
            let nrAlbume = (self.dict.objectForKey("data")?.count!)! as Int
            for i in 0 ... nrAlbume-1{
                let nume = self.dict.objectForKey("data")?.valueForKey("name")![i]
                let id = self.dict.objectForKey("data")?.valueForKey("id")![i]
                let count = self.dict.objectForKey("data")?.valueForKey("count")![i]
                let cover = self.dict.objectForKey("data")?.valueForKey("picture")?.valueForKey("data")?.valueForKey("url")![i]
                let album : Album = Album(id: id as! String, name: nume as! String, cover: cover as! String, count: count as! Int)
                self.albume.append(album)
            }
            
            self.tableView.reloadData()
            
        })

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "back2profile"{
            let vc = segue.destinationViewController as! ProfileController
            vc.user = self.user
            vc.accessToken = self.accessToken
        }
        if segue.identifier == "albumImagine"{
            let vc = segue.destinationViewController as! PicturesController
            let indexPaths = self.tableView!.indexPathsForSelectedRows!
            let indexPath = indexPaths[0] as NSIndexPath
            vc.album = self.albume[indexPath.row]
            vc.accessToken = self.accessToken
            vc.user = self.user
            
        }
    }
    @IBAction func backAction(sender: AnyObject) {
        performSegueWithIdentifier("back2profile", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albume.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AlbumCell
        cell.nameLabel.text = albume[indexPath.row].getName()
        cell.nrLabel.text = String(albume[indexPath.row].getCount())
        cell.photo.image = UIImage(data: NSData(contentsOfURL: NSURL(string: albume[indexPath.row].getCover())!)!)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("albumImagine", sender: self)
    }
    

}
