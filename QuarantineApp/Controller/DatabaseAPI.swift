//
//  DatabaseAPI.swift
//  QuarantineApp
//
//  Created by iosdev on 28.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

/*
import Foundation

class DatabaseAPI {
    
    private var _url:URL?
    var openWeatherAPIDelegate:OpenWeatherAPIDelegate?
    
    var url:String {
        set {
            _url = URL(string: newValue)
        }
        get {
            return _url?.absoluteString ?? "no value"
        }
    }
    
    func downloadData(completion: @escaping ([String], Error?) -> Void) {
     var reviewArray = [String]()
      db.collection("reviews").getDocuments { QuerySnapshot, error in
        if let error = error {
          print(error)
          completion(reviewArray, error)
          return
        }
        for doc in QuerySnapshot!.documents {
          let data = ("\(doc.data())")
          reviewArray.append(data)
        }
        completion(reviewArray, error)
      }
    }
    
    
    
    func getData () {
        
        let dataTask = URLSession.shared.dataTask(with: _url!) { data, response, error in
            if let error = error {
                print(error)
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    return
            }
            
            guard let data = data else {
                return
            }
            
            let weatherInfo = try? JSONDecoder().decode(WeatherObject.self, from: data)
            
            print("data gotten")
            self.openWeatherAPIDelegate?.newData(weatherInfo)
        }
        dataTask.resume()
    }
}

protocol OpenWeatherAPIDelegate {
    func newData(_ weatherData:WeatherObject?)
}
*/
