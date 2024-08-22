//
//  UINavigationControllerExtenstion.swift
//  WeatherApp
//
//  Created by Venkat on 8/21/24.
//

import Foundation
import UIKit

extension UINavigationController{
    
    func setupNavigationController()  {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 56/255, green: 67/255, blue: 78/255, alpha: 1.0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationBar.barTintColor = .white
        
        let barAppearence = UIBarButtonItemAppearance()
        barAppearence.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        appearance.buttonAppearance = barAppearence
        
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        self.navigationBar.standardAppearance = appearance
        UIBarButtonItem.appearance().tintColor = .white
    }
}
