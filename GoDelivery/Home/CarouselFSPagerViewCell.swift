//
//  CarouselCollectionViewCell.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 07.11.2024.
//

import UIKit
import FSPagerView

class CarouselFSPagerViewCell: FSPagerViewCell {
    
    lazy var oneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var twoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var threeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var photoView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var orderButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Order now", for: .normal)
        btn.backgroundColor = .black
        btn.tintColor = .white
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews(oneLabel, twoLabel, threeLabel, photoView, orderButton)
        self.layer.cornerRadius = 10
        self.backgroundColor = .red
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            oneLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            oneLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            
            twoLabel.leadingAnchor.constraint(equalTo: oneLabel.leadingAnchor),
            twoLabel.topAnchor.constraint(equalTo: oneLabel.bottomAnchor, constant: 2),
            
            threeLabel.leadingAnchor.constraint(equalTo: twoLabel.leadingAnchor),
            threeLabel.topAnchor.constraint(equalTo: twoLabel.bottomAnchor, constant: 2),
            
            orderButton.leadingAnchor.constraint(equalTo: threeLabel.leadingAnchor),
            orderButton.topAnchor.constraint(equalTo: threeLabel.bottomAnchor, constant: 5),
            orderButton.heightAnchor.constraint(equalToConstant: 30),
            orderButton.widthAnchor.constraint(equalToConstant: 90),
            
            photoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            photoView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            photoView.widthAnchor.constraint(equalToConstant: 90),
            photoView.heightAnchor.constraint(equalToConstant: 90)
            
        ])
    }
    
    func configure(with carousel: Carousel) {
        oneLabel.text = carousel.oneTitle
        twoLabel.text = carousel.twotitle
        threeLabel.text = carousel.threetitle
        photoView.image = carousel.image
        self.backgroundColor = carousel.backgroundColor
    }
}
