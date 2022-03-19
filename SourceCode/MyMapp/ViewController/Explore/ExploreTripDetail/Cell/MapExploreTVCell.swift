//
//  MapExploreTVCell.swift
//  MyMapp
//
//  Created by Chirag Pandya on 14/11/21.
//

import UIKit
import SwiftSVG
import FSInteractiveMap
import GoogleMaps
import GEOSwift
import GoogleMapsUtils

class MapExploreTVCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imgSVGMap: UIView!
    @IBOutlet weak var googleMap: GMSMapView!
    
    var mapStyle = "JSON_STYLE_GOES_HERE"
    var cityName = "Surat, India"
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        imgSVGMap.isHidden = true
        googleMap.isHidden = true
        
        /*
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { placemarks, error in
            if let placemark = placemarks?.first{
                let lat = placemark.location!.coordinate.latitude
                let long = placemark.location!.coordinate.longitude
                
                let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 1.0) // point the initial location of map
                self.googleMap.camera = camera
                //                self.googleMap.delegate = self
                self.googleMap.isMyLocationEnabled = true
                self.googleMap.settings.myLocationButton = true
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                marker.title = self.cityName
                marker.map = self.googleMap
                self.googleMap.animate(toLocation: CLLocationCoordinate2D(latitude: lat, longitude: long))
            }
        }
        
        testGppgle()
         */
        
        //        if let path = Bundle.main.path(forResource: "sample", ofType: "json") {
        //            do {
        //                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        //                let jsonObj = try JSON(data: data)
        //                print("jsonData:\(jsonObj.stringValue)")
        //                self.mapStyle = jsonObj.stringValue
        //
        //                do {
        //                  // Set the map style by passing a valid JSON string.
        //                    googleMap.mapStyle = try GMSMapStyle(jsonString: mapStyle)
        //                } catch {
        //                  print("One or more of the map styles failed to load. \(error)")
        //                }
        //            } catch let error {
        //                print("parse error: \(error.localizedDescription)")
        //            }
        //        } else {
        //            print("Invalid filename/path.")
        //        }
        
        
        
        imgSVGMap.isUserInteractionEnabled = true
        let dict  = [ "RU" : 12,
                      "IN" : 2,
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
    
    func testGppgle() {
        //    "message" : "Parameter 'format' must be one of: xml, json, jsonv2, geojson, geocodejson"
        
        //    https://nominatim.openstreetmap.org/search.php?q=Warsaw+Poland&polygon_geojson=1&format=json
        //        let key = "AIzaSyCbpJmRcahoG9cm330aEfMc3Owv85oP218"
        let queryItems = [URLQueryItem(name: "polygon_geojson", value: "1"), URLQueryItem(name: "q", value: cityName),URLQueryItem(name: "format", value: "geojson")]
        var urlComps = URLComponents(string: "https://nominatim.openstreetmap.org/search.php")
        urlComps?.queryItems = queryItems
        guard let serviceUrl = urlComps?.url else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let _ = try JSONSerialization.jsonObject(with: data, options: [])
                    // 3. From a GeoJSON file:
                    let decoder = JSONDecoder()
                    let path = GMSMutablePath()
                    if let geoJSON = try? decoder.decode(GeoJSON.self, from: data),
                       case let .featureCollection(feature) = geoJSON{
                        //                        let italy = feature.features.first?.geometry?.buffer(by: 1)
                        //                        debugPrint(italy)
                        
                        /*
                         feature.features.forEach { obj in
                         
                         switch obj.geometry {
                         case let .polygon(polygon):
                         // Do something with polygon
                         let points = polygon.exterior.points
                         let coords = points.map { p in CLLocationCoordinate2D(latitude: p.y, longitude: p.x) }
                         for c in coords {
                         path.add(c)
                         }
                         let polygonpath = GMSPolyline(path: path)
                         //                                polygonpath.fillColor = UIColor.red
                         polygonpath.strokeColor = .brown
                         polygonpath.strokeWidth = 5
                         polygonpath.geodesic = true
                         
                         //                                polygonpath.spans
                         //                                polygonpath.spans = [GMSStyleSpan(color: .red)]
                         //                                let solidRed = GMSStrokeStyle.solidColor(.red)
                         //                                polygonpath.spans = [GMSStyleSpan(style: solidRed)]
                         
                         polygonpath.map = self.mapView
                         
                         default:
                         break
                         }
                         }*/
                    }
                    
                    if let geoJSON = try? decoder.decode(GeoJSON.self, from: data),
                       case let .feature(feature) = geoJSON{
                        
                        switch feature.geometry {
                        case let .polygon(polygon):
                            // Do something with polygon
                            let points = polygon.exterior.points
                            let coords = points.map { p in CLLocationCoordinate2D(latitude: p.y, longitude: p.x) }
                            for c in coords {
                                path.add(c)
                            }
                            let polygonpath = GMSPolygon(path: path)
                            polygonpath.fillColor = UIColor.red
                            polygonpath.strokeColor = .brown
                            polygonpath.strokeWidth = 5
                            polygonpath.map = self.googleMap
                            
                        default:
                            break
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
