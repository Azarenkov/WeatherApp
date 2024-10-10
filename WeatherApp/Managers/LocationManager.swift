//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Алексей Азаренков on 03.10.2024.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var lastKnownLocation: CLLocationCoordinate2D?
    var manager = CLLocationManager()
    
    func checkLocationAuthorization() {
        
        manager.delegate = self
        manager.startUpdatingLocation()
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location restricted")
            
        case .denied:
            print("Location denied")
            
        case .authorizedAlways:
            print("Location authorizedAlways")
            
        case .authorizedWhenInUse:
            print("Location authorized when in use")
            lastKnownLocation = manager.location?.coordinate
            
        @unknown default:
            print("Location service disabled")
        
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
    
    func cityAndCountry(completion: @escaping (_ city: String?, _ country: String?) -> Void) {
        if let lastKnownLocation = lastKnownLocation {
            let location = CLLocation(latitude: lastKnownLocation.latitude, longitude: lastKnownLocation.longitude)
            
            location.placemark { placemark, error in
                guard let placemark = placemark, error == nil else {
                    print("Error:", error ?? "Unknown error")
                    completion(nil, nil)
                    return
                }

                completion(placemark.locality, placemark.country)
            }
        } else {
            completion(nil, nil)
        }
    }
}

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}
