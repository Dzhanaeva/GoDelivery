//
//  OnboardingVC.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 12.10.2024.
//

import UIKit

class OnboardingVC: UIViewController {
    
    let slides = [
        OnboardingSlideModel(title: "Food delivery at door step", description: "Get yummy dellicious food at your service in within less time", imageName: ""),
        OnboardingSlideModel(title: "Grocery & Essentials Delivery", description: "Get yummy dellicious food at your service in within less time", imageName: ""),
        OnboardingSlideModel(title: "Dine In in fine resturants", description: "Get yummy dellicious food at your service in within less time", imageName: ""),
        OnboardingSlideModel(title: "Get any packages delivered", description: "Get yummy dellicious food at your service in within less time", imageName: "")]
    
    lazy var collectionSlider: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(OnboardingCell.self, forCellWithReuseIdentifier: "cell")
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isPagingEnabled = true
        collection.contentInsetAdjustmentBehavior = .never
        return collection
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews(collectionSlider)
        setupConstraint()
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate([
            collectionSlider.topAnchor.constraint(equalTo: view.topAnchor),
            collectionSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionSlider.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
    }


}


extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OnboardingCell
        let slide = slides[indexPath.item]
        cell.titleLabel.text = slide.title
        cell.desLabel.text = slide.description
        cell.image.image = UIImage(named: slide.imageName)
        
        if indexPath.item == slides.count - 1 {
            cell.nextBtn.setTitle("Get Started", for: .normal)
        } else {
            cell.nextBtn.setTitle("Next", for: .normal)
        }
        
        cell.onNextButtonTapped = {
            if indexPath.item == self.slides.count - 1 {
                let logVC = LoginVC()
                self.navigationController?.pushViewController(logVC, animated: true)
            } else {
                let nextIndex = IndexPath(item: indexPath.item + 1, section: indexPath.section)
                collectionView.scrollToItem(at: nextIndex, at: .centeredVertically, animated: true)
            }
        }
        return cell
    }
    
    
}

