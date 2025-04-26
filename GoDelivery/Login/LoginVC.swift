//
//  LoginVC.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 13.10.2024.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
 
    private let loginView = LoginView()
    private let loginModel = LoginModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        setupLoginView()
    }
    
    private func setupLoginView() {
        view.addSubview(loginView)
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginView.topAnchor.constraint(equalTo: view.topAnchor),
            loginView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        
        loginView.configureContinueAction(target: self, action: #selector(continueBtnTapped))
    }
    
//    @objc func continueBtnTapped() {
//        guard let phoneNumber = loginView.numberTextField.text else {return}
//        let fullPhoneNumber = loginView.selectedCountryCode + phoneNumber.trimmingCharacters(in: .whitespaces)
//        print("Введенный номер: \(fullPhoneNumber)")
//        loginModel.verifyPhoneNumber(fullPhoneNumber) { success in
//            if success {
//                DispatchQueue.main.async {
//                    print("norm")
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.showAlert(message: "invalid phone number")
//                }
//            }
//        }
//    }
    
    private func goToVerificationScreen() {
        let verificationVC = VerificationVC() // Твой VC для ввода кода
        navigationController?.pushViewController(verificationVC, animated: true)
    }
    
    @objc func continueBtnTapped() {
        guard let phoneNumber = loginView.numberTextField.text else { return }
        let fullPhoneNumber = loginView.selectedCountryCode + phoneNumber.trimmingCharacters(in: .whitespaces)
        print("Введенный номер: \(fullPhoneNumber)")
        // Отправляем код верификации
//                PhoneAuthProvider.provider().verifyPhoneNumber(fullPhoneNumber, uiDelegate: nil) { verificationID, error in
//                    if let error = error {
//                        print(error.localizedDescription)
//                        self.showAlert(message: "Error: \(error.localizedDescription)")
//                        return
//                    }
//                    // Сохраняем verificationID для дальнейшей верификации
//                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
//                    self.goToVerificationScreen()
//                }
        
        AuthManager.shared.startAuth(phoneNumber: fullPhoneNumber) { success in
            if success {
                self.goToVerificationScreen()
            } else {
                self.showAlert(message: "Verification failed")
            }
        }

    }
    
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

