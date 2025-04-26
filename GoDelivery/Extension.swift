//
//  Extension.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 12.10.2024.
//


import UIKit

extension UIView {
    func addSubviews(_ views: UIView ...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
