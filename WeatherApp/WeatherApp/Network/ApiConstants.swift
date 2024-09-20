//
//  ApiConstants.swift
//  WeatherApp
//
//  Created by Venkat on 8/21/24.
//

import Foundation

class APIConstants {

    //MARK: - General URLs
    // Server url
    static var API_URL: String {
            return "https://api.openweathermap.org/data/2.5/weather"
    }
}

enum WetaherEndpoint: String {
    case appkey = "5ddc7e61b82f3b9470a277291f6329ec"
    case getImageUrl = "https://openweathermap.org/img/wn/"
    case getPngExtension = "@2x.png"
}
