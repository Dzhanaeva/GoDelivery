//
//  HomeView.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 05.11.2024.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth
import CoreLocation
import FSPagerView

class HomeView: UIView, ServerDelegate, CarouselFSPagerViewDelegate, CLLocationManagerDelegate{

    private let locationManager = CLLocationManager()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 15
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
//        stack.alignment = .center
//        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var vStackTwo: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let deliveryLabel: UILabel = {
        let label = UILabel()
        label.text = "Deliver Now"
        label.textColor = .customGray
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    let placeLabel: UILabel = {
        let label = UILabel()
        label.text = "Place Name"
        label.font = UIFont(name: "Mona-Sans-Bold", size: 27)
        label.textColor = .customBlack
        return label
    }()
    
    lazy var profileImg: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "profile")
        image.heightAnchor.constraint(equalToConstant: 45).isActive = true
        image.widthAnchor.constraint(equalToConstant: 45).isActive = true
        return image
    }()
    
    lazy var searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search for food, grocery, meet etc."
        search.searchBarStyle = .minimal
        search.translatesAutoresizingMaskIntoConstraints = false
        search.layer.cornerRadius = 20
        return search
    }()
        


    private let categories: [Category] = [
        Category(title: "Food", subtitle: "25 mins", imageName: "foodImage"),
        Category(title: "Mart", subtitle: "20 mins", imageName: "martImage"),
        Category(title: "Courier", subtitle: "30 mins", imageName: "courierImage"),
        Category(title: "Dine in", subtitle: "No waiting", imageName: "dineInImage"),
        Category(title: "Gold Membership", subtitle: "Free delivery on all orders", imageName: "cardsImage")
    ]
    
    let carousel = [
        Carousel(oneTitle: "Get up to", twotitle: "25% off", threetitle: "on all food orders", image: UIImage(named: "foodCarousel")!, backgroundColor: .carouselColorOne),
        Carousel(oneTitle: "Get up to", twotitle: "25% off", threetitle: "on all food orders", image: UIImage(named: "foodCarousel")!, backgroundColor: .carouselColorTwo),
        Carousel(oneTitle: "Get up to", twotitle: "25% off", threetitle: "on all food orders", image: UIImage(named: "foodCarousel")!, backgroundColor: .carouselColorThree),
    ]
    
    
    var currentPage = 0
    
    
    private var restaurants: [Restaurant] = []
    
    lazy var categoriesCollectionView: CategoriesCollectionView = {
        let collectionView = CategoriesCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        return collectionView
    }()
    
    lazy var carouselPagerView: CarouselFSPagerView = {
        let pagerView = CarouselFSPagerView()
        pagerView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        pagerView.interitemSpacing = 15
        pagerView.automaticSlidingInterval = 10

        return pagerView
    }()
    
     var pageControl: FSPageControl = {
        let control = FSPageControl()
//        control.numberOfPages = carousel.count // Устанавливаем количество страниц
        control.translatesAutoresizingMaskIntoConstraints = false
        let selectedImage = UIImage(named: "selectedPager")
        let normalImage = UIImage(named: "normalPager")
         control.setImage(normalImage, for: .normal)
         control.setImage(selectedImage, for: .selected)
         control.itemSpacing = 10

         control.interitemSpacing = 18
//        control.currentPage = 0 // Устанавливаем начальную страницу
        control.contentHorizontalAlignment = .center
        return control
    }()
    
    var restaurantsCollectionView: RestaurantsCollectionView = {
        let collectionView = RestaurantsCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        return collectionView
    }()

    var dealsOnGroceryCollectionView: DealsOnGroceryCollectionView = {
        let collectionView = DealsOnGroceryCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        return collectionView
    }()
    
    let server = NearbyRestaurantsService()
    
    func didFetchRestaurants(_ restaurants: [Restaurant]) {
        // Обновляем данные коллекции
        DispatchQueue.main.async {
            self.restaurantsCollectionView.restaurants = restaurants
            self.restaurantsCollectionView.reloadData()
        }
    }
    
    var isDelegateSet = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        searchView.addSubview(searchBar)
        server.delegate = self
        containerView
            .addSubviews(
                hStack,
                vStack
            )
        vStackTwo.addArrangedSubview(deliveryLabel)
        vStackTwo.addArrangedSubview(placeLabel)
        vStackTwo.addArrangedSubview(searchView)
        
        hStack.addArrangedSubview(vStackTwo)
        hStack.addArrangedSubview(profileImg)
        

        
        vStack.addArrangedSubview(categoriesCollectionView)
        vStack.addArrangedSubview(carouselPagerView)
        vStack.addArrangedSubview(pageControl)
        vStack.addArrangedSubview(restaurantsCollectionView)
        vStack.addArrangedSubview(dealsOnGroceryCollectionView)
    
        
        carouselPagerView.carouselData = carousel
        JSONLoader.loadRestaurants { [weak self] restaurants in
            DispatchQueue.main.async {
                print("Загружено ресторанов: \(restaurants.count)") // 
                self?.restaurantsCollectionView.restaurants = restaurants
                self?.restaurantsCollectionView.reloadData()
            }
        }
        carouselPagerView.reloadData()
        categoriesCollectionView.categories = categories
        fetchPlaceName()
        setupConstraints()
        let firstIndexPath = IndexPath(item: 0, section: 0)
    
        
        carouselPagerView.carouselDelegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        fetchPlaceName()

        pageControl.numberOfPages = carousel.count
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded() // Обновляет лейаут перед вычислением высоты
        scrollView.contentSize = CGSize(width: frame.width, height: containerView.frame.height)
    }
    
    private func fetchPlaceName() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID).collection("addresses").document("defaultAddress")
        
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else if let document = document, document.exists {
                if let placeName = document.get("placeName") as? String {
                    self.placeLabel.text = placeName
                } else {
                    print("placeName not found in document")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        getPlaceName(from: location)
    }
    
    private func getPlaceName(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self, error == nil, let placemark = placemarks?.first else { return }
            let name = placemark.name ?? ""
            let city = placemark.locality ?? ""
            let placeName = name.isEmpty ? city : name
            DispatchQueue.main.async {
                self.placeLabel.text = placeName
            }
        }
    }
    
    func carouselDidScroll(to index: Int) {
        pageControl.currentPage = index
       }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
[
            // scrollView constraints
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor
                .constraint(
                    equalTo: safeAreaLayoutGuide.bottomAnchor
                ),
            
            // containerView constraints
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.bottomAnchor.constraint(equalTo: vStack.bottomAnchor),

            
            // hStack constraints
            hStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            hStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            hStack.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            // vStack constraints
            vStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            vStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            vStack.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 15),
        ]
)
    }
 
}
  
