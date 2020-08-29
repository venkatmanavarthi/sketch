//
//  UIImageView+Extension.swift
//  sketch
//
//  Created by manavarthivenkat on 29/08/20.
//  Copyright © 2020 manavarthi. All rights reserved.
//

import UIKit
var imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {

    func loadImage(urlString: String) {
        
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }
        print("isdhiuvfhgsdijfgvhui")
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Couldn't download image: ", error)
                return
            }
            
            guard let data = data else { return }
            let image = UIImage(data: data)
            if let downloadedImage = image{
                imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()

    }
}
