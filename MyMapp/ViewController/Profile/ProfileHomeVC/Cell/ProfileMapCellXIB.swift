//
//  ProfileMapCellXIB.swift
//  MyMapp
//
//  Created by Chirag Pandya on 04/12/21.
//

import UIKit
import MapKit
import GoogleMaps

class ProfileMapCellXIB: UICollectionViewCell {
    
    //MARK: - VARIABLES
    @IBOutlet weak var viewGoogleMap: GMSMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if LocationManager.shared.isLocationEnabled() {
            LocationManager.shared.getLocation { (location: CLLocation?, error: NSError?) in
                
                if let error = error{
                    return
                }
                
                guard let location = location else {
                    return
                }
                self.viewGoogleMap.delegate = self
                self.viewGoogleMap.clear()
                self.viewGoogleMap.isMyLocationEnabled = false
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: appDelegateShared.locationDataGetModel.lattitude, longitude: appDelegateShared.locationDataGetModel.longitude)
                marker.icon = UIImage(named: "ic_current_Location")
                marker.map = self.viewGoogleMap
                
                //                let camera = GMSCameraPosition.camera(withLatitude: appDelegateShared.locationDataGetModel.lattitude,longitude: appDelegateShared.locationDataGetModel.longitude, zoom: 0)
                //                self.viewGoogleMap.camera = camera
                
                //                do {
                //                        if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
                //                            self.viewGoogleMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                //                        } else {
                //                            print("Unable to find style.json")
                //                        }
                //                    } catch {
                //                        print("The style definition could not be loaded: \(error)")
                //                    }
                
                let hydeParkLocation = CLLocationCoordinate2D(latitude: 37.36, longitude: -122.0)
                let camera = GMSCameraPosition.camera(withTarget: hydeParkLocation, zoom: 12)
                self.viewGoogleMap.camera = camera
                //                let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
                //                mapView.animate(to: camera)
                
                let rect = GMSMutablePath()
                rect.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.0))
                rect.add(CLLocationCoordinate2D(latitude: 37.45, longitude: -122.0))
                rect.add(CLLocationCoordinate2D(latitude: 37.45, longitude: -122.2))
                rect.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.2))
                
                // Create the polygon, and assign it to the map.
                let polygon = GMSPolygon(path: rect)
                polygon.fillColor = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.05);
                polygon.strokeColor = .black
                polygon.strokeWidth = 2
                polygon.map = self.viewGoogleMap
            }
        }
    }
}

//TODO: Tapped on GMSMarker
extension ProfileMapCellXIB:GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
    
    //TODO: Get infoTab Selection
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let inex:Int = Int(marker.accessibilityLabel!)!
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("!map tapped!")
    }
}
