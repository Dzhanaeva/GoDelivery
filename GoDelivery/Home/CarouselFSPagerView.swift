//
//  CarouselFSPagerView.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 19.01.2025.
//

import UIKit
import FSPagerView

protocol CarouselFSPagerViewDelegate: AnyObject {
    func carouselDidScroll(to index: Int)
}

final class CarouselFSPagerView: FSPagerView, FSPagerViewDataSource, FSPagerViewDelegate {
    
    weak var carouselDelegate: CarouselFSPagerViewDelegate?
    
    var carouselData: [Carousel] = []
    
    
    
    init() {
//        let layout = CarouselCollectionView.createLayout()
        super.init(frame: .zero)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        self.dataSource = self
        self.delegate = self
//        self.isPagingEnabled = true
        self.isInfinite = true
        self.register(CarouselFSPagerViewCell.self, forCellWithReuseIdentifier: "carouselCell")
        self.translatesAutoresizingMaskIntoConstraints = false

//        DispatchQueue.main.async {
//            self.reloadData()
//        }
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return carouselData.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(
            withReuseIdentifier: "carouselCell",
            at: index
        ) as? CarouselFSPagerViewCell else {
            return FSPagerViewCell()
        }
        cell.configure(with: carouselData[index])
        return cell
    }
    
//    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        print("Выбран элемент: \(index)")
//        HomeView.shared.pageControl.currentPage = index
//    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        let currentIndex = pagerView.currentIndex

        carouselDelegate?.carouselDidScroll(to: currentIndex) // ✅ Вызываем делегат
    }

//
//     static func createLayout() -> UICollectionViewCompositionalLayout {
//                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.9))
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0)
//         let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalHeight(0.9))
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//                let section = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .paging
//                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
//        
//                return UICollectionViewCompositionalLayout(section: section)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return carouselData.count
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouselCell", for: indexPath) as? CarouselCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        cell.configure(with: carouselData[indexPath.row])
//        return cell
//    }
}
