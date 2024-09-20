//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Venkat on 8/21/24.
//

import Foundation
import UIKit

class UserTableViewCell: UITableViewCell {

    let titleLable: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = UIFont.preferredFont(forTextStyle: .title2)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let dateLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: .title2)
        l.textColor = .white
        return l
    }()
    
    let temperatureLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: .title2)
        l.textColor = .white
        return l
    }()
    
    let humidLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: .title2)
        l.textAlignment = .left
        l.textColor = .white
        return l
    }()
    
    let weatherIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var leftStackView: UIStackView = {
        let s = UIStackView(arrangedSubviews: [titleLable, dateLabel, temperatureLabel,humidLabel])
        s.axis = .vertical
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    fileprivate func setupViews() {
        
        contentView.addSubview(leftStackView)
        contentView.addSubview(weatherIcon)

        contentView.backgroundColor = .systemBlue
        NSLayoutConstraint.activate([
            
            weatherIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            
            leftStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            leftStackView.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 10),
            leftStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            leftStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            leftStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
         
            weatherIcon.widthAnchor.constraint(equalToConstant: 150),
            weatherIcon.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func noDataBinding(){
        self.weatherIcon.isHidden = true
        self.leftStackView.isHidden = false
        self.titleLable.isHidden = false
        self.dateLabel.isHidden = true
        self.temperatureLabel.isHidden = true
        self.humidLabel.isHidden = true
        self.titleLable.textAlignment = .center
        
        self.titleLable.text = "No data found"
    }
    
    
    func bindData(user:WeatherData)
    {
        self.leftStackView.isHidden = false
        self.dateLabel.isHidden = false
        self.temperatureLabel.isHidden = false
        self.humidLabel.isHidden = false
        self.titleLable.isHidden = false
        self.weatherIcon.isHidden = false

        self.titleLable.textAlignment = .left
        
        let dateTime = self.getDateTime(user: user)
        self.titleLable.text = "City : \(user.name)"
        self.dateLabel.text = "Date: \(dateTime)"
        self.temperatureLabel.text = "Temparature : \(user.main.temp) Fahrenheit"
        self.humidLabel.text = "Humidity : \(user.main.humidity) %"

        let imgStr:String? =  WetaherEndpoint.getImageUrl.rawValue+user.weather[0].icon+WetaherEndpoint.getPngExtension.rawValue as String
        guard  let imageUrl = imgStr else{
            return
        }
        self.weatherIcon.isHidden = false
        self.weatherIcon.load(url: URL(string: imageUrl)!)
        self.weatherIcon.contentMode = .scaleAspectFit
        
    }
    func getDateTime(user:WeatherData)->String{
        
        let dateVar = Date.init(timeIntervalSince1970: TimeInterval(user.dt))
        let dateFormatter = DateFormatter()
        let timeZone = TimeZone(secondsFromGMT: user.timezone)
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
        return dateFormatter.string(from: dateVar)
    }
    
}
