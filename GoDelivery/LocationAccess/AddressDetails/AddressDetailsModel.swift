//
//  AddressModel.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 03.11.2024.
//

import Foundation
import CoreLocation

struct Address: Codable {
    var placeName: String
    var description: String?
    var houseNumber: String
    var floorNumber: String
    var buildingName: String
    var reachInstructions: String
    var contactNumber: String
    var addressType: String
    
    init(placeName: String, description: String, houseNumber: String, floorNumber: String, buildingName: String, reachInstructions: String, contactNumber: String, addressType: AddressType) {
        self.placeName = placeName
        self.description = description
        self.houseNumber = houseNumber
        self.floorNumber = floorNumber
        self.buildingName = buildingName
        self.reachInstructions = reachInstructions
        self.contactNumber = contactNumber
        self.addressType = addressType.rawValue
    }

    enum AddressType: String {
        case home = "Home"
        case office = "Office"
        case others = "Others"
    }
}
