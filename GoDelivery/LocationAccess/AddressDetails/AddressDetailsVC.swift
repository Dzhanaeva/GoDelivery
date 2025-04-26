//
//  AddressVC.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 03.11.2024.
//

import UIKit
import CoreLocation
import MapKit



class AddressDetailsVC: UIViewController, AddressDetailsViewDelegate {
    
    func updateMapLocation(with location: CLLocation) {
        addressView.updateMapLocation(location)
    }
    
    var onAddressSaved: (() -> Void)?
    private let addressView = AddressDetailsView()
    private var address: Address?
    
    init(address: Address) {
        self.address = address
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        view = addressView
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressView.delegate = self
        setupViewData()
        
        addressView.addAddressButton.addTarget(self, action: #selector(addAddressButtonTapped), for: .touchUpInside)
    }
    
    @objc func addAddressButtonTapped() {
        let selectedAddressType: Address.AddressType = {
            if addressView.homeButton.backgroundColor == .customLightGreen { return .home }
            else if addressView.officeButton.backgroundColor == .customLightGreen { return .office }
            else { return .others }
        }()
        
        let address = Address(placeName: addressView.placeLabel.text ?? "",
                              description: "",
                              houseNumber: addressView.houseNumberTextField.text ?? "",
                              floorNumber: addressView.floorNumberTextField.text ?? "",
                              buildingName: addressView.buildingNameTextField.text ?? "",
                              reachInstructions: addressView.directionsTextField.text ?? "",
                              contactNumber: addressView.contactNumberTextField.text ?? "",
                              addressType: selectedAddressType)
        AuthManager.shared.saveAddressToFirebase(address) { [weak self] error in
            if let error = error {
                print("Ошибка сохранения адреса:", error.localizedDescription)
                return
            }
            
            // Закрываем модальный экран и вызываем onAddressSaved после закрытия
            self?.dismiss(animated: true) {
                self?.onAddressSaved?()
            }
        }
        
    }

    private func setupViewData() {
        guard let address = address else { return }
        addressView.placeLabel.text = address.placeName
        addressView.addressLabel.text = address.description
        addressView.houseNumberTextField.text = address.houseNumber
        addressView.floorNumberTextField.text = address.floorNumber
        addressView.buildingNameTextField.text = address.buildingName
        addressView.directionsTextField.text = address.reachInstructions
        addressView.contactNumberTextField.text = address.contactNumber
    }
    
}
