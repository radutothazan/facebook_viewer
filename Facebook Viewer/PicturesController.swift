//
//  PicturesController.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 30/06/16.
//  Copyright © 2016 radutot. All rights reserved.
//
import UIKit
import FBSDKCoreKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import Kingfisher

class PicturesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    var album : Album!
    var poze : [Photo] = []
    var accessToken : String = ""
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getPictures()
        self.title = album.name
    }
    
    func getPictures(){
        Alamofire.request(.GET, "https://graph.facebook.com/\(album.id)/photos?access_token=\(self.accessToken)", parameters: ["fields": "images, name"]).responseObject { (response: Response<PhotoData, NSError>) in
            if response.result.error == nil{
                let data = response.result.value
                if let data = data?.data{
                    for photo in data{
                        let photoForArray = photo
                        self.poze.append(photoForArray)
                    }
                }
            }
            else {
                let alertController = UIAlertController(title: "API Call Fail", message: "Error Number \(response.result.error!.code)", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("pushPicture", sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let newCell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhotoCell
        newCell.photo.image = self.poze[indexPath.row].picture
        newCell.photo.layer.masksToBounds = true
        newCell.photo.layer.cornerRadius = 10
        return  newCell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.poze.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushPicture"{
            let vc = segue.destinationViewController as! FullPictureController
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            vc.selectedIndexPath = indexPath
            vc.poze = self.poze
            vc.accessToken = self.accessToken
        }
    }
    
    @IBAction func addPhotoAction(sender: AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default, handler: {(alert) in
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .Default, handler: {(action) in
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        let image : UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        let loadImage = image.alpha(0.5)
        let photo: Photo = Photo(picture: loadImage, name: "")
        self.poze.append(photo)
        
        self.collectionView.reloadData()
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicator.frame = CGRectMake(0, 0, 40, 40)
        
        let lastIndex = self.collectionView.numberOfItemsInSection(0) - 1
        let path = NSIndexPath(forItem: lastIndex, inSection: 0)
        let cell : UICollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: path)
        indicator.center = cell.center
        indicator.center.y += cell.frame.height/2
        
        view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        indicator.startAnimating()
        
        FBSDKGraphRequest(graphPath: "\(album.id)/photos", parameters: ["picture": UIImagePNGRepresentation(image)!], HTTPMethod: "POST").startWithCompletionHandler({ (connection, result, error) in
            if error != nil{
                print(error)
            }
            else {
                indicator.stopAnimating()
                self.poze.popLast()
                let photo: Photo = Photo(picture: image, name: "")
                self.poze.append(photo)
                self.collectionView.reloadData()
            }
        })
//        Alamofire.request(.POST, "https://graph.facebook.com/\(album.id)/photos?access_token=\(self.accessToken)",parameters: ["picture": UIImagePNGRepresentation(image)!]).responseJSON { (response) in
//            if response.result.error == nil{
//                print(response.result.debugDescription)
//                indicator.stopAnimating()
//                self.poze.popLast()
//                let photo: Photo = Photo(picture: image, name: "")
//                self.poze.append(photo)
//                self.collectionView.reloadData()
//            }
//            else {
//                print(response.result.error)
//            }
//        }
    }
}

extension UIImage{
    
    func alpha(value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext();
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height);
        CGContextScaleCTM(ctx, 1, -1);
        CGContextTranslateCTM(ctx, 0, -area.size.height);
        CGContextSetBlendMode(ctx, CGBlendMode.Multiply);
        CGContextSetAlpha(ctx, value);
        CGContextDrawImage(ctx, area, self.CGImage);
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
}
