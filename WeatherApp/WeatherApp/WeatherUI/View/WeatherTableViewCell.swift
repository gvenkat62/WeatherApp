//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Venkat on 8/21/24.
//

import Foundation
import UIKit

class UserTableViewCell : UITableViewCell{
    
    var titleLable:UILabel  = {
        let lable  = UILabel()
        lable.font = .boldSystemFont(ofSize: 14)
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textAlignment = .left
        lable.numberOfLines = 0
        //lable.backgroundColor = .blue
        return lable
    }()
    
    var descriptionLable:UILabel  = {
        let lable  = UILabel()
        lable.font = .boldSystemFont(ofSize: 14)
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textAlignment = .left
        lable.numberOfLines = 0
        
        //lable.backgroundColor = .red
        
        return lable
    }()
    
    var avatarImageView:UIImageView = {
        let imgView  = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        //imgView.backgroundColor = .yellow
        imgView.layer.borderWidth = 0.5
        imgView.layer.borderColor = UIColor.gray.cgColor
        imgView.contentMode = .scaleToFill
        imgView.isHidden = true

        return imgView
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLable)
        contentView.addSubview(descriptionLable)
        contentView.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            
            titleLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLable.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            
            descriptionLable.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 10),
            descriptionLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            descriptionLable.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor),
            descriptionLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func bindData(user:WeatherData)
    {
        let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(user.dt)/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
        print(dateFormatter.string(from: dateVar))
        
        self.titleLable.text = "City : \(user.name) \n\nDate: \(dateFormatter.string(from: dateVar)) \n\nTemparature : \(user.main.temp) Fahrenheit"
        self.descriptionLable.text = "\(user.weather[0].main)/\(user.weather[0].description) \n\nHumidity : \(user.main.humidity) %"
        
        var imgStr:String? =  WetaherEndpoint.getImageUrl.rawValue+user.weather[0].icon+WetaherEndpoint.getPngExtension.rawValue as String
        guard  let imageUrl = imgStr else{
            return
        }
        self.avatarImageView.isHidden = false
        self.avatarImageView.load(url: URL(string: imageUrl)!)
        self.avatarImageView.contentMode = .scaleAspectFill
        
    }
}
