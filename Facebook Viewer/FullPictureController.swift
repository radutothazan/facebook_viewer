//
//  FullPictureController.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 30/06/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit

class FullPictureController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndexPath : NSIndexPath?
    var accessToken : String = ""
    var poze : [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        if selectedIndexPath != nil {
            self.collectionView.scrollToItemAtIndexPath(self.selectedIndexPath!, atScrollPosition: .CenteredHorizontally, animated: false)
            selectedIndexPath = nil
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height);
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let newCell = collectionView.dequeueReusableCellWithReuseIdentifier("fullPhotoCell", forIndexPath: indexPath) as! FullPhotoCell
        newCell.photo.image = self.poze[indexPath.row].picture
        self.title = self.poze[indexPath.row].name
        return  newCell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.poze.count
    }
}
