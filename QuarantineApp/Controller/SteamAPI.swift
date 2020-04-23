//
//  SteamAPI.swift
//  QuarantineApp
//
//  Created by Rasmus Karling on 22.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import Foundation

class SteamAPI {
    
 var steamAPIDelegate: SteamAPIDelegate?
private var _url: URL?
var url : String {
       set {
           _url = URL(string : newValue)
       }
       get {
           return _url?.absoluteString ?? "no value"
       }
   }

    func getData() {
        print(_url!)
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
            do {
                let steamData = try JSONDecoder().decode(SteamData.self, from: data)
             
                  for i in steamData {
                    print(i.value.name)
                    
                }
                self.steamAPIDelegate?.newData(steamData)
                
               
                   
                
               //  self.steamAPIDelegate?.newData(steamData)
            } catch let error as NSError  {
                print(error)
                return
            }
        }
        dataTask.resume()
    }
}
protocol SteamAPIDelegate {
    func newData(_ steamData : SteamData?)
}
