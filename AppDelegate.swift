//
//  AppDelegate.swift
//  teeline-app
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // Entry point to the Teeline App
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Create a new window object to hold all views
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        // If window was created, setup initial window options
        if let windowValue = self.window {
            // Set background and current view to the login screen
            windowValue.backgroundColor = UIColor.blackColorE()
            windowValue.rootViewController = LoginView(statusMessage: nil)
            
            // Make the current window visible once splash screen is loaded
            windowValue.makeKeyAndVisible()
        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // N/A
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // N/A
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // N/A
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // N/A
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // N/A
    }
}
