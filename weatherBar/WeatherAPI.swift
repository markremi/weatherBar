//
//  WeatherAPI.swift
//  weatherBar
//
//  Created by Mark Remi on 9/22/15.
//  Copyright © 2015 Mark Remi. All rights reserved.
//

import Foundation

struct Weather {
    var city: String
    var currentTime: Float
    var conditions: String
    
    var description: String {
        return "\(city): \(currentTime)F and \(conditions)";
    }
}

// Sample JSON
//{
//    "coord": {
//        "lon": -122.33,
//        "lat": 47.61
//    },
//    "weather": [
//    {
//    "id": 802,
//    "main": "Clouds",
//    "description": "scattered clouds",
//    "icon": "03d"
//    }
//    ],
//    "base": "cmc stations",
//    "main": {
//        "temp": 63.48,
//        "pressure": 1016,
//        "humidity": 42,
//        "temp_min": 57,
//        "temp_max": 66.99
//    },
//    "wind": {
//        "speed": 6.7,
//        "deg": 300
//    },
//    "clouds": {
//        "all": 40
//    },
//    "dt": 1442961164,
//    "sys": {
//        "type": 1,
//        "id": 2949,
//        "message": 0.0165,
//        "country": "US",
//        "sunrise": 1442930230,
//        "sunset": 1442973924
//    },
//    "id": 5809844,
//    "name": "Seattle",
//    "cod": 200
//}

protocol WeatherAPIDelegate {
    func weatherDidUpdate(weather: Weather)
}


class WeatherAPI {

    var delegate: WeatherAPIDelegate?
    
    let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?units=imperial&q="
    
    init(delegate: WeatherAPIDelegate) {
        self.delegate = delegate
    }
    
    func weatherFromJSONData(data: NSData) -> Weather? {
        
        // Parse JSON
        typealias JSONDict = [String:AnyObject]
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as! JSONDict
            
            var mainDict = json["main"] as! JSONDict
            var weatherList = json["weather"] as! [JSONDict]
            var weatherDict = weatherList[0]
            
            let weather = Weather (
                city: json["name"] as! String,
                currentTime: mainDict["temp"] as! Float,
                conditions: weatherDict["main"] as! String
            )
            
            return weather
        }
        catch let error as NSError {
            return nil
        }
        
    }

    func fetchWeather(query: String, success: (Weather) -> Void) {
        
        let session = NSURLSession.sharedSession()
        
        let escapedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        let url = NSURL(string: BASE_URL + escapedQuery!)
//        
//        let task = session.dataTaskWithURL(url!) {
//            (data, response, error) in
//            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
//            NSLog(dataString)
//        }
        
        let task = session.dataTaskWithURL(url!) { data, response, error in
            if let weather = self.weatherFromJSONData(data!)
//            NSLog("\(weather)")
                {
//                    self.delegate?.weatherDidUpdate(weather)
                    success(weather)
            }
        }
        
        task.resume()
    }
    
}