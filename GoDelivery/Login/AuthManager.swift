//
//  AuthManager.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 16.10.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AuthManager {
    
    static let shared = AuthManager()
    private let auth = Auth.auth()
    
    private var verificationID: String?
    
    public func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationId, error in
            guard let verificationID = verificationId, error == nil else {
                completion(false)
                print(error?.localizedDescription)
                
                if let error = error {
                    let nsError = error as NSError
                    print("Error: \(nsError.localizedDescription)")
                    print("Error code: \(nsError.code)")
                    print("User Info: \(nsError.userInfo)")
                }
                return
            }
            
            self?.verificationID = verificationID
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            completion(true)
            
        }
    }
    
    public func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void) {
        guard let verificationID = verificationID ?? UserDefaults.standard.string(forKey: "authVerificationID") else {
            completion(false)
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: smsCode)
        
        auth.signIn(with: credential) { result, error in
            //            guard result != nil, error == nil else {
            //                completion(false)
            //                return
            if let error = error {
                let nsError = error as NSError
                print("Error: \(nsError.localizedDescription)")
                print("Error code: \(nsError.code)")
                print("User Info: \(nsError.userInfo)")
                completion(false)
                return
            }
            completion(true)
        }
        
        
        
    }
    
    
    func saveAddressToFirebase(_ address: Address, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not logged in"]))
            return
        }
        
        do {
            // Преобразуем адрес в словарь
            let addressData = try Firestore.Encoder().encode(address)
            
            // Сохраняем данные в коллекцию "users" -> "userID" -> "addresses"
            db.collection("users")
                .document(userID)
                .collection("addresses")
                .document("defaultAddress")
                .setData(addressData) { error in
                if let error = error {
                    print("Ошибка при сохранении адреса: \(error.localizedDescription)")
                    completion(error)
                } else {
                    print("Адрес успешно сохранён в Firebase!")
                    completion(nil)
                }
            }
        } catch {
            print("Ошибка кодирования адреса: \(error.localizedDescription)")
            completion(error)
        }
    }
    
}
