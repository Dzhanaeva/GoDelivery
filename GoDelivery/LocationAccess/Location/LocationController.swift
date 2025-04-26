//
//  LocationController.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 17.10.2024.
//

import UIKit
import CoreLocation

class LocationController: UIViewController, SearchLocationVCDelegate {
    
    func didSelectLocation(location: CLLocationCoordinate2D, placeName: String, streetName: String) {
        // Создаем экземпляр вашего контроллера
        let mapVC = CurrentLocationMapVC()
        mapVC.location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        mapVC.placeNameLabel.text = placeName
        mapVC.streetNameLabel.text = streetName

        // Переходим к новому контроллеру
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
//    func didSelectAddress(_ address: String, location: CLLocation) {
//        let mapVC = CurrentLocationMapVC()
//        mapVC.location = location
//        navigationController?.pushViewController(mapVC, animated: true)
//    }
    
    
     let locationView = LocationView()
     let locationModel = LocationModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(locationView)
//        navigationController?.navigationBar.isHidden = true
        locationView.frame = view.bounds
        
        locationView.useCurrentLocationButton.addTarget(self, action: #selector(useCurrentLocation), for: .touchUpInside)
        locationView.enterManuallyButton.addTarget(self, action: #selector(enterManually), for: .touchUpInside)
        
        locationModel.onLocationUpdate = { [weak self] location in
            DispatchQueue.main.async {
                let mapVC = CurrentLocationMapVC()
                mapVC.location = location
                self?.navigationController?.pushViewController(mapVC, animated: true)
                }
            }
        
        locationModel.onLocationError = { [weak self] error in
            print("Failed to get location: \(error.localizedDescription)")
        }
        if self.parent != nil {
            print("Контроллер в иерархии представлений")
        } else {
            print("Контроллер не в иерархии представлений")
        }
        
    }
    
    func useCurrentLocationRequested() {
        useCurrentLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }

    @objc func useCurrentLocation() {
        
        if CLLocationManager.locationServicesEnabled() {
            locationModel.currentLocation = nil
            locationModel.requestWhenInUseAuthorization()
            // Задержка между запросами разрешения и получения местоположения может потребоваться
            self.locationModel.requestCurrentLocation()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                
//            }
        } else {
            print("Location services are not enabled.")
        }
    }

    @objc private func enterManually() {
        let searchVC = SearchLocationVC()
        searchVC.delegate = self
        navigationController?.present(searchVC, animated: true, completion: nil)
      

    }
}


