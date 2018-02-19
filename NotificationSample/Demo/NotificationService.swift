//
//  NotificationService.swift
//  Demo
//
//  Created by xeadmin on 19/02/18.
//  Copyright © 2018 Manav. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            
            if bestAttemptContent.categoryIdentifier == "recipe" {
                let url = URL(string: "http://sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4")
                
                downloadWithURL(url: url!, completion: { (complete) in
                    
                    contentHandler(bestAttemptContent)
                })
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    private func downloadWithURL(url: URL, completion: @escaping (Bool) -> Void) {
        
        let task = URLSession.shared.downloadTask(with: url) { (downloadedUrl, response, error) in
            
            guard let downloadedUrl = downloadedUrl else {
                completion(false)
                return
            }
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            
            var url = URL(fileURLWithPath: path)
            url = url.appendingPathComponent("sample.mp4")
            
            
            try? FileManager.default.moveItem(at: downloadedUrl, to: url)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "video", url: url, options: nil)
                defer {
                    self.bestAttemptContent?.attachments = [attachment]
                    completion(true)
                }
            }
            catch {
                completion(true)
            }
        }
        task.resume()
    }
}


