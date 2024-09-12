//
//  WebViewPresentation.swift
//  
//
//  Created by Hector Rodriguez on 05/09/24.
//

import UIKit
import Foundation

extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopViewController(base: selected)
            }
        }

        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }

        return base
    }
    
    var firstKeyWindow: UIWindow? {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .filter { $0.activationState == .foregroundActive }
                .first?.windows

                .first(where: \.isKeyWindow)

        }
}
