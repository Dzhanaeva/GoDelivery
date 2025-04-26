//
//  RestaurantCollectionView.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 19.01.2025.
//

import UIKit

final class RestaurantsCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var restaurants: [Restaurant] = [] {
        didSet {
            print("Массив restaurants обновлён: \(restaurants)")
            reloadData()
        }
    }
    
    init() {
        let layout = RestaurantsCollectionView.createLayoutRest()
        print("Layout created: \(layout)")
        super.init(frame: .zero, collectionViewLayout: layout)
        setupCollectionView()
    }
    
    static func createLayoutRest() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),  // Ячейки занимают 60% ширины
            heightDimension: .fractionalHeight(1.0)  // Ячейки занимают 100% высоты
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 2.5),  // Группа занимает 100% ширины
            heightDimension: .fractionalHeight(1.0)  // Группа занимает 100% высоты
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        print("Group size: \(groupSize.widthDimension), \(groupSize.heightDimension)")  // Печать размеров группы
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous  // Горизонтальная прокрутка
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)  // Внешние отступы
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        self.dataSource = self
        self.delegate = self
        self.register(RestaurantCell.self, forCellWithReuseIdentifier: "restaurantCell")
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantCell", for: indexPath) as? RestaurantCell else {
            fatalError("Unable to dequeue RestaurantsCollectionViewCell")
        }
        cell.configure(with: restaurants[indexPath.row])
        return cell
    }
}

