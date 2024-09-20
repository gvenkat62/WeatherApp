//
//  WetherViewModel.swift
//  WeatherApp
//
//  Created by Venkat on 8/21/24.
//

import Foundation
class WeatherViewModel {
    
    let apiService: WeatherSericeProtocol
    var weatherData: Observable<WeatherData?> = Observable(nil)
    
    init(apiService:WeatherSericeProtocol) {
        self.apiService = apiService
    }
    
    func serviceCallForcastLotLong(lat:String, long:String) async{
        
        let result = await apiService.getCurrentWeatherDataByLatLong(lat: lat, long: long)
        switch result{
        case .success(let data):
            self.weatherData.value = data
        case .failure(let error):
            self.weatherData.value = nil
            print(error)
        }
    }
    
    func serviceCallForcastCity(address:String) async{
        
        let result = await apiService.getCurrentWeatherDataByCity(address: address)
        switch result{
        case .success(let data):
            self.weatherData.value = data
        case .failure(let error):
            self.weatherData.value = nil
            print(error)
        }
    }
}
