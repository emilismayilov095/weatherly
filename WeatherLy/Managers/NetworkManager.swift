//
//  NetworkManager.swift
//  WeatherLy
//
//  Created by Muslim on 20.11.2020.
//  Copyright © 2020 Emil Ismayilov. All rights reserved.
//

import Foundation
import Alamofire
import Unrealm

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func getWeatherBy(cityName: String, completion: @escaping (Swift.Result<WeatherResponse, Error>) -> Void){
        let url = "https://api.openweathermap.org/data/2.5/forecast/daily?q=\(cityName)&appid=\(apiKey)&units=metric"
        let escapedString = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? ""
        Alamofire.request(escapedString, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            print("getWeatherBy: ", response)
            
            DispatchQueue.main.async {
                switch response.result {
                case .failure(let error): completion(.failure(error))
                case .success :
                    do {
                        let data = try JSONDecoder().decode(WeatherResponse.self, from: response.data!)
                        completion(.success(data))
                        
                        do {
                            let realm = try Realm()
                            try realm.write {
                                realm.add(data, update: .modified)
                                print("Save Success")
                            }
                        } catch {
                            print("Realm Save error")
                        }
                        
                    } catch (let error) {
                        print(error)
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
