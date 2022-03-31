//
//  TripMainLocationCellXIB.swift
//  MyMapp
//
//  Created by Chirag Pandya on 05/12/21.
//

import UIKit
import TagListView
import SkeletonView

class TripMainLocationCellXIB: UITableViewCell {
    
    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var subTitle : UILabel!
    @IBOutlet weak var buttonBookmark : UIButton!
    @IBOutlet weak var locationImage : UIImageView!
    @IBOutlet weak var tagListView : TagListView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        locationImage.contentMode = .scaleToFill
        locationImage.isSkeletonable = true
        // Initialization code
        
        //        tagListView.textFont = UIFont.Montserrat.Medium(14)
        //        tagListView.addTag("Architecture")
        //        tagListView.addTag("Landscape")
        //        tagListView.addTag("Design")
        //        tagListView.alignment = .center
        //        tagListView.alignment = .left
        //        tagListView.enableRemoveButton = false
        //        tagListView.paddingX = 10
        //        tagListView.paddingY = 10
        //        let width = tagListView.tagViews.map { $0.frame.width }.reduce(0, +)
        //        tagListView.constant = width + CGFloat(10 * tagListView.tagViews.count)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func getGooglePhotoByCity(cityName:String) {
        
        var serviceUrl:URL? = nil
        let key = appDelegateShared.googleKey
        
        let queryItems = [URLQueryItem(name: "key", value: key), URLQueryItem(name: "query", value: cityName),URLQueryItem(name: "type", value: "tourist_attraction")]
        var urlComps = URLComponents(string: "https://maps.googleapis.com/maps/api/place/textsearch/json")
        urlComps?.queryItems = queryItems
        serviceUrl = urlComps?.url
        
        guard let urlGoogle = serviceUrl else { return }
        
        var request = URLRequest(url: urlGoogle)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        self.locationImage.showSkeleton()
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonObj = JSON.init(json)
                    if let placeIdsArray = jsonObj["results"].array, let firstPhotoObj = placeIdsArray.first?.dictionaryValue["photos"]?.arrayValue.first, let key = firstPhotoObj["photo_reference"].string{
                        let width = firstPhotoObj["width"].intValue
                        let height = firstPhotoObj["height"].intValue
                        let url = "https://maps.googleapis.com/maps/api/place/photo?photo_reference=\(key)&maxwidth=\(width)&maxheight=\(height)&key=\(appDelegateShared.googleKey)"
                        
                        self.locationImage.sd_setImage(with: URL.init(string: url)) { img, eror, cache, url in
                            self.locationImage.hideSkeleton()
                            if let imgObj = img{
                                self.locationImage.image = imgObj
                            }else{
                                self.locationImage.image = UIImage.init(named: "not_icon")
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
