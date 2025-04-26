//
//  JSONLoader.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 05.01.2025.
//

import UIKit
import CoreLocation
import MapKit

// MARK: - JSONLoader: загрузка ресторанов из JSON
class JSONLoader {
    
    static func loadRestaurants(completion: @escaping ([Restaurant]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let url = Bundle.main.url(forResource: "Restaurant", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                print("Ошибка: JSON-файл не найден или данные не загружены.")
                DispatchQueue.main.async { completion([]) }
                return
            }
            
            do {
                let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                DispatchQueue.main.async { completion(restaurants) }
            } catch {
                print("Ошибка декодирования JSON: \(error)")
                DispatchQueue.main.async { completion([]) }
            }
        }
    }
}

protocol ServerDelegate: AnyObject {
    func didFetchRestaurants(_ restaurants: [Restaurant])
}

// MARK: - NearbyRestaurantsService: поиск ближайших ресторанов
class NearbyRestaurantsService {
    
    weak var delegate: ServerDelegate?
    private let locationModel = LocationModel()
    
    init() {
        // Подписка на обновления местоположения
        locationModel.onLocationUpdate = { [weak self] location in
            print("🔹 Получено текущее местоположение: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            self?.fetchNearbyRestaurants(with: location)
        }
        
        locationModel.onLocationError = { error in
            print("❌ Ошибка при получении местоположения: \(error.localizedDescription)")
        }
        
        // Запрашиваем местоположение
        locationModel.requestCurrentLocation()
    }
    
    func fetchNearbyRestaurants(with location: CLLocation) {
        let searchQueries = ["Restaurant", "Cafe"]
        var allRestaurants: [Restaurant] = []
        let group = DispatchGroup()  // Группа для синхронизации запросов

        for query in searchQueries {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
            request.region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )

            let search = MKLocalSearch(request: request)
            group.enter()  // Вход в группу для каждого запроса
            search.start { [weak self] (response, error) in
                defer { group.leave() }  // Выход из группы после завершения запроса
                
                if let error = error {
                    print("❌ Ошибка при поиске ресторанов: \(error.localizedDescription)")
                    return
                }

                guard let response = response else {
                    print("❌ Ответ от поиска ресторанов пуст.")
                    return
                }

                let mapRestaurants = response.mapItems.map { mapItem -> Restaurant in
                    let distance = location.distance(from: mapItem.placemark.location ?? location)
                    return Restaurant(
                        name: mapItem.name ?? "Неизвестно",
                        cuisineType: "Неизвестно",
                        imageName: "",
                        rating: 0,
                        deliveryTime: Int.random(in: 10...60),
                        distance: distance / 1000 // в километрах
                    )
                }
                allRestaurants.append(contentsOf: mapRestaurants)
            }
        }

        // Когда все запросы завершены, вызываем combineData
        group.notify(queue: .main) { [weak self] in
            let uniqueRestaurants = Array(Set(allRestaurants))
            self?.combineData(with: uniqueRestaurants)
        }
    }
    
//    func fetchNearbyRestaurants(with location: CLLocation) {
//        //        let pointOfInterestFilter = MKPointOfInterestFilter(
//        //            including: [.restaurant, .cafe]
//        //        )
//        //        print(pointOfInterestFilter)
//        let searchQueries = ["Restaurant", "Cafe"]
//        var allRestaurants: [Restaurant] = []
//        
//        
//        for query in searchQueries {
//            let request = MKLocalSearch.Request()
//            request.naturalLanguageQuery = query
//            request.region = MKCoordinateRegion(
//                center: location.coordinate,
//                latitudinalMeters: 1000,
//                longitudinalMeters: 1000
//            )
//
//            
//            let search = MKLocalSearch(request: request)
//            search.start { [weak self] (response, error) in
//                if let error = error {
//                    print("❌ Ошибка при поиске ресторанов: \(error.localizedDescription)")
//                    return
//                }
//                
//                guard let response = response else {
//                    print("❌ Ответ от поиска ресторанов пуст.")
//                    return
//                }
//                
//                
//                let mapRestaurants = response.mapItems.map { mapItem -> Restaurant in
//                    let distance = location.distance(from: mapItem.placemark.location ?? location)
//                    return Restaurant(
//                        name: mapItem.name ?? "Неизвестно",
//                        cuisineType: "Неизвестно",
//                        imageName: "",
//                        rating: 0,
//                        deliveryTime: Int.random(in: 10...60),
//                        distance: distance / 1000 // в километрах
//                    )
//                }
//                allRestaurants.append(contentsOf: mapRestaurants)
//
//                self?.combineData(with: allRestaurants)
//            }
//        }
//        
//    }
    
    private func combineData(with mapRestaurants: [Restaurant]) {
        JSONLoader.loadRestaurants { jsonRestaurants in
            var combinedRestaurants: [Restaurant] = []

            for mapRestaurant in mapRestaurants {
                if let jsonRestaurant = jsonRestaurants.first(where: {
                    $0.name.lowercased().trimmingCharacters(in: .whitespaces) ==
                    mapRestaurant.name.lowercased().trimmingCharacters(in: .whitespaces)
                }) {
                    combinedRestaurants.append(Restaurant(
                        name: mapRestaurant.name,
                        cuisineType: jsonRestaurant.cuisineType,
                        imageName: jsonRestaurant.imageName,
                        rating: jsonRestaurant.rating,
                        deliveryTime: mapRestaurant.deliveryTime,
                        distance: mapRestaurant.distance
                    ))
                }
            }

            print("✅ Финальный список ресторанов:")
            combinedRestaurants.forEach { restaurant in
                print("🍽 \(restaurant.name) | Кухня: \(restaurant.cuisineType) | Рейтинг: \(restaurant.rating) | 📍 \(restaurant.distance) км | ⏳ \(restaurant.deliveryTime) мин")
            }

            DispatchQueue.main.async {
                self.delegate?.didFetchRestaurants(combinedRestaurants)
            }
        }
    }
    
//    private func combineData(with mapRestaurants: [Restaurant]) {
//        // Загружаем данные из JSON
//        let jsonRestaurants = JSONLoader.loadRestaurants()
//        
//        var combinedRestaurants: [Restaurant] = []
//
//        for mapRestaurant in mapRestaurants {
//            // Ищем соответствие по названию
//            if let jsonRestaurant = jsonRestaurants.first(where: { $0.name.lowercased().trimmingCharacters(in: .whitespaces) == mapRestaurant.name.lowercased().trimmingCharacters(in: .whitespaces) }) {
//                combinedRestaurants.append(Restaurant(
//                    name: mapRestaurant.name,
//                    cuisineType: jsonRestaurant.cuisineType,
//                    imageName: jsonRestaurant.imageName,
//                    rating: jsonRestaurant.rating,
//                    deliveryTime: mapRestaurant.deliveryTime,
//                    distance: mapRestaurant.distance
//                ))
//            }
//        }
//
//        print("✅ Финальный список ресторанов:")
//        combinedRestaurants.forEach { restaurant in
//            print("🍽 \(restaurant.name) | Кухня: \(restaurant.cuisineType) | Рейтинг: \(restaurant.rating) | 📍 \(restaurant.distance) км | ⏳ \(restaurant.deliveryTime) мин")
//        }
//
//        // Обновляем коллекцию
//        delegate?.didFetchRestaurants(combinedRestaurants)
//    }
//    

}

