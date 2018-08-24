//
//  AuthorizedCLLocationManager.swift
//  Pippin
//
//  Created by Andrew McKnight on 4/17/16.
//  Copyright © 2016 Two Ring Software. All rights reserved.
//

import CoreLocation
import Foundation
import Result

private let firstLaunchTokenUserDefaultKey = "com.tworingsoft.can-i-haz.authorized-location-manager.user-defaults.key.first-launch-token"

public enum AuthorizationScope: Int {
    case whenInUse
    case always
}

public typealias AuthorizedLocationManagerResult = Result<CLLocationManager, NSError>

enum AuthorizationErrorCode: Int {
    case denied
    case disabled
}

private let AuthorizationErrorDomain = "com.tworingsoft.can-i-haz.authorized-location-manager.error"
private let AuthorizationErrorDescription = "Location services not available."

public class AuthorizedCLLocationManager: NSObject {

    fileprivate static let singleton = AuthorizedCLLocationManager()

    fileprivate var authorizationCompletion: ((AuthorizedLocationManagerResult) -> Void)!
    fileprivate var authorizationScope: AuthorizationScope!
    
    fileprivate var locationManager: CLLocationManager?

    public class func authorizedLocationManager(scope: AuthorizationScope, completion: @escaping (AuthorizedLocationManagerResult) -> Void) {
        guard CLLocationManager.locationServicesEnabled() else {
            let error = NSError(domain: AuthorizationErrorDomain, code: AuthorizationErrorCode.disabled.rawValue, userInfo: [NSLocalizedDescriptionKey: AuthorizationErrorDescription, NSLocalizedFailureReasonErrorKey: "The user has disabled location services for their device."])
            completion(.failure(error))
            return
        }

        self.checkRequiredPlistValues(scope)
        
        singleton.createAndAuthorizeNewLocationManager(scope, completion: completion)
    }

    fileprivate class func checkRequiredPlistValues(_ scope: AuthorizationScope) {
        var requiredPlistKey: String!
        switch scope {
        case .always:
            requiredPlistKey = "NSLocationAlwaysUsageDescription"
            break
        case .whenInUse:
            requiredPlistKey = "NSLocationWhenInUseUsageDescription"
            break
        }

        guard let infoDictionary = Bundle.main.infoDictionary else {
            fatalError("Could not locate Info.plist keys and values.")
        }
        guard let requiredLocationRequestDescriptionValue = infoDictionary[requiredPlistKey] as? String else {
            fatalError("You must provide a value for \(requiredPlistKey) in your app's Info.plist for the location services request dialog to be shown to the user.")
        }
        if requiredLocationRequestDescriptionValue.count == 0 {
            fatalError("You provided a description value for \(requiredPlistKey) with length 0. This string is displayed to the user in the request prompt; consider providing more information why you are requesting location services.")
        }
    }

    fileprivate func createAndAuthorizeNewLocationManager(_ scope: AuthorizationScope, completion: @escaping ((AuthorizedLocationManagerResult) -> Void)) {
        authorizationScope = scope

        self.authorizationCompletion = { authorizationResult in
            switch authorizationResult {
            case .success(let authorizedLocationManager):
                self.locationManager = nil
                authorizedLocationManager.delegate = nil
                completion(.success(authorizedLocationManager))
            case .failure(let error):
                completion(.failure(error))
            }
        }

        // just by instantiating, we'll get a callback to `locationManager(_:didChangeAuthorization:)`
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }

}

extension AuthorizedCLLocationManager: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var authorized = false

        switch status {
        case .authorizedAlways:
            authorized = true
            break
        case .authorizedWhenInUse:
            authorized = true
            break
        case .denied:
            authorized = false
            break
        case .notDetermined:
            authorized = false
            break
        case .restricted:
            authorized = false
            break
        }

        if authorized {
            authorizationCompletion(.success(manager))
            return
        }

        let defaults = UserDefaults.standard
        let appHasLaunchedAtLeastOnceBefore = defaults.bool(forKey: firstLaunchTokenUserDefaultKey)

        if !appHasLaunchedAtLeastOnceBefore {
            defaults.set(true, forKey: firstLaunchTokenUserDefaultKey)
            defaults.synchronize()

            let scope: AuthorizationScope = self.authorizationScope
            switch scope {
            case .whenInUse:
                manager.requestWhenInUseAuthorization()
                break
            case .always:
                manager.requestAlwaysAuthorization()
                break
            }
            
            return
        }
        
        let error = NSError(domain: AuthorizationErrorDomain, code: AuthorizationErrorCode.denied.rawValue, userInfo: [NSLocalizedDescriptionKey: AuthorizationErrorDescription, NSLocalizedFailureReasonErrorKey: "The user has denied location services for this app."])
        authorizationCompletion(.failure(error))
    }
    
}
