//
//  RestaurantCell.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 05.01.2025.
//

import UIKit

class RestaurantCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.heightAnchor.constraint(equalToConstant: 16).isActive = true
        label.numberOfLines = 1
        return label
    }()
    
    private let cuisineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let deliveryTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "heart"), for: .normal)
        button.setImage(UIImage(named: "heart.fill"), for: .selected)
        button.backgroundColor = .white
        button.tintColor = .customBlack
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true// Круглая форма
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7) // Уменьшаем картинку
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
      }()
    
    @objc private func favoriteButtonTapped() {
        favoriteButton.isSelected.toggle()
  
//        favoriteButton.setImage(UIImage(named: favoriteButton.isSelected ? "heart.fill" : "heart"), for: .normal)
        print(" in favorite")
    }
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ratingLabel, distanceLabel, deliveryTimeLabel])
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, cuisineLabel, hStackView])
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, textStackView])
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.alignment = .top
        return stackView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(mainStackView)
        contentView.addSubview(favoriteButton)
//        contentView.backgroundColor = .customGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            favoriteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 32),
            favoriteButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(with restaurant: Restaurant) {
        imageView.image = UIImage(named: restaurant.imageName)
        nameLabel.text = restaurant.name
        cuisineLabel.text = restaurant.cuisineType
        ratingLabel.text = "⭐️ \(restaurant.rating)"
        distanceLabel.text = "\(String(format: "| %.1f", restaurant.distance)) km |"
        deliveryTimeLabel.text = "\(restaurant.deliveryTime) mins"
    }
}
