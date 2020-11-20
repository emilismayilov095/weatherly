//
//  CalendarCell.swift
//  WeatherLy
//
//  Created by Muslim on 20.11.2020.
//  Copyright © 2020 Emil Ismayilov. All rights reserved.
//

import UIKit

class CalendarCell: UITableViewCell {

    @IBOutlet weak var dayLabel         : UILabel!
    @IBOutlet weak var monthLabel       : UILabel!
    @IBOutlet weak var weatherIcon      : UIImageView!
    @IBOutlet weak var pressureLabel    : UILabel!
    @IBOutlet weak var tempLabel        : UILabel!
    @IBOutlet weak var feelsLikeLabel   : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCellWith(item: List) {
        let date = Date(timeIntervalSince1970: Double(item.dt))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMMM-dd"
        
        self.dayLabel.text = formatter.string(from: date).components(separatedBy: "-").last ?? ""
        self.monthLabel.text = formatter.string(from: date).components(separatedBy: "-")[1]
        
        self.weatherIcon.image = UIImage(systemName: IconHelper.shared.getWeatherIconWith(code: item.weather.first?.id ?? 0))
        self.pressureLabel.text = "\(item.humidity) %"
        
        let temp = String(format: "%.1f", item.temp.day)
        self.tempLabel.text = "\(temp)˚"
        
        let feel = String(format: "%.1f", item.feelsLike.day)
        self.feelsLikeLabel.text = "\(feel)˚"
    }
}
