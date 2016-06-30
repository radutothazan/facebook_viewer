//
//  PicturesController.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 30/06/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class PicturesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var titluLabel: UILabel!

    var album : Album!
    var user : User!
    var poze : [String] = []
    var dict : NSDictionary!
    var accessToken : FBSDKAccessToken!
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        titluLabel.text = album.getName()
        FBSDKGraphRequest(graphPath: "\(album.getId())/photos?redirect=false&type=large", parameters: ["fields": "picture"], HTTPMethod: "GET").startWithCompletionHandler({ (connection, result, error) -> Void in
            print(result)
            self.dict = result as! NSDictionary
            let nrPoze = (self.dict.objectForKey("data")?.count!)! as Int
            for i in 0 ... nrPoze-1{
                let poza = self.dict.objectForKey("data")?.valueForKey("picture")![i]
                self.poze.append(poza as! String)
            }
            self.collectionView.reloadData()
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("displayImage", sender: self)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let newCell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhotoCell
        newCell.photo.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.poze[indexPath.row])!)!)
        return  newCell
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.poze.count)
        return self.poze.count
    }

    @IBAction func backAction(sender: AnyObject) {
        performSegueWithIdentifier("backGallery", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backGallery"{
            let vc = segue.destinationViewController as! AlbumController
            vc.accessToken = self.accessToken
            vc.titlu = "Albums"
            vc.user = self.user
        }
        if segue.identifier == "displayImage"{
            let vc = segue.destinationViewController as! FullPictureController
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            vc.imagineURL = self.poze[indexPath.row]
            vc.user = self.user
            vc.accessToken = self.accessToken
            vc.album = self.album
            
        }
        
    }

}
