//
//  ListTableViewController.swift
//  GoodWeather
//
//  Created by Игорь Павличенков on 15.12.2021.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    let weatherManager = WeatherManager()
    
    var citiesArray = [Weather(name: "Москва"), Weather(name: "Сочи")]
    var filterCityArray = [Weather]()
    
    let searchController = UISearchController(searchResultsController:  nil)
    
    var searchBarIsEmpty: Bool {
        
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCities()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        setupButton()
        
    }
    
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        alertAddCity(name: "Город", placeholder: "Введите название города") { (city) in
            
            self.weatherManager.getCityWeather(name: city) { [self] weather, error in
                
                guard let weather = weather else {
                    
                    let alert = UIAlertController(title: "Ошибка", message: "Такого города не существует. Попробуйте еще раз.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ОК", style: .default, handler: nil)
                    
                    alert.addAction(action)
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    return
                }
                
                
                if  !self.citiesArray.map({ $0.name.lowercased() }).contains(city.lowercased()) {
                
                    self.citiesArray.append(weather)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                } else {
                    
                    let alert = UIAlertController(title: "Ошибка", message: "Такой город уже добавлен. Попробуйте еще раз.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ОК", style: .default, handler: nil)
                    
                    alert.addAction(action)
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    return
                }
            }
        }
    }
    
    private func setupButton() {
        
        let nameAscendingSortItem = UIAction(title: "Сортировать по названию города (А-Я)") { (action) in
            
            self.citiesArray = self.citiesArray.sorted { weather1, weather2 in
                return weather1.name < weather2.name
            }
            
            self.tableView.reloadData()
            
        }
        
        let nameDescendingSortItem = UIAction(title: "Сортировать по названию города (Я-А)") { (action) in
            
            self.citiesArray = self.citiesArray.sorted { weather1, weather2 in
                return weather1.name > weather2.name
            }
            
            self.tableView.reloadData()
            
        }
        
        let tempAscendingSortItem = UIAction(title: "Сортировать по возрастанию температуры") { (action) in
            
            self.citiesArray = self.citiesArray.sorted { weather1, weather2 in
                return weather1.temperature < weather2.temperature
            }
            
            self.tableView.reloadData()
            
        }
        
        let tempDescendingSortItem = UIAction(title: "Сортировать по убыванию температуры") { (action) in
            
            self.citiesArray = self.citiesArray.sorted { weather1, weather2 in
                return weather1.temperature > weather2.temperature
            }
            
            self.tableView.reloadData()
            
        }
        
        let menu = UIMenu(title: "Выберите сортировку", options: .displayInline, children: [nameAscendingSortItem , nameDescendingSortItem, tempAscendingSortItem, tempDescendingSortItem])
        
        let navItems = [UIBarButtonItem(title: "⇅", menu: menu)]
        
        self.navigationItem.leftBarButtonItems = navItems
        
    }
    
    func addCities() {
        
        for city in citiesArray.enumerated() {
            
            weatherManager.getCityWeather(name: city.element.name) { weather, error in
               
                self.citiesArray[city.offset] = weather!
                
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [IndexPath(row: city.offset, section: 0)], with: .fade)
                }
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filterCityArray.count
        }
        
        return citiesArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        var weather = Weather()
        
        if isFiltering {
            weather = filterCityArray[indexPath.row]
        } else {
            weather = citiesArray[indexPath.row]
        }
        
        cell.configure(weather: weather)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [self] _, _, completionHandler in
            
            let editingRow = self.citiesArray[indexPath.row].name
            
            if let index = self.citiesArray.map{$0.name}.firstIndex(of: editingRow) {
                
                if self.isFiltering {
                    
                    let removeCity = filterCityArray[index]
                    self.filterCityArray.remove(at: index)
                    
                    let deletedIndex = self.citiesArray.firstIndex { city in
                        return city.name == removeCity.name
                    }
                    if let deletedIndex = deletedIndex {
                        self.citiesArray.remove(at: deletedIndex)
                    }
                    
                } else {
                    
                    self.citiesArray.remove(at: index)
                }
            }
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            if isFiltering {
                let filter = filterCityArray[indexPath.row]
                let destination = segue.destination as! DetailViewController
                destination.weatherModel = filter
            } else {
                let cityWeather = citiesArray[indexPath.row]
                let destination = segue.destination as! DetailViewController
                destination.weatherModel = cityWeather
            }
        }
    }
}

extension ListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filterCityArray = citiesArray.filter {
            $0.name.contains(searchText)
        }
        
        tableView.reloadData()
        
    }
    
}
