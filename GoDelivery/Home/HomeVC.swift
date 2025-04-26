//
//  HomeVc.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 16.10.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeVC: UIViewController {
    
    let homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func loadView() {
        super.loadView()
        view = homeView
    }
    
    

    
}
