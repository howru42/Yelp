//
//  LocationManager.swift
//  Yelp
//
//  Created by Nkommuri on 14/03/22.
//

import UIKit
import CoreLocation

protocol LocationDelegate{
    func onNewLocation(coordinate:CLLocationCoordinate2D?)
    func onLocationError(restricted:Bool,error:String?)
}

extension LocationDelegate{
    func onNewLocation(coordinate:CLLocationCoordinate2D?) {
        
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()
    private var locationManager: CLLocationManager = CLLocationManager()
    var userLocation:CLLocationCoordinate2D?
    
    var onNewLocation:(()->Void)?
    var onLocationRestricted:(()->Void)?
    var locationDelegate:LocationDelegate?
    
    func initLocation(){
        locationManager.delegate = self
        actionBasedOnStatus()
    }
    
    func actionBasedOnStatus(){
        let currentStatus = CLLocationManager.authorizationStatus()
        switch currentStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted,.denied:
            locationDelegate?.onLocationError(restricted: true, error: nil)
        case .authorizedAlways,.authorizedWhenInUse,.authorized:
//            if userLocation == nil {
                locationManager.startUpdatingLocation()
//            }
        default:
            break
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus) {
        actionBasedOnStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            debugPrint("Current Location: \(latitude)..lat and \(longitude)..long")
            setUserLocation(location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationDelegate?.onLocationError(restricted: false, error: error.localizedDescription)
    }
    
    private func setUserLocation(_ coordinate:CLLocationCoordinate2D? = nil){
        locationManager.stopUpdatingLocation()
//        if userLocation == nil{
            userLocation = coordinate
            locationDelegate?.onNewLocation(coordinate: userLocation)
//        }
//        locationManager.stopUpdatingLocation()
    }
}
