//
//  PinpointKitAdapter.swift
//  Pippin
//
//  Created by Andrew McKnight on 10/25/17.
//  Copyright © 2017 Two Ring Software. All rights reserved.
//

import PinpointKit
import UIKit

public final class PinpointKitAdapter: NSObject, BugReporter {

    public var environment: Environment?
    private var recipients: [String]
    fileprivate var pinpointKit: PinpointKit?
    
    public init(recipients: [String]) {
        self.recipients = recipients
        super.init()
    }

    public func show(fromViewController viewController: UIViewController, screenshot: UIImage?, metadata: [String: AnyObject]?) {
        var feedbackConfig = FeedbackConfiguration(recipients: recipients)
        
        var allMetadata = [String: AnyObject]()
        if let dbData = environment?.coreDataController?.exportData() as NSData? {
            let encodedDBDataString = dbData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) as NSString
            allMetadata["db"] = encodedDBDataString
        }
        if let logs = environment?.logger?.logContents() {
            allMetadata["logs"] = logs as NSString
        }
        if let callsiteMetadata = metadata {
            allMetadata["callsite-metadata"] = callsiteMetadata as NSDictionary
        }
        feedbackConfig.additionalInformation = allMetadata
        
        var config: Configuration
        if let fonts = environment?.fonts {
            let appearance = InterfaceCustomization.Appearance(navigationTitleFont: fonts.title, feedbackSendButtonFont: fonts.subtitle, feedbackCancelButtonFont: fonts.subtitle, feedbackEditHintFont: fonts.text, feedbackBackButtonFont: fonts.subtitle, logCollectionPermissionFont: fonts.italic, logFont: fonts.text, editorDoneButtonFont: fonts.subtitle)
            config = Configuration(appearance: appearance, feedbackConfiguration: feedbackConfig)
        } else {
            config = Configuration(feedbackConfiguration: feedbackConfig)
        }
        pinpointKit = PinpointKit(configuration: config)
        
        if let screenshot = screenshot {
            pinpointKit?.show(from: viewController, screenshot: screenshot)
        } else {
            pinpointKit?.show(from: viewController)
        }
    }

}

extension PinpointKitAdapter: PinpointKitDelegate {
    public func pinpointKit(_ pinpointKit: PinpointKit, willSend feedback: Feedback) {
        environment?.activityIndicator?.show(withText: "Sending report...", completion: nil)
    }
    
    public func pinpointKit(_ pinpointKit: PinpointKit, didSend feedback: Feedback) {
        environment?.activityIndicator?.hide(completion: nil)
    }
    
    public func pinpointKit(_ pinpointKit: PinpointKit, didFailToSend feedback: Feedback, error: Error) {
        environment?.logger?.logError(message: String(format: "[%@] Failed to send bug report: %@", instanceType(self)), error: error)
        environment?.activityIndicator?.hide(completion: nil)
        environment?.alerter?.showAlert(title: "Error", message: "Failed to send bug report. Please check your device's email settings, or contact us directly to help solve the problem.", type: .error, dismissal: .interactive, occlusion: .strong)
    }
}
