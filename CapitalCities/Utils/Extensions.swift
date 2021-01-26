//
//  Extensions.swift
//  CapitalCities
//
//  Created by Michal Jackowski on 25/01/2021.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(urlSting: String, placeholderImage: UIImage) {
        self.image = placeholderImage
        
        guard let url = URL(string: urlSting) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
