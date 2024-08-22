//
//  ViewController.swift
//  WeatherApp
//
//  Created by Venkat on 8/21/24.
//

import Foundation
import UIKit

class viewController: UIViewController{
    
    var window: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }
        return window
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let networkservice = NetWorkService.shared
//        let apiService = WeatherSerice(service: networkservice)
//        
//        let viewModel = WeatherViewModel(apiService: apiService)
        let viewController = WeatherViewController()
        guard let window = self.window else{return}
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setupNavigationController()
        window.rootViewController = navigationController
        
        // Do any additional setup after loading the view.
    }
}
