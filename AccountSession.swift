//
//  AccountSession.swift
//  teeline-app
//

import UIKit

class APIStore {
    
    // Set to true when views need updating
    // I.e. when the user has leveled up
    static var shouldReload: Bool = false
    private static var account: APIStore.Account?
    private static var session: APIStore.Session?
    
    // Memory data object to store current account details
    struct Account {
        
        var accountId: Int = 0
        var username: String = ""
        var email: String = ""
        var level: Int = 1
        var points: Int = 0
    }
    
    // Memory data object to store current session hash from backend
    struct Session {
        
        let sessionHash: String
    }
    
    // Set or remove current account object
    static func setAccount(account: APIStore.Account?) {
        self.account = account
    }
    
    static func getAccount() -> APIStore.Account? {
        return self.account
    }
    
    // Set or remove current session object
    static func setSession(session: APIStore.Session?) {
        self.session = session
    }
    
    static func getSession() -> APIStore.Session? {
        return self.session
    }
    
    // Add points to the account and send request on update
    static func addPoints(points: Int) -> UIAlertController? {
        self.account!.points += points
        
        var didLevelUp = false
        
        // Whilst points are over 100, remove 100 points and give one level
        while (self.account!.points >= 100) {
            self.account!.points -= 100
            self.account!.level += 1
            
            didLevelUp = true
        }
        
        // Create an update request for the database
        var request = TeelineAPI.Request()
        request.path = "/accounts/level/\(self.account!.level)/\(self.account!.points)"
        request.type = .UPDATE
        
        TeelineAPI.sendRequest(request, handler: {
            response in
            
            if (response.jsonError != 204) {
                //
            }
        })
        
        // Update old views to reflect change
        APIStore.shouldReload = true
        
        // Create an alert if the user did level
        if (didLevelUp) {
            let alertController = UIAlertController(
                title: "Congratulations",
                message: "You are now level \(self.account!.level)!",
                preferredStyle: .Alert
            )
            
            return alertController
        } else {
            return nil
        }
    }
}
