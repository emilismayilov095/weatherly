//
//  WeatherModels.swift
//  WeatherLy
//
//  Created by Muslim on 20.11.2020.
//  Copyright © 2020 Emil Ismayilov. All rights reserved.
//

import Foundation
import Unrealm

//struct WeatherResponse: Codable {
//    let city: City
//    let cod: String
//    let message: Double
//    let cnt: Int
//    let list: [List]
//}
//
//// MARK: - City
//struct City: Codable {
//    let id: Int
//    let name: String
//    let coord: Coord
//    let country: String
//    let population, timezone: Int
//}
//
//// MARK: - Coord
//struct Coord: Codable {
//    let lon, lat: Double
//}
//
//// MARK: - List
//struct List: Codable {
//    let dt, sunrise, sunset: Int
//    let temp: Temp
//    let feelsLike: FeelsLike
//    let pressure, humidity: Int
//    let weather: [Weather]
//    let speed: Double
//    let deg, clouds: Int
//    let pop: Double
//    let rain: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case dt, sunrise, sunset, temp
//        case feelsLike = "feels_like"
//        case pressure, humidity, weather, speed, deg, clouds, pop, rain
//    }
//}
//
//// MARK: - FeelsLike
//struct FeelsLike: Codable {
//    let day, night, eve, morn: Double
//}
//
//// MARK: - Temp
//struct Temp: Codable {
//    let day, min, max, night: Double
//    let eve, morn: Double
//}
//
//// MARK: - Weather
//struct Weather: Codable {
//    let id: Int
//    let main, weatherDescription, icon: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, main
//        case weatherDescription = "description"
//        case icon
//    }
//}





// Save Models
class WeatherResponse: NSObject, Realmable, Codable {
    var city: City = City()
    var cod: String = ""
    var list: [List] = []
    
    enum CodingKeys: String, CodingKey {
        case city
        case cod
        case list
    }
    
    required override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.city = try container.decode(City.self, forKey: .city)
        self.cod = try container.decode(String.self, forKey: .cod)
        
        let wif = try container.decode([List].self, forKey: .list)
        list.append(contentsOf: wif)
        
        super.init()
        //self.list = try container.decode([List].self, forKey: .list)
    }
    
    static func primaryKey() -> String? {
        return "cod"
    }
}

// MARK: - City
class City: NSObject, Realmable, Codable {
    var id: Int = 0
    var name: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    required override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        
        super.init()
    }
    
    static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - List
class List: NSObject, Realmable, Codable {
   var dt: Int = 0
   var temp: Temp = Temp()
   var feelsLike: FeelsLike = FeelsLike()
   var pressure : Int = 0
   var humidity: Int = 0
   var weather: [Weather] = []
   var speed: Double = 0
   var deg: Int = 0

    enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity, weather, speed, deg
    }
    
    required override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dt = try container.decode(Int.self, forKey: .dt)
        self.temp = try container.decode(Temp.self, forKey: .temp)
        self.feelsLike = try container.decode(FeelsLike.self, forKey: .feelsLike)
        self.pressure = try container.decode(Int.self, forKey: .pressure)
        self.humidity = try container.decode(Int.self, forKey: .humidity)
        self.speed = try container.decode(Double.self, forKey: .speed)
        self.deg = try container.decode(Int.self, forKey: .deg)
        
        let wif = try container.decode([Weather].self, forKey: .weather)
        weather.append(contentsOf: wif)
        
        super.init()
    }
    
    static func primaryKey() -> String? {
        return "dt"
    }
}

// MARK: - FeelsLike
class FeelsLike: NSObject, Realmable, Codable {
    var id = UUID().uuidString
    var day: Double  = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case day
    }
    
    required override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
       // self.id = try container.decode(String.self, forKey: .id)
        self.day = try container.decode(Double.self, forKey: .day)
        
        super.init()
    }
    
    static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - Temp
class Temp: NSObject, Realmable, Codable {
    var id = UUID().uuidString
    var day: Double  = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case day
    }
    
    required override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
       // self.id = try container.decode(String.self, forKey: .id)
        self.day = try container.decode(Double.self, forKey: .day)
        
        super.init()
    }
    
    static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - Weather
class Weather:NSObject, Realmable, Codable {
    var id: Int = 0
    var weatherDescription: String = ""
    var icon: String = ""

    enum CodingKeys: String, CodingKey {
        case id
        case weatherDescription = "description"
        case icon
    }
    
    required override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.weatherDescription = try container.decode(String.self, forKey: .weatherDescription)
        self.icon = try container.decode(String.self, forKey: .icon)
        super.init()
    }
    
    static func primaryKey() -> String? {
        return "id"
    }
}
