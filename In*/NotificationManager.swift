//
//  NotificationManager.swift
//  876 Inventory
//
//  Created by Mohammad Sulthan on 26/08/22.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationCenter()
    
    init() {
        self.userNotificationCenter = UNUserNotificationCenter.current()
    }
    
    let userNotificationCenter: UNUserNotificationCenter?
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        
        self.userNotificationCenter?.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }

    func sendNotification(product: String?) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Product is out of stock!"
        
        if let product = product {
            notificationContent.body = "Product \(String(describing: product)) is run out of stock. Check it out!"
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "out_of_stock",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter?.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
