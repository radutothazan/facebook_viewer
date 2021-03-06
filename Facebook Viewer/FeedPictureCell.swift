//
//  FeedPictureCell.swift
//  Facebook Viewer
//
//  Created by Radu Tothazan on 29/06/16.
//  Copyright © 2016 radutot. All rights reserved.
//

import UIKit

class FeedPictureCell: UITableViewCell {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var story: UILabel?
    @IBOutlet weak var picture: UIImageView?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
