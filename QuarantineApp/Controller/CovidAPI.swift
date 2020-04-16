//
//  CovidAPI.swift
//  QuarantineApp
//
//  Created by iosdev on 16.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//
import Foundation

class CovidAPI {
    
    private var _url: URL?
    var covidAPIDelegate: CovidAPIDelegate?
    var url: String {
        set {
            _url = URL(string: newValue)
        }
        get {
            return _url?.absoluteString ?? "no value"
        }
    }
    func getData() {
        let dataTask = URLSession.shared.dataTask(with: _url!) { data, response, error in
            if let error = error {
                print(error)
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return
            }
            guard let data = data else {
                return
            }
            let covidData = try? JSONDecoder().decode(CovidData.self, from: data)
            
            print("Total covid cases: \(covidData?.cases ?? 0), Deaths: \(covidData?.deaths ?? 0), Recovered: \(covidData?.recovered ?? 0)")
            self.covidAPIDelegate?.newData(covidData)
        }
        dataTask.resume()
    }
}

protocol CovidAPIDelegate {
    func newData(_ covidData: CovidData?)
}
