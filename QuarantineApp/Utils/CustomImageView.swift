//
//  CustomImageView.swift
//  QuarantineApp
//
//  Created by Topias Peiponen on 3.5.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

/**
    Fetches an UIImage from the image cache and if it doesn't exist in the cache, creates an UIImage using an URL string.
 */
class CustomImageView: UIImageView {
    var imageUrlString : String?
    
    func loadImageWithURLString(urlString : String) {
        imageUrlString = urlString
        
        let url = URL(string : urlString)!
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = imageFromCache
            return
        }
        let request = URLRequest(url:url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    return
            }
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data)
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
            }
        }
        task.resume()
    }
}
