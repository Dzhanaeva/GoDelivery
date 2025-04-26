//
//  TabBarController.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 05.11.2024.
//

import UIKit


class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        tabBar.tintColor = .customBlack
        tabBar.backgroundColor = .white
    }
    
    private func setupTabBar() {
        let homeVC = UINavigationController(rootViewController: HomeVC())
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home2"), selectedImage: UIImage(named: "home2Fill")?.withRenderingMode(.alwaysOriginal))
        homeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: 1, right: 0)
        
        let foodVC = UINavigationController(rootViewController: FoodVC())
        foodVC.tabBarItem = UITabBarItem(title: "Food", image: UIImage(named: "food"), selectedImage: UIImage(named: "foodFill")?.withRenderingMode(.alwaysOriginal))
        foodVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: 1, right: 0)
        
        let martVC = UINavigationController(rootViewController: MartVC())
        martVC.tabBarItem = UITabBarItem(title: "Mart", image: UIImage(named: "mart"), selectedImage: UIImage(named: "martFill")?.withRenderingMode(.alwaysOriginal))
        martVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: 1, right: 0)
        
        let dineInVC = UINavigationController(rootViewController: DineInVC())
        dineInVC.tabBarItem = UITabBarItem(title: "Dine In", image: UIImage(named: "dineIn"), selectedImage: UIImage(named: "dineInFill")?.withRenderingMode(.alwaysOriginal))
        dineInVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -1, right: 0)
        
        let courierVC = UINavigationController(rootViewController: CourierVC())
        courierVC.tabBarItem = UITabBarItem(title: "Courier", image: UIImage(named: "courier"), selectedImage: UIImage(named: "courierFill")?.withRenderingMode(.alwaysOriginal))
        courierVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -1, right: 0)
        
        viewControllers = [homeVC, foodVC, martVC, dineInVC, courierVC]
    }
}
