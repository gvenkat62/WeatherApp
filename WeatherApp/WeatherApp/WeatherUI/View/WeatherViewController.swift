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
        searchController.searchBar.placeholder = "City, State Code, Country Code"
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
    var latitude: Double = 32.92356599447725
    var longitude: Double = -96.38737971865447

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
        
        if let data:WeatherData = NetWorkService.shared.fetchDataFormUserDefaults(){
            self.viewModel.weatherData.value = data
        }
        locationManager.requestWhenInUseAuthorization()
        self.setupUI()
    }

    
    func setupUI(){
        tableview.dataSource = self
        tableview.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = true
        let attributes:[NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)

        self.view.addSubview(tableview)
        tableview.tableHeaderView = searchController.searchBar
        self.tableview.backgroundColor = .systemBlue
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
            else{
                DispatchQueue.main.async {
                    self?.tableview.reloadData()
                }
            }
            
        }
        let item = UIBarButtonItem(image: UIImage(named: "currentlocation.png"), style: .plain, target: self, action: #selector(GetCurrentlocation))
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
        cell.titleLable.text = "No data found"
        if let data = self.viewModel.weatherData.value{
            cell.contentView.subviews.forEach { view in
                view.isHidden = false
            }
            cell.titleLable.textAlignment = .left

            cell.bindData(user: data)
        }else{
            cell.contentView.subviews.forEach { view in
                view.isHidden = true
            }
            cell.leftStackView.isHidden = false
            cell.dateLabel.isHidden = true
            cell.temperatureLabel.isHidden = true
            cell.humidLabel.isHidden = true
            cell.titleLable.isHidden = false
            cell.titleLable.textAlignment = .center
        }
        return cell
    }
}

extension WeatherViewController: UISearchBarDelegate,UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
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
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        if let clErr = error as? CLError {
            switch clErr.code {
            case CLError.locationUnknown:
                print("location unknown")
            case CLError.denied:
                print("denied")
            default:
                print("other Core Location error")
            }
        } else {
            print("other error:", error.localizedDescription)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        print("location \n Latitude : \(locations[0].coordinate.latitude) \n longitude : \(locations[0].coordinate.longitude)")
        self.latitude = locations[0].coordinate.latitude
        self.longitude = locations[0].coordinate.longitude
        self.searchLocationByLatLong(lat: "\(latitude)", long: "\(longitude)")
    }
}


