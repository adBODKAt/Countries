//
//  UIViewController+UIAlertAction.swift
//  Countries
//
//  Created by Александр Марков on 27/05/2019.
//  Copyright © 2019 Александр Марков. All rights reserved.
//

import UIKit

extension UIViewController {
    func showCancellableAlertWith(userAction: UIAlertAction, error: NSError?) {
        var errorMessage = ""
        if let error = error {
            errorMessage = error.localizedDescription
        } else {
            errorMessage = "Неизвестная ошибка"
        }
        
        let alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        alertController.addAction(userAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
