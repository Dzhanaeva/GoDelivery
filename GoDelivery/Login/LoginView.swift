//
//  LoginView.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 15.10.2024.
//

import UIKit

class LoginView: UIView {
    
    let countryCodes = [("+91", "🇮🇳", "India"), ("+1", "🇺🇸", "USA"), ("+7", "🇷🇺", "Russia")]
    var selectedCountryCode = "+91"
    var fullPhoneNumber: String {
        return selectedCountryCode + numberTextField.text!.trimmingCharacters(in: .whitespaces)
    }
    
    let numberTextField = UITextField()
    let countryCodeButton = UIButton()
    
    let dropdownTableView = UITableView()
    var isDropdownVisible = false
    
    let codeLabel = UILabel()
    
    let terms: String = "Terms & Conditions"
    let policy: String = "Privacy Policy"

    
    lazy var droneImg: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "droneImage")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Get started with app"
        label.font = UIFont(name: "Mona-Sans-Bold", size: 22)
        label.textColor = .customBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Login or sign up to use app"
        label.font = UIFont(name: "Mona-Sans-Medium", size: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your phone"
        label.font = UIFont(name: "Mona-Sans-Bold", size: 15)
        label.textColor = .customBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Mona-Sans-Medium", size: 10)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let fullText = "By clicking, I accept the Terms & Conditions & Privacy Policy"
        let attributedString = NSMutableAttributedString(string: fullText)
        let fullFont = UIFont(name: "Mona-Sans-Medium", size: 20) ?? UIFont.systemFont(ofSize: 12)
        attributedString.addAttribute(.font, value: fullFont, range: NSRange(location: 0, length: fullText.count))
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 26, length: 18)) // "Terms & Conditions"
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 47, length: 14)) // "Privacy Policy"
        
        label.attributedText = attributedString
        return label
    }()
    
    @objc private func handleTapOnLabel(_ gesture: UITapGestureRecognizer) {
        let text = (bottomLabel.attributedText?.string ?? "") as NSString
        let termsRange = text.range(of: "Terms & Conditions")
        let policyRange = text.range(of: "Privacy Policy")
        
        let tapLocation = gesture.location(in: bottomLabel)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: bottomLabel.bounds.size)
        let textStorage = NSTextStorage(attributedString: bottomLabel.attributedText!)
        
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = bottomLabel.lineBreakMode
        textContainer.maximumNumberOfLines = bottomLabel.numberOfLines
        
        let characterIndex = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if NSLocationInRange(characterIndex, termsRange) {
            print("Terms tapped")
        } else if NSLocationInRange(characterIndex, policyRange) {
            print("Policy tapped")
        }
    }
    
    lazy var continueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .customBlack
        btn.setTitle("Continue", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 7
        btn.titleLabel?.tintColor = .white
        return btn
    }()
    
    func configureContinueAction(target: Any, action: Selector) {
        continueButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
//        view.backgroundColor = .white
       
        
        addSubviews(countryCodeButton, numberTextField, droneImg, titleLabel, subtitleLabel, placeholderLabel, dropdownTableView, bottomLabel, continueButton)
        setupUI()
        setupConstraints()
    
        countryCodeButton.addTarget(self, action: #selector(showCountryCodePicker), for: .touchUpInside)
        let maxWidth = countryCodes.map { "\($0.1) \($0.2)".size(withAttributes: [.font: UIFont.systemFont(ofSize: 17)]).width }.max() ?? 0
        let totalWidth = maxWidth + 50
        dropdownTableView.widthAnchor.constraint(equalToConstant: totalWidth).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:)))
        bottomLabel.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardHeight = keyboardSize.height
                let bottomPadding: CGFloat = -16
                
                // Поднимаем кнопку и bottomLabel
                bottomLabel.transform = CGAffineTransform(translationX: 0, y: -(keyboardHeight + bottomPadding - self.safeAreaInsets.bottom))
                continueButton.transform = CGAffineTransform(translationX: 0, y: -(keyboardHeight + bottomPadding - self.safeAreaInsets.bottom))
            }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        // Возвращаем кнопку и bottomLabel на место
        bottomLabel.transform = .identity
        continueButton.transform = .identity
    }
    
    private func setupUI() {
        // Кнопка для выбора кода страны
        let leftView = UIView()
        
        codeLabel.text = selectedCountryCode
        codeLabel.font = UIFont.systemFont(ofSize: 18)
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        leftView.addSubview(codeLabel)
        leftView.translatesAutoresizingMaskIntoConstraints = false
        codeLabel.leadingAnchor.constraint(equalTo: leftView.leadingAnchor, constant: 5).isActive = true
        codeLabel.centerYAnchor.constraint(equalTo: leftView.centerYAnchor).isActive = true
        leftView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        leftView.widthAnchor.constraint(equalToConstant: 33).isActive = true
        
        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
        dropdownTableView.isHidden = true
        dropdownTableView.layer.borderWidth = 1
        dropdownTableView.layer.borderColor = UIColor.systemGray6.cgColor
        dropdownTableView.layer.cornerRadius = 5
        dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
        dropdownTableView.separatorStyle = .none
        
        
        
        countryCodeButton.setTitle("\(countryCodes[0].1)", for: .normal)
        countryCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        countryCodeButton.setTitleColor(.black, for: .normal)
        countryCodeButton.translatesAutoresizingMaskIntoConstraints = false
        countryCodeButton.layer.borderWidth = 1
        countryCodeButton.layer.borderColor = UIColor.systemGray6.cgColor
        countryCodeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        countryCodeButton.layer.cornerRadius = 7
        
        
        // Поле для ввода номера
        numberTextField.borderStyle = .roundedRect
        numberTextField.placeholder = "0000 0000"
        numberTextField.translatesAutoresizingMaskIntoConstraints = false
        numberTextField.keyboardType = .phonePad
        numberTextField.leftView = leftView
        numberTextField.leftViewMode = .always

    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            droneImg.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            droneImg.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            droneImg.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: droneImg.bottomAnchor, constant: 10),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            placeholderLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50),
            
            countryCodeButton.trailingAnchor.constraint(equalTo: numberTextField.leadingAnchor, constant: -5),
            countryCodeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            countryCodeButton.topAnchor.constraint(equalTo: placeholderLabel.bottomAnchor, constant: 10),
            countryCodeButton.heightAnchor.constraint(equalToConstant: 44),

            numberTextField.topAnchor.constraint(equalTo: placeholderLabel.bottomAnchor, constant: 10),
            numberTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            numberTextField.heightAnchor.constraint(equalToConstant: 44),
            
            dropdownTableView.topAnchor.constraint(equalTo: countryCodeButton.bottomAnchor, constant: 5),
            dropdownTableView.leadingAnchor.constraint(equalTo: countryCodeButton.leadingAnchor),
