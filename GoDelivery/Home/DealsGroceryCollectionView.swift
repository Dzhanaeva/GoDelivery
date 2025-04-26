//
//  DealsGroceryCollectionView.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 23.02.2025.
//

import UIKit

class DealsOnGroceryCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var deals: [Deal] = [] {
        didSet {
//            print("Массив deals обновлён: \(deals)")
            reloadData()
        }
    }
    
    init() {
        let layout = DealsOnGroceryCollectionView.createLayout()
        print("Layout created: \(layout)")
        super.init(frame: .zero, collectionViewLayout: layout)
        setupCollectionView()
        loadMockDeals()
    }
    
    private func loadMockDeals() {
        self.deals = [
            Deal(image: "food2", title: "Fresh Apples", price: "$2.99", gram: 500),
            Deal(image: "food2", title: "Bananas", price: "$1.49", gram: 1000),
            Deal(image: "food2", title: "Organic Milk", price: "$3.99", gram: 1000),
            Deal(image: "food2", title: "Whole Wheat Bread", price: "$2.49", gram: 400),
            Deal(image: "food2", title: "Cheddar Cheese", price: "$5.99", gram: 200)
        ]
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 2.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        print("Group size: \(groupSize.widthDimension), \(groupSize.heightDimension)")
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        self.dataSource = self
        self.delegate = self
        self.register(DealsGroceryCell.self, forCellWithReuseIdentifier: "dealCell")
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dealCell", for: indexPath) as? DealsGroceryCell else {
            fatalError("Unable to dequeue DealCell")
        }
        cell.configure(with: deals[indexPath.row])
        return cell
    }
    
}
