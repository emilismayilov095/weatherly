//
//  IconHelper.swift
//  WeatherLy
//
//  Created by Muslim on 20.11.2020.
//  Copyright © 2020 Emil Ismayilov. All rights reserved.
//

import UIKit

class IconHelper {
    
    static let shared = IconHelper()
    private init() {}
    
    func getWeatherIconWith(code: Int) -> String {
        switch code {
         case 200...232 : return "cloud.bolt.rain.fill"
         case 300...321 : return "cloud.drizzle.fill"
         case 500...531 : return "cloud.rain.fill"
         case 600...622 : return "cloud.snow.fill"
         case 701...781 : return "smoke.fill"
         case 800       : return "sun.min.fill"
         case 801...804 : return "cloud.fill"
         default        : return "nosign"
         }
    }
    
}
