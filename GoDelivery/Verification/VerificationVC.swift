//
//  VerificationVC.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 15.10.2024.
//

import UIKit
import FirebaseAuth

class VerificationVC: UIViewController {
    let model = VerificationModel()
    let viewVerify = VerificaionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(viewVerify)
        viewVerify.frame = view.bounds
        
        viewVerify.verifyBtn.addTarget(self, action: #selector(verifyCodeTapped), for: .touchUpInside)
        
        for textField in viewVerify.otpTextFields {
            textField.addTarget(self, action: #selector(otpTextEditing), for: .editingChanged)
        }
    }
    
    @objc private func otpTextEditing(_ textField: UITextField) {
        let index = viewVerify.otpTextFields.firstIndex(of: textField)!
        model.verificationCode += textField.text ?? ""
        
        if index < viewVerify.otpTextFields.count - 1 && textField.text?.count == 1 {
            viewVerify.otpTextFields[index + 1].becomeFirstResponder()
        }
    }
    
    
    @objc private func verifyCodeTapped() {
        AuthManager.shared.verifyCode(smsCode: model.verificationCode) { success in
            if success {
                print("User authenticated")
                self.navigationController?.pushViewController(HomeVC(), animated: true)
            } else {
                self.showAlert(message: "Invalid verification code")
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
