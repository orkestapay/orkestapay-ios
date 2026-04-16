//
//  Application+Extension.swift
//  Orkestapay
//
//  Created by Hector Rodriguez on 07/04/26.
//

import UIKit

extension UIApplication {
    var currentKeyWindow: UIWindow? {
        return self.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first { $0.isKeyWindow }
    }

    var rootViewController: UIViewController? {
        return currentKeyWindow?.rootViewController
    }
}
