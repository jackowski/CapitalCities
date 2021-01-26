//
//  ErrorDisplayable.swift
//  CapitalCities
//
//  Created by Michal Jackowski on 26/01/2021.
//

import Foundation
import UIKit

protocol ErrorDisplayable {
    func showAlert(message: String, retryAction: (() -> ())?)
}

extension ErrorDisplayable where Self: UIViewController {
    func showAlert(message: String, retryAction: (() -> ())?) {
        let alertController = UIAlertController(title: "Something went wrong", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (_) in
            retryAction?()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
