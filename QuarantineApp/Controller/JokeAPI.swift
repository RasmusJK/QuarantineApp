//
//  JokeAPI.swift
//  QuarantineApp
//
//  Created by Roope Vaarama on 21.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import Foundation
class JokeAPI {
    private var _url : URL?
    var jokeAPIDelegate : JokeAPIDelegate?
    
    
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
                let jokeInfo = try JSONDecoder().decode(JokeInfo.self, from: data)
                self.jokeAPIDelegate?.newData(jokeInfo)
            } catch let error as NSError  {
                print(error)
                return
            }
        }
        dataTask.resume()
    }
}

protocol JokeAPIDelegate {
    func newData(_ jokeInfo : JokeInfo?)
}
