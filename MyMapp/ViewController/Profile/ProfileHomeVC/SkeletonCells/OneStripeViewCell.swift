//
//  OneStripeViewCell.swift
//  MyMapp
//
//  Created by Akash Nara on 19/08/21.
//  Copyright © 2021 Akash. All rights reserved.
//

import UIKit

class OneStripeViewCell: UITableViewCell {

    @IBOutlet weak var stripeOne: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.stripeOne.layer.cornerRadius = 12.0
        self.stripeOne.clipsToBounds = true
    }
    
    func startAnimating() {
        self.stripeOne.showAnimatedSkeleton()
    }
    
    func stopAnimating() {
        self.stripeOne.hideSkeleton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
