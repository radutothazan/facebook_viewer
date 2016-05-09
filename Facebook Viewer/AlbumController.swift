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

class AlbumController: UIViewController {
    
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
        FBSDKGraphRequest(graphPath: "me/albums", parameters: nil, HTTPMethod: "GET").startWithCompletionHandler({ (connection, result, error) -> Void in
            print(result)
            
        })
    }

}
