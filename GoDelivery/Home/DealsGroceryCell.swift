//
//  DealsGroceryCell.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 23.02.2025.
//

import UIKit

class DealsGroceryCell: UICollectionViewCell {
    
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
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let gramLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    

    private let pluseButton: UIButton = {
        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "heart"), for: .normal)
        button.setTitle("+", for: .normal)
        button.backgroundColor = .white
        button.tintColor = .clear
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true// Круглая форма
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7) // Уменьшаем картинку
        button.addTarget(self, action: #selector(pluseButtonTapped), for: .touchUpInside)
        return button
      }()
    
    @objc private func pluseButtonTapped() {
//        favoriteButton.isSelected.toggle()
//        favoriteButton.backgroundColor = .white
//        favoriteButton.setImage(UIImage(named: favoriteButton.isSelected ? "heart.fill" : "heart"), for: .normal)
        print("добавлено в корзину")
    }
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [priceLabel, gramLabel]
        )
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, hStackView])
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
        contentView.addSubview(pluseButton)
//        contentView.backgroundColor = .customGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        pluseButton.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            pluseButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            pluseButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            pluseButton.widthAnchor.constraint(equalToConstant: 32),
            pluseButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(with deal: Deal) {
        imageView.image = UIImage(named: deal.image)
        nameLabel.text = deal.title
        priceLabel.text = "₽ \(deal.price)"
        gramLabel.text = " /\( deal.gram) g "
    }
}

