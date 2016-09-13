//
//  AlbumController.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 30/04/16.
//  Copyright © 2016 radutot. All rights reserved.
//
import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import Kingfisher

class AlbumController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var user : User!
    var albume : [Album] = []
    var accessToken : String = ""
    var titlu : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titlu
        loadAlbums()
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "push"{
            let vc = segue.destinationViewController as! PicturesController
            let indexPaths = self.tableView!.indexPathsForSelectedRows!
            let indexPath = indexPaths[0] as NSIndexPath
            vc.album = self.albume[indexPath.row]
            vc.accessToken = self.accessToken
            
        }
    }
    
    func loadAlbums(){
        Alamofire.request(.GET, "https://graph.facebook.com/me/albums?access_token=\(self.accessToken)",parameters: ["fields": "id, name, count, cover_photo, picture"]).responseObject { (response: Response<AlbumData, NSError>) in
            if response.result.error == nil{
                let data = response.result.value
                if let data = data?.data{
                    self.albume.removeAll()
                    for album in data{
                        let albumForArray = album
                        self.albume.append(albumForArray)
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                let alertController = UIAlertController(title: "API Call Fail", message: "Error Number \(response.result.error!.code)", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "Retry", style: .Default, handler: {(alert: UIAlertAction!) in
                self.loadAlbums()
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            self.tableView.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albume.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AlbumCell
        cell.nameLabel.text = albume[indexPath.row].name
        cell.nrLabel.text = String(albume[indexPath.row].count)
        cell.photo.kf_setImageWithURL(NSURL(string: albume[indexPath.row].cover))
        cell.photo.layer.masksToBounds = true
        cell.photo.layer.cornerRadius = 10
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("push", sender: self)
    }
    
    @IBAction func addAlbum(sender: AnyObject) {
        let alertController = UIAlertController(title: "Introduceti numele albumului", message: nil, preferredStyle: .Alert)
        let addAlbumAction = UIAlertAction(title: "Ok", style: .Default, handler: {(_) in
            let numeAlbumTextField = alertController.textFields![0] as UITextField
            Alamofire.request(.POST, "https://graph.facebook.com/me/albums?access_token=\(self.accessToken)", parameters: ["name":"\(numeAlbumTextField.text!)"]).responseJSON(completionHandler: { (response) in
                if response.result.error == nil{
                    self.loadAlbums()
                }
                else {
                    let alertController = UIAlertController(title: "API Call Fail", message: "Error Number \(response.result.error!.code)", preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "Retry", style: .Default, handler: {(alert: UIAlertAction!) in
                        self.addAlbum(sender)
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    alertController.addAction(defaultAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            })
        })
        
        addAlbumAction.enabled = false
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Nume Album"
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                addAlbumAction.enabled = textField.text != ""
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addAlbumAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
