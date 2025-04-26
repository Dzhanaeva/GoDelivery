//
//  JSONLoader.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 05.01.2025.
//

import UIKit
import CoreLocation

class JSONLoader {
    static func loadRestaurants() -> [Restaurant] {
        guard let url = Bundle.main.url(forResource: "Restaurant", withExtension: "json")
                let data = try? Data(contentsOf: url),
              let restaurants = try? JSONDecoder().decode([Restaurant].self, from: data) else  {
            return []
        }
        
        return restaurants
    }
}


class NearbyRestaurantsService {
    func fetchNearbyRestaurants(completion: @escaping ([RestaurantLocation]) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Restaurant"
        
        // Определяем текущую координату пользователя
        let userLocation = CLLocationManager().location?.coordinate ?? CLLocationCoordinate2D()
        request.region = MKCoordinateRegion(
            center: userLocation,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                completion([])
                return
            }
            
            let locations = response.mapItems.map { item in
                RestaurantLocation(
                    name: item.name ?? "Unknown",
                    coordinate: item.placemark.coordinate,
                    distance: item.placemark.location?.distance(from: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)) ?? 0
                )
            }
            completion(locations)
        }
    }
}
