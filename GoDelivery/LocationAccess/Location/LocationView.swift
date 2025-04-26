//
//  LocationView.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 17.10.2024.
//

import UIKit

class LocationView: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Grant current location"
        label.textAlignment = .center
        label.textColor = .customBlack
        label.font = UIFont(name: "Mona-Sans-Bold", size: 24)
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "This let us show nearby restaurants,\nstores you can order from"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.font = UIFont(name: "Mona-Sans-Medium", size: 16)
        return label
    }()
    
    lazy var useCurrentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Use Current Location", for: .normal)
        button.backgroundColor = .customBlack
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 7
        return button
    }()
    
    lazy var enterManuallyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Enter Manually", for: .normal)
        button.backgroundColor = .systemGray6
        button.setTitleColor(.customBlack, for: .normal)
        button.layer.cornerRadius = 7
        return button
    }()
    
    lazy var imageLocation: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "imgLoc")
        img.translatesAutoresizingMaskIntoConstraints = false
//        img.contentMode = .scaleAspectFill
        return img
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        print("LocationView initialized")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(useCurrentLocationButton)
        addSubview(enterManuallyButton)
        addSubview(imageLocation)
        addSubview(subTitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        useCurrentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        enterManuallyButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: subTitleLabel.topAnchor, constant: -5),
            
            subTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTitleLabel.bottomAnchor.constraint(equalTo: useCurrentLocationButton.topAnchor, constant: -50),

            useCurrentLocationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            useCurrentLocationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            useCurrentLocationButton.bottomAnchor.constraint(equalTo: enterManuallyButton.topAnchor, constant: -20),
            useCurrentLocationButton.heightAnchor.constraint(equalToConstant: 50),

            enterManuallyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            enterManuallyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            enterManuallyButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            enterManuallyButton.heightAnchor.constraint(equalToConstant: 50),
            
            imageLocation.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            imageLocation.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            imageLocation.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            imageLocation.heightAnchor.constraint(equalToConstant: 210)
        ])
    }
}
