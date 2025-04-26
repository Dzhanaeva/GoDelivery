//
//  VerificationModel.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 15.10.2024.
//

import Foundation

class VerificationModel {
    var verificationCode: String = ""
    
    func isValid() -> Bool {
        return verificationCode.count == 6
    }
}
