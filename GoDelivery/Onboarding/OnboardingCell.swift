//
//  OnboardingCell.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 12.10.2024.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    
    var titleLabel = UILabel()
    var desLabel = UILabel()
    var image = UIImageView()
    var onNextButtonTapped: (() -> Void)?
    
    lazy var nextBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .customBlack
        btn.titleLabel?.font = UIFont(name: "Mona-Sans-Medium", size: 18)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 7
        btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(titleLabel, desLabel, nextBtn, image)
        setupConstraints()
        setupUI()
        
    }
    
    @objc private func buttonTapped() {
        onNextButtonTapped?()
    }
    
    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Mona-Sans-Bold", size: 22)
        titleLabel.textColor = .customBlack
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        
        desLabel.translatesAutoresizingMaskIntoConstraints = false
        desLabel.textColor = .lightGray
        desLabel.font = UIFont(name: "Mona-Sans-Medium", size: 12)
        desLabel.numberOfLines = 0
        desLabel.textAlignment = .center
        
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
    

    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            nextBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            nextBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            nextBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            nextBtn.heightAnchor.constraint(equalToConstant: 44),
            
            desLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            desLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            desLabel.bottomAnchor.constraint(equalTo: nextBtn.topAnchor, constant: -40),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: desLabel.topAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
