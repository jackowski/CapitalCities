//
//  Extensions.swift
//  CapitalCities
//
//  Created by Michal Jackowski on 25/01/2021.
//

import Foundation
import UIKit
import CitiesRepository

extension UIImageView {
    func loadImage(urlSting: String, placeholderImage: UIImage) {
        if self.image == nil {
            self.image = placeholderImage
        }
        
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

extension RepositoryError {
    func message() -> String {
        switch self {
        case .noInternetConnection:
            return "No Internet Connection"
        default:
            return "Internal Server Error"
        }
        
    }
}
