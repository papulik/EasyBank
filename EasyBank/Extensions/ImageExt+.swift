//
//  ImageExt+.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 13.07.24.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        let urlString = url.absoluteString
        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                return
            }
            
            ImageCache.shared.setImage(image, forKey: urlString)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

