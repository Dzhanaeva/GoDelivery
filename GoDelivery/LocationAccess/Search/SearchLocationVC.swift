//
//  SearchLocationVC.swift
//  GoDelivery
//
//  Created by Гидаят Джанаева on 17.10.2024.
//


import UIKit
import MapKit

protocol SearchLocationVCDelegate: AnyObject {
//    func didSelectAddress(_ address: String, location: CLLocation)
    func didSelectLocation(location: CLLocationCoordinate2D, placeName: String, streetName: String)
    func useCurrentLocationRequested() 
}


class SearchLocationVC: UIViewController, UISearchBarDelegate {
    weak var delegate: SearchLocationVCDelegate?
    lazy var tableView = UITableView()
    //    private let searchController = UISearchController(searchResultsController: nil)
    lazy var searchBar = UISearchBar()
    private let locationSearchCompleter = MKLocalSearchCompleter() // Используем это свойство
    private var completions: [MKLocalSearchCompletion] = []
    
    lazy var savedResultsTableView = UITableView()
    
    
    
    var recentSearches: [SearchItem] = [] // Недавние запросы
    var savedAddresses: [SearchItem] = [ // Пример сохранённых адресов
        SearchItem(title: "Office", subtitle: "Гамидова 89/1, Избербаш"),
        SearchItem(title: "Home", subtitle: "Шоссейная 60а, Избербаш")
    ]
    
    let header: UILabel = {
        let label = UILabel()
        label.text = "Search for a location"
        label.textAlignment = .center
        label.textColor = .customBlack
        label.font = UIFont(name: "Mona-Sans-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        loadRecentSearchesFromUserDefaults()
//        tableView.isHidden = true
        setupTableView()
        setupSearchBar()
        setupSavedResultsTableView()
        setupConstraints()
        
        locationSearchCompleter.delegate = self
        locationSearchCompleter.resultTypes = [.address, .pointOfInterest]
   
    }
    

    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search for a location"
        searchBar.searchBarStyle = .minimal
        view.addSubview(searchBar)
    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        //        view.addSubview(searchController.searchBar)
        view.addSubview(header)
        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            header.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            
            searchBar.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            savedResultsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 15),
            savedResultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            savedResultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            savedResultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        
        
    }

    private func setupSavedResultsTableView() {
        view.addSubview(savedResultsTableView)
        savedResultsTableView.translatesAutoresizingMaskIntoConstraints = false
        savedResultsTableView.separatorStyle = .none
        savedResultsTableView.delegate = self
        savedResultsTableView.dataSource = self
        savedResultsTableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
//        recentSearches.removeAll()
//        
//        // Сохранить изменения в UserDefaults
//        saveRecentSearchesToUserDefaults()
        
    }
    
    
    private func setupTableView() {
        view.addSubview(tableView)
        //        tableView.frame = view.bounds
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
    }
    
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //        locationSearchCompleter.queryFragment = searchText
    ////        print("Query fragment updated:", searchText) // Проверка ввода текста
    //    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        locationSearchCompleter.queryFragment = searchText
        if searchText.isEmpty {
            tableView.isHidden = true
            savedResultsTableView.isHidden = false
        } else {
            tableView.isHidden = false
            savedResultsTableView.isHidden = true
            // Здесь выполняется поиск и обновляется массив completions
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension SearchLocationVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == savedResultsTableView {
            return 3
        } else {
            return 1
        }    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == savedResultsTableView {
            switch section {
            case 0:
                return 1 // Текущая локация
            case 1:
                return recentSearches.count
            case 2:
                return savedAddresses.count // Сохраненные адреса
            default:
                return 0
            }
        } else {
            return completions.count // Результаты поиска
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == savedResultsTableView {
            switch section {
            case 1:
                return "Recent Searches"
            case 2:
                return "Saved Addresses"
            default:
                return nil
            }
        
        }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == savedResultsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell

            switch indexPath.section {
            case 0:
                cell.textLabel?.text = "Use Current Location"
                cell.imageView?.image = UIImage(named: "currentLocation")
                cell.detailTextLabel?.text = nil
            case 1:
                let recentSearch = recentSearches[indexPath.row]
                cell.configure(with: recentSearch.title, subtitle: recentSearch.subtitle, icon: UIImage(named: "recent"))
            case 2:
                let savedAddress = savedAddresses[indexPath.row]
                
                let iconName: String
                switch savedAddress.title {
                case "Office":
                    iconName = "office" // Имя иконки для офиса
                case "Home":
                    iconName = "home" // Имя иконки для дома
                default:
                    iconName = "defaultIcon" // Имя иконки по умолчанию
                }
                
                cell.configure(with: savedAddress.title, subtitle: savedAddress.subtitle, icon: UIImage(named: iconName))
            default:
                break
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
            let completion = completions[indexPath.row]
            cell.configure(with: completion.title, subtitle: completion.subtitle, icon: UIImage(named: "location"))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == savedResultsTableView {
            switch indexPath.section {
                 case 0:
                delegate?.useCurrentLocationRequested()

                 case 1:
                     let recentSearch = recentSearches[indexPath.row]
                     searchForLocation(address: recentSearch.title)
                 case 2:
                     let savedAddress = savedAddresses[indexPath.row]
                searchForLocation(address: savedAddress.subtitle)
                 default:
                     break
                 }
        } else {
            let completion = completions[indexPath.row]
            saveRecentSearch(completion.title, subtitle: completion.subtitle)
            searchForLocation(address: completion.title)
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == savedResultsTableView {
            let footerView = UIView()
            footerView.backgroundColor = .clear // Прозрачный фон для расстояния между секциями
            
            // Сепаратор внутри footerView
            let separatorView = UIView()
            separatorView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            footerView.addSubview(separatorView)
            
            NSLayoutConstraint.activate([
                separatorView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 15),
                separatorView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -15),
                separatorView.heightAnchor.constraint(equalToConstant: 1),
                separatorView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20)
            ])
            
            return footerView
        }
        
        return nil
    }
    
    func searchForLocation(address: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = address

        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] response, error in
            if let error = error {
                print("Error searching for location: \(error.localizedDescription)")
                return
            }

            guard let mapItem = response?.mapItems.first, let location = mapItem.placemark.location else { return }

            let mapVC = CurrentLocationMapVC()
