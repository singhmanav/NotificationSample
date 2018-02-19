//
//  Utils.swift
//  NotificationSample
//
//  Created by xeadmin on 30/01/18.
//  Copyright © 2018 Manav. All rights reserved.
//

import UIKit
import UserNotifications

class Utils{
    static func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else { return }
            getNotificationSettings()
        }
    }
    
    class func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}
