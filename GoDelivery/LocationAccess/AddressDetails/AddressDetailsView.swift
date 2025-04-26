//
//  AddressDetailsView.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 02.11.2024.
//

import UIKit
import MapKit

protocol AddressDetailsViewDelegate: AnyObject {
    func updateMapLocation(with location: CLLocation)
}

class AddressDetailsView: UIView {
    
    weak var delegate: AddressDetailsViewDelegate?
    
    private let mapView: MKMapView = {
       let map = MKMapView()
        map.layer.cornerRadius = 9
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Address Details"
        label.font = UIFont(name: "Mona-Sans-Bold", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let placeLabel: UILabel = {
        let label = UILabel()
        label.text = "Place Name"
        label.numberOfLines = 0
         label.font = UIFont(name: "Mona-Sans-Bold", size: 22)
         label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
     let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Address Name"
        label.numberOfLines = 0
         label.font = UIFont(name: "Mona-Sans-Medium", size: 14)
//         label.font = .systemFont(ofSize: 14)
         label.textColor = .systemGray2
         label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let houseLabel: UILabel = {
       let label = UILabel()
       label.text = "House / Flat number"
       label.numberOfLines = 0
        label.font = UIFont(name: "Mona-Sans-Medium", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
    
     let houseNumberTextField = createTextField(placeholder: "")
    
    let floorLabel: UILabel = {
       let label = UILabel()
       label.text = "Floor number"
       label.numberOfLines = 0
        label.font = UIFont(name: "Mona-Sans-Medium", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
    
     let floorNumberTextField = createTextField(placeholder: "")
    
    let apartmentLabel: UILabel = {
       let label = UILabel()
       label.text = "Apartment / Building name"
       label.numberOfLines = 0
        label.font = UIFont(name: "Mona-Sans-Medium", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
    
     let buildingNameTextField = createTextField(placeholder: "")
    
    let directionsLabel: UILabel = {
       let label = UILabel()
       label.text = "How to reach"
       label.numberOfLines = 0
        label.font = UIFont(name: "Mona-Sans-Medium", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
    
    
     let directionsTextField = createTextField(placeholder: "")
    
    let contactLabel: UILabel = {
       let label = UILabel()
       label.text = "Contact number"
       label.numberOfLines = 0
        label.font = UIFont(name: "Mona-Sans-Medium", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
    
     let contactNumberTextField = createTextField(placeholder: "")
    
     let homeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Home", for: .normal)
        button.setTitleColor(.customGray, for: .normal)
        button.setTitleColor(.customBlack, for: .selected)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.addTarget(self, action: #selector(addressTypeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

     let officeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Work", for: .normal)
        button.setTitleColor(.customGray, for: .normal)
        button.setTitleColor(.customBlack, for: .selected)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.addTarget(self, action: #selector(addressTypeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

     let otherButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Other", for: .normal)
        button.setTitleColor(.customGray, for: .normal)
        button.setTitleColor(.customBlack, for: .selected)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.addTarget(self, action: #selector(addressTypeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    let addressTypeLabel: UILabel = {
       let label = UILabel()
       label.text = "Address Type"
       label.numberOfLines = 0
        label.font = UIFont(name: "Mona-Sans-Medium", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
    
    
    
    private let addressTypeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 17

//        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private func setupStack() {
        addressTypeStack.addArrangedSubview(homeButton)
        addressTypeStack.addArrangedSubview(officeButton)
        addressTypeStack.addArrangedSubview(otherButton)
        
        addressTypeButtonTapped(homeButton)
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()
    
    @objc private func addressTypeButtonTapped(_ sender: UIButton) {
        // Сбрасываем цвета всех кнопок
        [homeButton, officeButton, otherButton].forEach {
            $0.backgroundColor = .white
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.systemGray4.cgColor
            $0.setTitleColor(.customGray, for: .normal)
        }
        
        // Устанавливаем выбранное состояние для нажатой кнопки
        sender.backgroundColor = .customLightGreen
        sender.layer.borderWidth = 0
        sender.setTitleColor(.black, for: .normal)
    }
    
     let addAddressButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Address", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 7
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 7
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupUI() {
        backgroundColor = .white
    
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubviews(houseLabel, floorLabel, directionsLabel, contactLabel, apartmentLabel, titleLabel, placeLabel, mapView, addressLabel, houseNumberTextField, floorNumberTextField, buildingNameTextField, directionsTextField, contactNumberTextField, addressTypeStack, addAddressButton, cancelButton, addressTypeLabel)

        
        mapView.delegate = self

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupStack()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        setupUI()
//        setConstraints()
    }
    
    func updateMapLocation(_ location: CLLocation) {
        let coordinate = location.coordinate
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    private func setConstraints() {
        houseNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        floorNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        directionsTextField.translatesAutoresizingMaskIntoConstraints = false
        contactNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        buildingNameTextField.translatesAutoresizingMaskIntoConstraints = false
        addressTypeStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            mapView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            mapView.heightAnchor.constraint(equalToConstant: 150),
            
            placeLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 16),
            placeLabel.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            
            addressLabel.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: 6),
            addressLabel.leadingAnchor.constraint(equalTo: placeLabel.leadingAnchor),
            
            houseLabel.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor),
            houseLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 30),
            
            houseNumberTextField.topAnchor.constraint(equalTo: houseLabel.bottomAnchor, constant: 10),
            houseNumberTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            houseNumberTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            houseNumberTextField.heightAnchor.constraint(equalToConstant: 44),
            
            floorLabel.leadingAnchor.constraint(equalTo: houseNumberTextField.leadingAnchor),
            floorLabel.topAnchor.constraint(equalTo: houseNumberTextField.bottomAnchor, constant: 20),
            
            floorNumberTextField.topAnchor.constraint(equalTo: floorLabel.bottomAnchor, constant: 8),
            floorNumberTextField.leadingAnchor.constraint(equalTo: floorLabel.leadingAnchor),
            floorNumberTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            floorNumberTextField.heightAnchor.constraint(equalToConstant: 44),
            
            apartmentLabel.leadingAnchor.constraint(equalTo: floorNumberTextField.leadingAnchor),
            apartmentLabel.topAnchor.constraint(equalTo: floorNumberTextField.bottomAnchor, constant: 20),
            
            buildingNameTextField.topAnchor.constraint(equalTo: apartmentLabel.bottomAnchor, constant: 8),
            buildingNameTextField.leadingAnchor.constraint(equalTo: apartmentLabel.leadingAnchor),
            buildingNameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            buildingNameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            directionsLabel.leadingAnchor.constraint(equalTo: buildingNameTextField.leadingAnchor),
            directionsLabel.topAnchor.constraint(equalTo: buildingNameTextField.bottomAnchor, constant: 20),
            
            directionsTextField.topAnchor.constraint(equalTo: directionsLabel.bottomAnchor, constant: 8),
            directionsTextField.leadingAnchor.constraint(equalTo: directionsLabel.leadingAnchor),
            directionsTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            directionsTextField.heightAnchor.constraint(equalToConstant: 44),
            
            contactLabel.leadingAnchor.constraint(equalTo: directionsTextField.leadingAnchor),
            contactLabel.topAnchor.constraint(equalTo: directionsTextField.bottomAnchor, constant: 20),
            
            contactNumberTextField.topAnchor.constraint(equalTo: contactLabel.bottomAnchor, constant: 8),
            contactNumberTextField.leadingAnchor.constraint(equalTo: contactLabel.leadingAnchor),
            contactNumberTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            contactNumberTextField.heightAnchor.constraint(equalToConstant: 44),
            
            addressTypeLabel.leadingAnchor.constraint(equalTo: contactNumberTextField.leadingAnchor),
            addressTypeLabel.topAnchor.constraint(equalTo: contactNumberTextField.bottomAnchor, constant: 23),
            
            
            addressTypeStack.topAnchor.constraint(equalTo: addressTypeLabel.bottomAnchor, constant: 16),
            addressTypeStack.leadingAnchor.constraint(equalTo: addressTypeLabel.leadingAnchor),

            
            addAddressButton.topAnchor.constraint(equalTo: addressTypeStack.bottomAnchor, constant: 25),
            addAddressButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            addAddressButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            addAddressButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.topAnchor.constraint(equalTo: addAddressButton.bottomAnchor, constant: 8),
            cancelButton.leadingAnchor.constraint(equalTo: addAddressButton.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: addAddressButton.trailingAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                   
            
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])
    
    }
    
    private static func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect

        return textField
    }
}

extension AddressDetailsView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "CustomAnnotation"
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.image = UIImage(named: "mark2")
            annotationView?.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }

}
