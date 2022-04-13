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
    @IBOutlet weak var googleMap: GMSMapView!
    
    var mapStyle = "JSON_STYLE_GOES_HERE"
    var cityName = "Surat, India"
    var latLong:CLLocationCoordinate2D? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.setStyleOfMap()
        
    }
    
    
    func configureMap(){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { placemarks, error in
            if let placemark = placemarks?.first{
                self.latLong = placemark.location!.coordinate
                self.loadDefaultPosition()
            }
        }
    }
    
    func loadDefaultPosition(){
        
        guard let cordinate  = self.latLong else {
            return
        }
        DispatchQueue.getMain {
            let camera = GMSCameraPosition.camera(withLatitude: cordinate.latitude, longitude: cordinate.longitude, zoom: 3.0) // point the initial location of map
            self.googleMap.camera = camera
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: cordinate.latitude, longitude: cordinate.longitude)
            marker.title = self.cityName
            marker.map = self.googleMap
            marker.icon = GMSMarker.markerImage(with: UIColor.black)
            self.googleMap.animate(toLocation: CLLocationCoordinate2D(latitude: cordinate.latitude, longitude: cordinate.longitude))
            self.googleMap.isUserInteractionEnabled = false
            
            //                    var visibleRegion : GMSVisibleRegion = self.googleMap.projection.visibleRegion()
            //                    var bounds = GMSCoordinateBounds(coordinate: visibleRegion.nearLeft, coordinate: visibleRegion.farRight)
            //                    self.googleMap.cameraTargetBounds = bounds
            
            self.testGppgle()
        }
    }
    
    func setStyleOfMap(){
        if let path = Bundle.main.path(forResource: "sample", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                DispatchQueue.getMain{
                    self.mapStyle = String.init(data: data, encoding: .utf8) ?? ""//jsonObj.stringValue
                    do{
                        // Set the map style by passing a valid JSON string.
                        self.googleMap.mapStyle = try GMSMapStyle(jsonString: self.mapStyle)
                    } catch {
                        print("One or more of the map styles failed to load. \(error)")
                    }
                }
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
    func testGppgle() {
        //    "message" : "Parameter 'format' must be one of: xml, json, jsonv2, geojson, geocodejson"
        
        //    https://nominatim.openstreetmap.org/search.php?q=Warsaw+Poland&polygon_geojson=1&format=json
        //        let key = "AIzaSyCbpJmRcahoG9cm330aEfMc3Owv85oP218"
//        let key  = "9edc2211bde844bf9e751b4099ca3aa8"
        ///https://api.geoapify.com/v1/boundaries/part-of?id=51290c25ee8c295240597eb5fa6129393740f00103f901b20a862e0000000092030b47616e6468696e61676172&geometry=geometry_1000&apiKey=YOUR_API_KEY
//  https://api.geoapify.com/v1/isoline?lat=48.13736145&lon=11.574172059316222&type=time&mode=transit&range=1800&apiKey=9edc2211bde844bf9e751b4099ca3aa8

        
        var queryItems = [URLQueryItem(name: "polygon_geojson", value: "1"),URLQueryItem(name: "format", value: "geojson"), URLQueryItem(name: "admin_level", value: "5"),URLQueryItem(name: "boundary", value: "administrative"),URLQueryItem(name: "zoom", value: "10")]
        if cityName.split(separator: ",").count == 2{
            let country = cityName.split(separator: ",")[1].trimmingCharacters(in: .whitespaces)
            let city = cityName.split(separator: ",")[0].trimmingCharacters(in: .whitespaces)
            queryItems.append(URLQueryItem(name: "country", value: country))
            queryItems.append(URLQueryItem(name: "q", value: cityName))
        }
        var urlComps = URLComponents(string: "https://nominatim.openstreetmap.org/search.php")
        urlComps?.queryItems = queryItems
        guard let serviceUrl = urlComps?.url else { return }
        var request = URLRequest(url: serviceUrl)
        
//        let str = "https://api.geoapify.com/v1/isoline?id=029721088690f17883749d9f61908ef4&apiKey=9edc2211bde844bf9e751b4099ca3aa8"
//        let url = URL.init(string: str)!
//        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
//                print(response)
            }
            
            DispatchQueue.getMain {
                
                if let data = data {
                    do {
                        let _ = try JSONSerialization.jsonObject(with: data, options: [])
                        // 3. From a GeoJSON file:
                        
                        /*
                        let geoJsonParser = GMUGeoJSONParser.init(data: data)
                        geoJsonParser.parse()

                        let style = GMUStyle(styleID: "random", stroke: UIColor.App_BG_SeafoamBlue_Color, fill: UIColor.App_BG_SeafoamBlue_Color, width: 2, scale: 1, heading: 0, anchor: CGPoint(x: 0, y: 0), iconUrl: nil, title: nil, hasFill: true, hasStroke: true)
                                
                        for feature in geoJsonParser.features {
                          feature.style = style
                        }
                        
                        let renderer = GMUGeometryRenderer(map: self.googleMap, geometries: geoJsonParser.features)
                        renderer.render()
                        */

                        
                         let decoder = JSONDecoder()
                         let path = GMSMutablePath()
                        if let geoJSON = try? decoder.decode(GeoJSON.self, from: data),
                           case let .featureCollection(feature) = geoJSON{
                            
                            
                            feature.features.forEach { obj in
                                switch obj.geometry {
                                    
                                    
                                case .multiPolygon(let multiplePoly):
                                    // Do something with polygon
                                    
                                    for cc in multiplePoly.polygons{
                                        let points = cc.exterior.points
                                        let coords = points.map { p in CLLocationCoordinate2D(latitude: p.y, longitude: p.x) }
                                        for c in coords {
                                            path.add(c)
                                        }
                                    }
                                    
                                    // drwi poligon
                                    let polygonpath = GMSPolygon(path: path)
                                    polygonpath.fillColor = UIColor.App_BG_SeafoamBlue_Color
                                    polygonpath.strokeColor = .App_BG_SeafoamBlue_Color
                                    polygonpath.strokeWidth = 3
                                    polygonpath.geodesic = false
                                    polygonpath.map = self.googleMap

                                case let .polygon(polygon):
                                    
                                    // Do something with polygon
                                    let points = polygon.exterior.points
                                    let coords = points.map { p in CLLocationCoordinate2D(latitude: p.y, longitude: p.x) }
                                    for c in coords {
                                        path.add(c)
                                    }
                                    
                                    
                                    // drwi poligon
                                    let polygonpath = GMSPolygon(path: path)
                                    polygonpath.fillColor = UIColor.App_BG_SeafoamBlue_Color
                                    polygonpath.strokeColor = .App_BG_SeafoamBlue_Color
                                    polygonpath.strokeWidth = 3
                                    polygonpath.geodesic = true
                                    polygonpath.map = self.googleMap

                                default:
                                    break
                                }
                            }
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
            }
        }.resume()
    }
}

