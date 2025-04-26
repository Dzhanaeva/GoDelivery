//
//  CategoriesCollectionView.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 19.01.2025.
//

import UIKit

final class CategoriesCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var categories: [Category] = [] {
        didSet {
            reloadData()
        }
    }
    
    init() {
        let layout = CategoriesCollectionView.createLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        self.dataSource = self
        self.delegate = self
        self.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
        self.translatesAutoresizingMaskIntoConstraints = false
        self.scrollsToTop = false
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            
            let topItem = NSCollectionLayoutItem(layoutSize: itemSize)
            topItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let topGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0 / 3))
            let topGroup = NSCollectionLayoutGroup.horizontal(layoutSize: topGroupSize, subitem: topItem, count: 3)
            
            let bottomLargeItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 3.0), heightDimension: .fractionalHeight(1.0)))
            bottomLargeItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let bottomSmallItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2.0 / 3.0), heightDimension: .fractionalHeight(1.0)))
            bottomSmallItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let bottomGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0 / 3))
            let bottomGroup = NSCollectionLayoutGroup.horizontal(layoutSize: bottomGroupSize, subitems: [bottomLargeItem, bottomSmallItem])
            
            let section = NSCollectionLayoutSection(group: NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(5.0 / 3.0)), subitems: [topGroup, bottomGroup]))
            
            return section
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoriesCollectionViewCell else {
            fatalError("Unable to dequeue CategoriesCollectionViewCell")
        }
        cell.configure(with: categories[indexPath.row])
        return cell
    }
}
