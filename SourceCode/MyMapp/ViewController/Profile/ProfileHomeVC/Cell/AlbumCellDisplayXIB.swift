//
//  AlbumCellDisplayXIB.swift
//  MyMapp
//
//  Created by Chirag Pandya on 04/12/21.
//

import UIKit
import SkeletonView

class AlbumCellDisplayXIB: UICollectionViewCell {

    @IBOutlet weak var tripTitle: UILabel!
    @IBOutlet weak var tripSubTitle: UILabel!
    @IBOutlet weak var labelBookmarkCount: UILabel!
    @IBOutlet weak var buttonSaved: UIButton!
    @IBOutlet weak var imageTrip: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageTrip.isSkeletonable = true
        imageTrip.cornerRadius = 15
        imageTrip.borderColor = .App_BG_SecondaryDark2_Color
        imageTrip.borderWidth = 0.1
    }
    
    
    func configureCell(dataModel:CityModel, completion: ((Bool,Int) -> Void)? = nil){
        labelBookmarkCount.text = "\(dataModel.totalCount)"
        labelBookmarkCount.isHidden = dataModel.totalCount.isZero()
        tripTitle.text = dataModel.name
        tripSubTitle.text = dataModel.countryName
        
        
        self.getGooglePhotoByCity(cityName: dataModel.name) { [weak self] in
            if let image = self?.imageTrip.image, image.isImageVerticle{
                completion?(true, self?.imageTrip.tag ?? 0)
            }else{
                completion?(false, self?.imageTrip.tag ?? 0)
            }
        }
        
        
        /*
        var defaultKey = dataModel.defaultImageKey
        if defaultKey.isEmpty, let firstObject = dataModel.photoUploadedArray.first?.arrayOfImageURL.first{
            defaultKey = firstObject.image
        }
        
        if !defaultKey.isEmpty{
            
            self.imageTrip.sd_setImage(with: URL.init(string: defaultKey), placeholderImage: nil, options: .highPriority) { [weak self] img, error, cache, url in
                
                if let image = img{
                    self?.imageTrip.image = image
                    //since the width > height we may fit it and we'll have bands on top/bottom
                    self?.imageTrip.contentMode = .scaleAspectFill
                }else{
                    //width < height we fill it until width is taken up and clipped on top/bottom
                    self?.imageTrip.contentMode = .scaleToFill
                    if let foundImage = dataModel.photoUploadedArray.first?.arrayOfImageURL.first?.image, !foundImage.isEmpty{
                        self?.imageTrip.setImage(url: foundImage, placeholder: UIImage.init(named: "not_icon"))
                    }else{
                        self?.imageTrip.image = UIImage.init(named: "not_icon")
                    }
                }
                
                if let image = img,image.isImageVerticle{
                    completion?(true, self?.imageTrip.tag ?? 0)
                }else{
                    completion?(false, self?.imageTrip.tag ?? 0)
                }
            }
            self.imageTrip.clipsToBounds = true
        }else{
            //            startAnimating()
            self.imageTrip.backgroundColor = .clear
            self.imageTrip.contentMode = .scaleToFill
            self.imageTrip.image = UIImage.init(named: "not_icon")
            //            self.imgviewBG.image = UIImage.init(named: "ic_Default_city_image_one")
        }*/
    }
    
    func getGooglePhotoByCity(cityName:String, completion: (() -> Void)? = nil) {
        
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
        self.imageTrip.showSkeleton()
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonObj = JSON.init(json)
                    if let placeIdsArray = jsonObj["results"].array, let firstPhotoObj = placeIdsArray.first?.dictionaryValue["photos"]?.arrayValue.first, let key = firstPhotoObj["photo_reference"].string{
                        let width = firstPhotoObj["width"].intValue
                        let height = firstPhotoObj["height"].intValue
                        let url = "https://maps.googleapis.com/maps/api/place/photo?photo_reference=\(key)&maxwidth=\(width)&maxheight=\(height)&key=\(appDelegateShared.googleKey)"
                        
                        self.imageTrip.sd_setImage(with: URL.init(string: url)) { img, eror, cache, url in
                            self.imageTrip.hideSkeleton()
                            if let imgObj = img{
                                self.imageTrip.image = imgObj
                            }else{
                                self.imageTrip.image = UIImage.init(named: "not_icon")
                            }
                            
                            completion?()
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
