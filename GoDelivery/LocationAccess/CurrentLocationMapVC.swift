//
//  CurrentLocationMap.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 17.10.2024.
//

import UIKit
import MapKit
import CoreLocation

class CurrentLocationMapVC: UIViewController, CLLocationManagerDelegate, SearchLocationVCDelegate {
    
    
    func useCurrentLocationRequested() {
        print("location")
    }
    
    weak var addressDetailsDelegate: AddressDetailsViewDelegate?
    
    func passLocationToAddressDetailsView() {
        if let currentLocation = self.location {
            addressDetailsDelegate?.updateMapLocation(with: currentLocation)
        }
    }
    
    
    func didSelectLocation(location: CLLocationCoordinate2D, placeName: String, streetName: String) {
        selectedLocation = location
        placeNameLabel.text = placeName
        streetNameLabel.text = streetName
        
        // Удалите предыдущие аннотации и добавьте новую
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
        // Центрирование карты на выбранной локации
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
    }
    
    var mapView = MKMapView()
    var locationManager = CLLocationManager()
    var location: CLLocation?
    var selectedLocation: CLLocationCoordinate2D?
    
    private let addressView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        return view
    }()
    
    let locationImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "location")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    let placeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Place Name"
        label.numberOfLines = 0
        label.font = UIFont(name: "Mona-Sans-Bold", size: 20)
        label.textColor = .black
        return label
    }()
    
    let streetNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Street Name"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    private let changeAddressButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change", for: .normal)
        button.backgroundColor = .customLightGreen
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 13
        button.addTarget(self, action: #selector(changeAddressButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let confirmAddressButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm Location", for: .normal)
        button.backgroundColor = .customBlack
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(confirmLocationTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        setupCustomBackButton()
        setupMapView()
        setupAddressView()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        if let location = location {
            centerMapOnLocation(location)
            reverseGeocode(location: location.coordinate)
        }
    }
    
    deinit {
        locationManager.delegate = nil
    }
    
    @objc private func confirmLocationTapped() {
        
        // Разделение текста streetNameLabel на название улицы и номер дома
        let streetComponents = placeNameLabel.text?.components(separatedBy: " ")
        
        var streetName = ""
        var houseNumber = ""
        
        if let components = streetComponents, components.count > 1 {
            // Присваиваем все слова, кроме последнего, в streetName и последнее слово в houseNumber
            streetName = components.dropLast().joined(separator: " ")
            houseNumber = components.last ?? ""
        } else {
            // Если в тексте streetNameLabel одно слово или его нет
            streetName = streetNameLabel.text ?? ""
        }
        let savedPhoneNumber = UserDefaults.standard.string(forKey: "registeredPhoneNumber") ?? ""
        
        let address = Address(
            
            placeName: streetName,
            description: streetNameLabel.text ?? "",
            houseNumber: houseNumber,
            floorNumber: "",
            buildingName: "",
            reachInstructions: "",
            contactNumber: savedPhoneNumber,
            addressType: .home
        )
        
        let addressDetailsVC = AddressDetailsVC(address: address)
        addressDetailsVC.updateMapLocation(with: location!)
        
        addressDetailsVC.onAddressSaved = { [weak self] in
            // Переход на home после закрытия модального экрана
            let tabBar = TabBarController()
            self?.navigationController?.pushViewController(tabBar, animated: true)
        }
        
        present(addressDetailsVC, animated: true)
    }
    
    @objc private func changeAddressButtonTapped() {
        let searchLocationVC = SearchLocationVC() // Инициализируем контроллер

        searchLocationVC.delegate = self 
        self.present(searchLocationVC, animated: true, completion: nil)
    }
    
    private func setupCustomBackButton() {
        let backButton = UIButton(type: .system)
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 20
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOpacity = 0.2
        backButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        backButton.layer.shadowRadius = 4
        backButton.setImage(UIImage(named: "arrow"), for: .normal) // Замените на свою иконку
        backButton.tintColor = .black  // Установите нужный цвет
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Размещаем кнопку в верхней части экрана
        mapView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 10),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    
    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.removeAnnotations(mapView.annotations)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.tintColor = .customLightGreen
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), // Чтобы не перекрывать верхнюю часть
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        

    }
    
    private func setupAddressView() {
        view.addSubview(addressView)
        addressView.translatesAutoresizingMaskIntoConstraints = false
        
        addressView.addSubview(placeNameLabel)
        addressView.addSubview(streetNameLabel)
        addressView.addSubview(changeAddressButton)
        addressView.addSubview(confirmAddressButton)
        addressView.addSubview(locationImage)
        
        placeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        streetNameLabel.translatesAutoresizingMaskIntoConstraints = false
        changeAddressButton.translatesAutoresizingMaskIntoConstraints = false
        confirmAddressButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addressView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            addressView.heightAnchor.constraint(equalToConstant: 200),
            
            locationImage.leadingAnchor.constraint(equalTo: addressView.leadingAnchor, constant: 15),
            locationImage.topAnchor.constraint(equalTo: addressView.topAnchor, constant: 30),
            locationImage.widthAnchor.constraint(equalToConstant: 17),
            locationImage.heightAnchor.constraint(equalToConstant: 25),
            
            placeNameLabel.topAnchor.constraint(equalTo: addressView.topAnchor, constant: 30),
            placeNameLabel.leadingAnchor.constraint(equalTo: locationImage.trailingAnchor, constant: 5),
            placeNameLabel.trailingAnchor.constraint(equalTo: changeAddressButton.leadingAnchor, constant: -10),
            
            streetNameLabel.topAnchor.constraint(equalTo: placeNameLabel.bottomAnchor, constant: 5),
            streetNameLabel.leadingAnchor.constraint(equalTo: locationImage.trailingAnchor, constant: 5),
            streetNameLabel.trailingAnchor.constraint(equalTo: changeAddressButton.leadingAnchor, constant: -10),
            streetNameLabel.bottomAnchor.constraint(equalTo: confirmAddressButton.topAnchor, constant: -30),
            
            changeAddressButton.centerYAnchor.constraint(equalTo: placeNameLabel.centerYAnchor, constant: 10),
            changeAddressButton.trailingAnchor.constraint(equalTo: addressView.trailingAnchor, constant: -15),
            changeAddressButton.widthAnchor.constraint(equalToConstant: 70),
            
            confirmAddressButton.bottomAnchor.constraint(equalTo: addressView.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            confirmAddressButton.leadingAnchor.constraint(equalTo: addressView.leadingAnchor, constant: 15),
            confirmAddressButton.trailingAnchor.constraint(equalTo: addressView.trailingAnchor, constant: -15),
            confirmAddressButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func centerMapOnLocation(_ location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView.addAnnotation(annotation)
    }
    
    @objc private func handleMapTap(_ gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        // Remove previous annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Add new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        // Center the map on the selected coordinate and zoom in
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
        
        selectedLocation = coordinate
        reverseGeocode(location: coordinate)
//        fetchNearbyPOIs(coordinate: coordinate)
    }

    private func reverseGeocode(location: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        
        let locationPoint = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        geocoder.reverseGeocodeLocation(locationPoint) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error getting placemark: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            
            // Обновляем информацию в лейблах placeNameLabel и streetNameLabel
            self.placeNameLabel.text = "\(placemark.thoroughfare ?? "") \(placemark.subThoroughfare ?? "")"
            self.streetNameLabel.text = "\(placemark.administrativeArea ?? ""), \(placemark.locality ?? ""), \(placemark.postalCode ?? "")"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        print("Updated location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
//        centerMapOnLocation(location)
    }

    
}


extension CurrentLocationMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "CustomAnnotation"
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.image = UIImage(named: "mark")
            annotationView?.bounds = CGRect(x: 0, y: 0, width: 30, height: 45)
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }

}
