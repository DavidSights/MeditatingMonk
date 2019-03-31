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

    // TODO: Remove these as soon as the enum below can be utilized by @objc.
    @objc static let david = "David"
    @objc static let wolf = "Wolf"

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

    private var delegate: EmailManagerDelegate?
    private static var shared = EmailManager()

    // MARK: - Convenience Methods

    class func sendEmail(to recipients: [EmailRecipient], message: String) {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = EmailManager.shared
        mailComposeViewController.setSubject("Meditating Monk Feedback")
        mailComposeViewController.setMessageBody(message, isHTML: false)
        mailComposeViewController.setToRecipients(recipients.map { $0.address })
        EmailManager.shared.delegate?.showEmailViewController(mailComposeViewController)
    }

    @objc class func sendEmail(toName name: String, message: String) {
        switch name {
        case EmailManager.david:
            sendEmail(to: [.david], message: message)
        case EmailManager.wolf:
            sendEmail(to: [.davey], message: message)
        default:
            return
        }
    }

    class func registerDelegate(delegate: EmailManagerDelegate) {
        EmailManager.shared.delegate = delegate;
    }
}

// MARK: - Mail Composer Delegation

extension EmailManager: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        delegate?.dismissEmailViewController(controller)
    }
}
