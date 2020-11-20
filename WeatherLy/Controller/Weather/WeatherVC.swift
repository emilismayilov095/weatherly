//
//  ViewController.swift
//  WeatherLy
//
//  Created by Muslim on 20.11.2020.
//  Copyright © 2020 Emil Ismayilov. All rights reserved.
//

import UIKit
import Unrealm

class WeatherVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var waveView                 : CLWaterWaveView!
    @IBOutlet weak var secondWaveView           : CLWaterWaveView!
    
    @IBOutlet weak var dateLabel                : UILabel!
    @IBOutlet weak var cityNameLabel            : UILabel!
    @IBOutlet weak var weatherDescriptionLabel  : UILabel!
    @IBOutlet weak var weatherIcon              : UIImageView!
    @IBOutlet weak var pressureLabel            : UILabel!
    @IBOutlet weak var tempLabel                : UILabel!
    @IBOutlet weak var feelsLikeLabel           : UILabel!
    @IBOutlet weak var windDescriptionLabel     : UILabel!
    
    @IBOutlet weak var weatherStack: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var weatherResponse: WeatherResponse? {
        didSet {
            if weatherResponse == nil {
                self.showAlertWith(title: "Warning", message: "You need Internet for the first time")
            }
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupWavesWith(waveView: secondWaveView, color: .darkGray, speed: 0.008, angularVelocity: 0.31, depth: 0.5)
        self.setupWavesWith(waveView: waveView, color: .lightGray, speed: 0.01, angularVelocity: 0.28, depth: 0.4)
        
        if Reachability.isConnectedToNetwork() {
            let lastSearchedCity = APPDefaults.getString(key: "lastSearchedCity") ?? "Moscow"
            getWeatherByCity(name: lastSearchedCity)
        } else {
            getLastWeatherFromDataBase()
        }
    }
    
    
    // MARK: - Action
    @IBAction func searchPressed(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() {
            self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in
                self.getWeatherByCity(name: city)
                APPDefaults.setString(key: "lastSearchedCity", value: city)
            }
        } else {
            self.showAlertWith(title: "Warning", message: "To search for cities you need to connect to the Internet")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let calendarVC = segue.destination as? CalendarVC else {return}
        calendarVC.data = self.weatherResponse?.list ?? []
        calendarVC.delegate = self
    }
    
}


// MARK: - UI EXtension
extension WeatherVC {
    private func setupWavesWith (waveView: CLWaterWaveView,color: UIColor,speed: CGFloat,angularVelocity: CGFloat,depth: CGFloat ) {
        waveView.backgroundColor = color
        waveView.amplitude = 39
        waveView.speed = speed
        waveView.angularVelocity = angularVelocity
        waveView.depth = depth
        waveView.startAnimation()
    }
    
    private func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addTextField { tf in
            let cities = ["San Francisco", "Moscow", "New York", "St.Peterburg", "Viena"]
            tf.placeholder = cities.randomElement()
        }
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(search)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
    
    private func setupUIWith(listItem: List) {
        let date = Date(timeIntervalSince1970: Double(listItem.dt))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMMM-dd"
        
        self.dateLabel.text = "\(formatter.string(from: date).components(separatedBy: "-").last ?? "") \(formatter.string(from: date).components(separatedBy: "-")[1])"
        
        self.weatherDescriptionLabel.text = listItem.weather.first?.weatherDescription.uppercased() ?? ""
        self.weatherIcon.image = UIImage(systemName: IconHelper.shared.getWeatherIconWith(code: listItem.weather.first?.id ?? 0))
        self.pressureLabel.text = "\(listItem.humidity) % /"
        
        let temp = String(format: "%.1f", listItem.temp.day)
        self.tempLabel.text = "\(temp)˚"
        
        let feel = String(format: "%.1f", listItem.feelsLike.day)
        self.feelsLikeLabel.text = "/ \(feel)˚"
        
        self.windDescriptionLabel.text = "\(listItem.speed) kmh \(listItem.deg) degreese"
    }
}


extension WeatherVC: CalendarDelegate {
    func userDidSelectItem(with item: List) {
        self.setupUIWith(listItem: item)
    }
}

// MARK: - Network EXtension
extension WeatherVC {
    func getWeatherByCity(name: String) {
        self.weatherStack.isHidden = true
        self.activityIndicator.startAnimating()
        NetworkManager.shared.getWeatherBy(cityName: name) { (result) in
            switch result {
            case .success(let response):
                self.activityIndicator.stopAnimating()
                self.weatherStack.isHidden = false
                self.weatherResponse = response
                self.cityNameLabel.text = response.city.name.uppercased()
                print(response.city.name.uppercased())
                if let first = response.list.first {
                    self.setupUIWith(listItem: first)
                }
            case .failure(let error):
                self.showAlertWith(title: "Error", message: error.localizedDescription)
            }
        }
    }
}


// MARK: - DataBase EXtension
extension WeatherVC {
    func getLastWeatherFromDataBase() {
        self.weatherStack.isHidden = true
        do {
            let realm = try Realm()
            let results = realm.objects(WeatherResponse.self)
            if let item = results.first {
                self.weatherStack.isHidden = false
                self.weatherResponse = item
                self.cityNameLabel.text = item.city.name.uppercased()
                if let first = item.list.first {
                    self.setupUIWith(listItem: first)
                }
            } else {
                delayAfter(seconds: 0.4) {
                    self.showAlertWith(title: "Warning", message: "You need Internet for the first time")
                }
            }
        } catch {
            print("realm error")
        }
    }
}
