//
//  EmailManager.swift
//  MeditatingMonk
//
//  Created by David Seitz Jr on 3/18/19.
//  Copyright © 2019 DavidSights. All rights reserved.
//

import MessageUI

@objc protocol EmailManagerDelegate {
    func showEmailViewController(_ emailViewController: UIViewController)
    func dismissEmailViewController(_ emailViewController: UIViewController)
}

class EmailManager: NSObject {

    // MARK: - Recipients

    enum EmailRecipient {

        case david
        case davey
        case other(name: String, email: String)

        var name: String {

            switch self {

            case .david:
                return "David"

            case .davey:
                return "Davey"

            case .other(let otherName, _):
                return otherName
            }
        }

        var address: String {

            switch self {

            case .david:
                return "davidseitzjr@me.com"

            case .davey:
                return "davyowolfmusic@gmail.com"

            case .other(_, let otherAddress):
                return otherAddress
            }
        }
    }

    // MARK: - Properties

    var delegate: EmailManagerDelegate?
    var shared = EmailManager()

    // MARK: - Convenience Methods

    func sendEmail(to recipients: [EmailRecipient], message: String) {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setSubject("Meditating Monk Contact")
        mailComposeViewController.setMessageBody(message, isHTML: false)
        mailComposeViewController.setToRecipients(recipients.map { $0.address })
        self.delegate?.showEmailViewController(mailComposeViewController)
    }
}

// MARK: - Mail Composer Delegation

extension EmailManager: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        delegate?.dismissEmailViewController(controller)
    }
}
