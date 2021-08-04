//
//  WishlistTableViewCell.swift
//  PennyWise
//
//  Created by Samantha Rey on 8/25/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

/// UITableViewCell file for the cells in the Wishlist
class WishlistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var  nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceGuage: UIView!
    @IBOutlet weak var priceGuageConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
