//
//  OrkestaDeviceSessionView.swift
//  democ2p
//
//  Created by Hector Rodriguez on 17/04/26.
//

import SwiftUI

public struct OrkestaSessionManager: UIViewControllerRepresentable {
    let orkestapay: OrkestapayClient
    var onSessionCreated: (String) -> Void
    var onSessionFailure: (String) -> Void

    public func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            orkestapay.createDeviceSession(
                viewController: controller,
                successSessionID: { sessionId in
                    onSessionCreated(sessionId)
                },
                failureSessionID: { error in
                    onSessionFailure(error)
                }
            )
        }
        
        return controller
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
