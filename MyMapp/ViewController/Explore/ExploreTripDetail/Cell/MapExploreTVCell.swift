//
//  MapExploreTVCell.swift
//  MyMapp
//
//  Created by Chirag Pandya on 14/11/21.
//

import UIKit
import SwiftSVG
class MapExploreTVCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imgSVGMap: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
                
        let svgURL = Bundle.main.url(forResource: "world-low", withExtension: "svg")!
        let pizza = CALayer(SVGURL: svgURL) { (svgLayer) in
            // Set the fill color
//            svgLayer.fillColor = UIColor(red:0.94, green:0.37, blue:0.00, alpha:1.00).cgColor
            // Aspect fit the layer to self.view
            svgLayer.fillColor = UIColor.App_BG_silver_Color.cgColor
            svgLayer.resizeToFit(self.imgSVGMap.bounds)

            // Add the layer to self.view's sublayers
            self.imgSVGMap.layer.addSublayer(svgLayer)
        }

    }
}