//            let mapVCnav = UINavigationController(rootViewController: mapVC)
            mapVC.location = location

            if let name = mapItem.name {
                mapVC.placeNameLabel.text = name
 
                mapVC.streetNameLabel.text = "\(mapItem.placemark.thoroughfare ?? ""), \(mapItem.placemark.subThoroughfare ?? ""), \(mapItem.placemark.locality ?? ""), \(mapItem.placemark.postalCode ?? "")"
            } else {
                mapVC.placeNameLabel.text = mapItem.placemark.title
                mapVC.streetNameLabel.text =  "\(mapItem.placemark.administrativeArea ?? ""), \(mapItem.placemark.locality ?? ""),)"
            }

            self?.delegate?.didSelectLocation(location: mapItem.placemark.coordinate, placeName: mapItem.name ?? "", streetName: " \(mapItem.placemark.subThoroughfare ?? ""), \(mapItem.placemark.locality ?? ""), \(mapItem.placemark.postalCode ?? "")")

            // Закрываем текущий контроллер
            self?.dismiss(animated: true, completion: nil)

        }
    }
}

// MARK: - UISearchResultsUpdating
extension SearchLocationVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            completions.removeAll()
            tableView.reloadData()
            return
        }

        locationSearchCompleter.queryFragment = searchText
    }

}

// MARK: - MKLocalSearchCompleterDelegate
extension SearchLocationVC: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results
        tableView.reloadData()
    }
}
extension SearchLocationVC {
    func saveRecentSearchesToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(recentSearches) {
            UserDefaults.standard.set(encoded, forKey: "RecentSearches")
        }
    }

    func loadRecentSearchesFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "RecentSearches") {
            let decoder = JSONDecoder()
            if let loadedSearches = try? decoder.decode([SearchItem].self, from: savedData) {
                recentSearches = loadedSearches
            }
        }
    }
    
    func saveRecentSearch(_ title: String, subtitle: String) {
        let newSearch = SearchItem(title: title, subtitle: subtitle)
        recentSearches.insert(newSearch, at: 0)
        
        if recentSearches.count > 10 {
            recentSearches.removeLast() // Ограничиваем количество запросов до 10
        }
        
        saveRecentSearchesToUserDefaults()
        savedResultsTableView.reloadData()
    }
}


struct SearchItem: Codable {
    let title: String
    let subtitle: String
}
