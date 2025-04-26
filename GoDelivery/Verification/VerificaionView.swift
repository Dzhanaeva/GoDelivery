//
//  VerificaionView.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 15.10.2024.
//

import UIKit

class VerificaionView: UIView {
    
    lazy var titleVerify: UILabel = {
        let title = UILabel()
        title.text = "Verify your details"
        title.font = UIFont(name: "Mona-Sans-Bold", size: 30)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.tintColor = .customBlack
        return title
    }()
    
    var otpTextFields: [UITextField] = []
    
    lazy var verifyBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Verify & continue", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .customBlack
        btn.layer.cornerRadius = 7
        btn.tintColor = .white
//        btn.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(titleVerify, verifyBtn)
        setupView()
        setupConstraints()
        setupTextFieldConstraints()
    }
    
//    @objc func
//
    private func setupView() {
        for _ in 0..<6 {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.textAlignment = .center
            textField.keyboardType = .numberPad
            textField.widthAnchor.constraint(equalToConstant: 40).isActive = true
            textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
            textField.layer.borderColor = UIColor.systemGray5.cgColor
            textField.layer.borderWidth = 1
            otpTextFields.append(textField)
            addSubview(textField)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleVerify.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleVerify.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleVerify.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            
            verifyBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            verifyBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            verifyBtn.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            verifyBtn.heightAnchor.constraint(equalToConstant: 44)
            
        ])
    }
    
    private func setupTextFieldConstraints() {
        for (index, textField) in otpTextFields.enumerated() {
            textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textField.widthAnchor.constraint(equalToConstant: 40),
                textField.heightAnchor.constraint(equalToConstant: 40),
                textField.topAnchor.constraint(equalTo: titleVerify.bottomAnchor, constant: 60),
                textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(20 + index * 50))
                
                
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
