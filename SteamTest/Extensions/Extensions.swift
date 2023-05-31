//
//  Extensions.swift
//  SteamTest
//
//  Created by Александр Молчан on 31.05.23.
//

import UIKit

extension UIViewController {
    func navigationControllerSettings(title: String) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = title
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemCyan, NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 35) as Any]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemCyan, NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 20) as Any]
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
