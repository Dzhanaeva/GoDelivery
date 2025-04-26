//
//  LocationModel.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 17.10.2024.
//

//import Foundation
import CoreLocation
import UIKit

class LocationModel: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
     var onLocationUpdate: ((CLLocation) -> Void)?
    var onLocationError: ((Error) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
//        requestWhenInUseAuthorization()
//        locationManager.requestWhenInUseAuthorization()

    }
    
//    func requestCurrentLocation() {
//        locationManager.requestLocation()
//    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestCurrentLocation() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.locationManager.requestLocation()
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.currentLocation = location
        
        // Обновление UI должно происходить в основном потоке
        DispatchQueue.main.async { [weak self] in
            self?.onLocationUpdate?(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onLocationError?(error)
        DispatchQueue.main.async { [weak self] in
            self?.onLocationError?(error)
        }
        print("Failed to get user's location: \(error.localizedDescription)")
    }
}
