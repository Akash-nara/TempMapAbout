//
//  MapExploreTVCell.swift
//  MyMapp
//
//  Created by Chirag Pandya on 14/11/21.
//

import UIKit
import SwiftSVG
import FSInteractiveMap

class MapExploreTVCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imgSVGMap: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
               
        imgSVGMap.isUserInteractionEnabled = true
        let dict  = [ "RU" : 12,
                      "it" : 2,
                      "de" : 9,
                      "pl" : 24,
                      "uk" : 17
                      ]
        
        let map = FSInteractiveMapView.init(frame: imgSVGMap.frame)
        map.loadMap("world-low", withData: dict, colorAxis: [UIColor.App_BG_SeafoamBlue_Color, UIColor.App_BG_SeafoamBlue_Color ])
        map.clickHandler = { (identi, layer) in
            debugPrint(identi)
        }
        
        imgSVGMap.addSubview(map)
        
        let svgURL = Bundle.main.url(forResource: "world-low", withExtension: "svg")!
        let pizza = CALayer(SVGURL: svgURL) { (svgLayer) in
            // Set the fill color
//            svgLayer.fillColor = UIColor(red:0.94, green:0.37, blue:0.00, alpha:1.00).cgColor
            // Aspect fit the layer to self.view
            svgLayer.fillColor = UIColor.App_BG_silver_Color.cgColor
            svgLayer.resizeToFit(self.imgSVGMap.bounds)

            // Add the layer to self.view's sublayers
//            self.imgSVGMap.layer.addSublayer(svgLayer)
        }

    }
}
