//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Venkat on 8/21/24.
//

import Foundation
import UIKit

protocol WeatherSericeProtocol {
    func getCurrentWeatherDataByLatLong(lat: String, long: String) async-> Result<WeatherData, postError> 
    func getCurrentWeatherDataByCity(address: String) async-> Result<WeatherData, postError>
    func getImage(url: String) async-> Result<UIImage, postError>
}

class WeatherSerice {
    
    let service:NetWorkService
    
    init(service:NetWorkService)
    {
        self.service = service
    }
}

extension WeatherSerice: WeatherSericeProtocol{
    
    func getCurrentWeatherDataByLatLong(lat: String, long: String) async-> Result<WeatherData, postError> {
        
        var params  = Dictionary<String, Any>()
        params["lat"] = lat
        params["lon"] = long
        params["appid"] = WetaherEndpoint.appkey.rawValue
        params["units"] = "imperial"

        let url = URL(string: APIConstants.API_URL)!

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)

        let queryItems = params.map{
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        urlComponents?.queryItems = queryItems
        
        return await self.service.getApiRequestasync(url: urlComponents?.url, Params: "", type: WeatherData.self)
    }
    
    func getCurrentWeatherDataByCity(address: String) async-> Result<WeatherData, postError> {
        
        var params  = Dictionary<String, Any>()
        params["q"] = address
        params["appid"] = WetaherEndpoint.appkey.rawValue
        params["units"] = "imperial"

        let url = URL(string: APIConstants.API_URL)!

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)

        let queryItems = params.map{
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        urlComponents?.queryItems = queryItems
        
        return await self.service.getApiRequestasync(url: urlComponents?.url, Params: "", type: WeatherData.self)
    }
    
    func getImage(url: String) async-> Result<UIImage, postError>{
        
        return await self.service.getImage(url: URL(string: url))
    }

    
    
}
