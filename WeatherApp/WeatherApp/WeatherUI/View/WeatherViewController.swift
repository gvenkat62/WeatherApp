//
//  ViewController.swift
//  WeatherApp
//
//  Created by Venkat on 8/21/24.
//

import UIKit
import MapKit
import CoreLocation

class WeatherViewController: UIViewController {

    let viewModel: WeatherViewModel = WeatherViewModel(apiService: WeatherSerice(service: NetWorkService.shared))

    private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "City,State Code,Country Code"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.orange
        return searchController
    }()
    lazy var locationManager: CLLocationManager = {
           var locationManager = CLLocationManager()
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
           locationManager.activityType = . automotiveNavigation
           locationManager.distanceFilter = 10.0  // Movement threshold for new events
           return locationManager
       }()
    var latitude: Double = 0.0
    var longitude: Double = 0.0

    var tableview:UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UserTableViewCell.self, forCellReuseIdentifier: "cell")
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 200
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data:WeatherData =             NetWorkService.shared.fetchDataFormUserDefaults(){
            self.viewModel.weatherData.value = data
        }
        self.determineMyCurrentLocation()
        self.setupUI()
    }

    
    func setupUI(){
        tableview.dataSource = self
        tableview.delegate = self
        searchController.searchBar.delegate = self
        self.view.addSubview(tableview)
        tableview.tableHeaderView = searchController.searchBar

        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableview.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableview.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        self.viewModel.weatherData.observe(on: self) { [weak self] data in
            if let data = data{
                
                NetWorkService.shared.storeDataUserDefaults(data: data)
                DispatchQueue.main.async {
                    self?.tableview.reloadData()
                }
            }
            
        }
        
        var item = UIBarButtonItem(image: UIImage(named: "currentlocation.png"), style: .plain, target: self, action: #selector(GetCurrentlocation))
        self.navigationItem.rightBarButtonItem = item
        
        
    }
    
    @objc func GetCurrentlocation(){
        self.searchLocationByLatLong(lat: "\(latitude)", long: "\(longitude)")
    }
    
    func searchLocationByLatLong(lat:String, long:String){
        Task {
            await self.viewModel.serviceCallForcastLotLong(lat:lat,long:long)
        }
        
    }
    
    func searchLocationByCity(adderss:String){
        Task {
            await self.viewModel.serviceCallForcastCity(address:adderss)
        }
        
    }
    

}

extension WeatherViewController:UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        cell.titleLable.text = "No location found"
        if let data = self.viewModel.weatherData.value{
            cell.bindData(user: data)
        }
        return cell
        
    }
    
    
    
}

extension WeatherViewController: UISearchBarDelegate,UISearchResultsUpdating {
    
    func filterContentForSearchText(_ searchText: String) {
       // searchController.queryFragment = searchText
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
            //searchResultsTable.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        if let text = searchBar.text, !text.isEmpty{
            let stringArray = text.components(separatedBy: ",")
            
            var addressString = ""
            if stringArray.count > 0  {
                addressString = stringArray[0]
            }
            if stringArray.count>1  {
                addressString += ","+stringArray[1]

            }
            if stringArray.count > 2{
                addressString += ","+stringArray[2]
            }
            
            self.searchLocationByCity(adderss: addressString)
          
        }
    }
}


extension WeatherViewController:CLLocationManagerDelegate {
    
    func determineMyCurrentLocation() {
        
       
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

//        DispatchQueue.global().async {
//            
//            if CLLocationManager.locationServicesEnabled()
//            {
//                let authorizationStatus = CLLocationManager.authorizationStatus()
//                if (authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways) || authorizationStatus == .authorized
//                {
//                    self.locationManager.startUpdatingLocation()
//                }
//                else if (self.locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)))
//                {
//                    self.locationManager.requestAlwaysAuthorization()
//                }
//                else
//                {
//                    self.locationManager.startUpdatingLocation()
//                }
//            }
//        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
        {
            print("Error while requesting new coordinates")
        }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        self.latitude = locations[0].coordinate.latitude
        self.longitude = locations[0].coordinate.longitude
        self.searchLocationByLatLong(lat: "\(latitude)", long: "\(longitude)")
        
    }
    
}


