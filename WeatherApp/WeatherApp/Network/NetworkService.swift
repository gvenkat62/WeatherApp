//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Venkat on 8/21/24.
//

import Foundation
import UIKit


enum postError:Error{
    case requestError
    case responseError
    case parseError
    case unknownError
}

class NetWorkService{
    
    static let shared = NetWorkService()
    
    func getApiRequestasync<T:Decodable> (url:URL?, Params:String, type:T.Type) async -> Result<T, postError> {
        
        guard let url = url else{
            return .failure(.requestError)
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            let parsedData = try JSONDecoder().decode(type.self, from: data)
            print(parsedData)
            return .success(parsedData)
        }
        catch {
            return .failure(.parseError)
        }
    }
    
    func postApiRequestasync<T:Decodable> (url:String, Params:String, body:AnyObject? = nil, type:T.Type) async -> Result<T, postError> {
        
        guard let url = URL(string: url) else{
            return .failure(.requestError)
        }
        
        do{
            let (data, _) = try await URLSession.shared.upload(for: URLRequest(url: url), from: body as! Data)
            let parsedData = try JSONDecoder().decode(type.self, from: data)
            return .success(parsedData)
        }
        catch {
            return .failure(.parseError)
        }
    }
    
    func getImage(url: URL?) async-> Result<UIImage, postError> {
        
        guard let url = url else{
            return .failure(.requestError)
        }
        
        if let cachedImage = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
            print("Image from cache")
            return .success(cachedImage)
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return .failure(.parseError) }
            ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString)
            return .success(image)
        }
        catch {
            return .failure(.parseError)
        }
    }
    
    func storeDataUserDefaults(data:WeatherData){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            UserDefaults.standard.set(encoded, forKey: "SavedPerson")
        }
    }
    
    func fetchDataFormUserDefaults()->WeatherData?
    {
        if let savedData = UserDefaults.standard.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(WeatherData.self, from: savedData) {
                return loadedData
            }
        }
        return nil
    }
    
}