//            dropdownTableView.trailingAnchor.constraint(equalTo: countryCodeButton.trailingAnchor),
            dropdownTableView.heightAnchor.constraint(equalToConstant: 150),
            
            bottomLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bottomLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            bottomLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40),
            
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            continueButton.bottomAnchor.constraint(equalTo: bottomLabel.topAnchor, constant: -10),
            continueButton.heightAnchor.constraint(equalToConstant: 44)
            

        ])
    }
    
    @objc private func showCountryCodePicker() {
        isDropdownVisible.toggle()
        dropdownTableView.isHidden = !isDropdownVisible
    }
}



extension LoginView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell") ?? UITableViewCell(style: .default, reuseIdentifier: "countryCell")

        
        let country = countryCodes[indexPath.row]
        cell.textLabel?.text = "\(country.1) \(country.2)" // Флаг и название страны
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry = countryCodes[indexPath.row]
        selectedCountryCode = selectedCountry.0 // Обновляем код страны
        countryCodeButton.setTitle(selectedCountry.1, for: .normal) // Обновляем флаг на кнопке
        
        if let leftView = numberTextField.leftView,
           let label = leftView.subviews.first(where: { $0 is UILabel }) as? UILabel {
            label.text = selectedCountryCode // Обновляем код в label внутри leftView
        }
    }
}


