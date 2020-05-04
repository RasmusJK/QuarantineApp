//
//  NetflixAPI.swift
//  QuarantineApp
//
//  Created by Topias Peiponen on 22.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import Foundation

/**
    Controller for fetching data from the Netflix API. For more information about the API used visit https://rapidapi.com/unogs/api/unogsng/details
 */
class NetflixAPI {
    var netflixAPIDelegate : NetflixAPIDelegate?
    
    func getData(categorySwitch : String) {
        let headers = [
            "x-rapidapi-host": "unogsng.p.rapidapi.com",
            "x-rapidapi-key": "87c1f7b623msh2c59183703224a2p125cedjsnfbe032e4e91e"
        ]
        
        var request : URLRequest
        switch categorySwitch {
        case "NetflixMovie":
            request = URLRequest(url: URL(string: "https://unogsng.p.rapidapi.com/search?country_andorunique=unique&newdate=2018-01-01&type=movie&start_year=1972&orderby=rating%252C%20date&audiosubtitle_andor=and&limit=20&subtitle=english&countrylist=78&audio=english&offset=0&end_year=2020")!)
        case "NetflixSeries":
            request = URLRequest(url: URL(string: "https://unogsng.p.rapidapi.com/search?country_andorunique=unique&newdate=2018-01-01&type=series&start_year=1972&orderby=date%252Crating&audiosubtitle_andor=and&limit=20&subtitle=english&countrylist=78&audio=english&offset=0&end_year=2020")!)
        default:
            request = URLRequest(url: URL(string: "")!)
        }
        request.httpMethod = "GET"
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 10.0
        request.allHTTPHeaderFields = headers
        print("REQUEST: \(request)")
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    return
            }
            print("HttpResponse: \(httpResponse)")
            guard let data = data else {
                return
            }
            print("Fetch data: \(data)")
            print("Current thread is: \(Thread.current)")
            do {
                let netflixInfo = try JSONDecoder().decode(NetflixInfo.self, from: data)
                self.netflixAPIDelegate?.newData(netflixInfo, categorySwitch: categorySwitch)
            } catch let error as NSError  {
                print(error)
                return
            }
        })
        dataTask.resume()
        }
}

protocol NetflixAPIDelegate {
    func newData(_ netflixInfo : NetflixInfo?, categorySwitch : String)
}
