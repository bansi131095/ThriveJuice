//
//  AppDelegate.swift
//  ThriveJuice
//
//  Created by MacBook on 03/08/23.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import FirebaseCore
import FirebaseMessaging
import Firebase
import UserNotifications
import GoogleSignIn



@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        global.shared.DeviceId = DeviceId.getDeviceID()
        GMSServices.provideAPIKey("AIzaSyA07KPtrWrl_4GlOVCGHp5RPDYmZZGewWA")
        GMSPlacesClient.provideAPIKey("AIzaSyA07KPtrWrl_4GlOVCGHp5RPDYmZZGewWA")
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        //MARK:- push notification
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            //Messaging.messaging().remoteMessageDelegate = self
//            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        // [END register_for_notifications]
        // Add observer for InstanceID token refresh callback.
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.tokenRefreshNotification),
//                                               name: .InstanceIDTokenRefresh,
//                                               object: nil)
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        print("NOTIFICATION RECEIVED from didReceiveRemoteNotification fetchCompletionHandler")
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        Messaging.messaging().apnsToken = deviceToken
        print("APNs token retrieved:\(deviceToken)")
//        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
        Messaging.messaging().token { (token, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = token {
                print("Remote instance ID token: \(result)")
                UserDefaults.standard.set(result, forKey: "fcmtoken")
            }
        }
        // With swizzling disabled you must set the APNs token here.
        // InstanceID.instanceID().setAPNSToken(deviceToken, type: InstanceIDAPNSTokenType.sandbox)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            return GIDSignIn.sharedInstance.handle(url)
        
        
    }
}


extension AppDelegate : UNUserNotificationCenterDelegate
{
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        print("NOTIFICATION RECEIVED from willPresent")
        
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey]
        {
            print("willPresent Message ID: \(messageID)")
        }
        
        // Print full message.
        //print(userInfo)
        //        UNNotificationSound.default()
        
        print("willPresent: \(userInfo)")
        
        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        if let action = userInfo["type"] as? NSString
        {
            
        }
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey]
        {
            print("didReceive Message ID: \(messageID)")
        }
        // Print full message.
        print("didReceive: \(userInfo)")
        UIApplication.shared.applicationIconBadgeNumber = 0
        if let action = userInfo["type"] as? String
        {
            
            switch UIApplication.shared.applicationState
            {
            case .active:
                
                break
            case .background, .inactive:
                
                break
//            case .inactive:
//
//                break
            default:
                break
            }
        }
        completionHandler()
        
        print(userInfo)
        
    }
}
// [END ios_10_message_handling]

// [START ios_10_data_message_handling]
extension AppDelegate : MessagingDelegate
{
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?)
    {
        print("Firebase registration token from didRefreshRegistrationToken :\(fcmToken ?? "")")
        UserDefaults.standard.set(fcmToken, forKey: "fcmtoken")
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    /*func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message from remoteMessage: MessagingRemoteMessage : \(remoteMessage.appData)")
        if let action = remoteMessage.appData["Type"] as? NSString
        {
        }
    }*/

    // [END ios_10_data_message]
}
