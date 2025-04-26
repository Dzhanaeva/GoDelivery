//
//  RestaurantsModel.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 05.01.2025.
//

import UIKit
import CoreLocation

struct Restaurant: Hashable, Decodable {
    let name: String
    let cuisineType: String
    let imageName: String
    let rating: Double
    let deliveryTime: Int
    let distance: Double
    
    // Реализация протокола Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)  // Используем имя ресторана для хеширования
    }
    
    // Реализация протокола Equatable
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.name == rhs.name  // Рестораны считаются одинаковыми, если у них одинаковое имя
    }
}

//struct RestaurantLocation {
//    let name: String
//    let coordinate: CLLocationCoordinate2D
//    let distance: Double
//}
//
//struct Restaurant: Decodable {
//    let name: String
//    let cuisineType: String
//    let imageName: String
//    let rating: Double
//    let distance: Double
//    let deliveryTime: Int
//    let latitude: Double
//    let longitude: Double
//}
