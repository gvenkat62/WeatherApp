//
//  NetworkCache.swift
//  WeatherApp
//
//  Created by Venkat on 8/21/24.
//

import Foundation
import UIKit

class ImageCache {
    
    private init() {}
    
    static let shared = NSCache<NSString, UIImage>()
      
}

extension UIImageView {
    func load(url: URL) {
        
        if let cachedImage = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
            print("Image from cache")
            self.image = cachedImage
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}



