//
//  LoginModel.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 15.10.2024.
//

import FirebaseAuth

class LoginModel {
    func verifyPhoneNumber(_ phoneNumber: String, completion: @escaping (Bool) -> Void ) {
        PhoneAuthProvider
            .provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) {
                verificationId, err in
                if let err = err {
                    print("error \(err.localizedDescription)")
                    completion(false)
                } else {
                    UserDefaults.standard.set(verificationId, forKey: "authVerificationID")
                    completion(true)
                }
            }
    }
}
