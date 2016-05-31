//
//  GravatarAPI.swift
//  teeline-app
//


import Foundation
import UIKit
import CryptoSwift

class GravatarAPI: NSObject {
    
    private override init() {
        // Use the static functions only
    }
    
    // Create an email hash used for Gravatar ID
    static func emailHash(email: String) -> String {
        return email.trim().lowercaseString.md5()
    }
    
    // Create an avatar image URL based on the email and image size
    static func avatarUrl(email: String, size: Int) -> NSURL? {
        let emailHash = GravatarAPI.emailHash(email)
        
        return NSURL(string: "https://secure.gravatar.com/avatar/\(emailHash).jpg?s=\(size)&d=404")
    }
    
    // Fetch avatar image data
    static func avatarImage(email: String, size: Int, handler: UIImage? -> Void) {
        let imageUrl = GravatarAPI.avatarUrl(email, size: size)!
        
        // Send data task and fetch data from URL
        NSURLSession.sharedSession().dataTaskWithURL(imageUrl, completionHandler: {
            (data, response, _) in
            
            let httpResponse = response as! NSHTTPURLResponse
            
            // If avatar response 200 (OK / found) then set it
            if (httpResponse.statusCode == 200) {
                dispatch_async(dispatch_get_main_queue(), {
                    handler(UIImage(data: data!))
                })
            }
            
            // Leave avatar if not found
        }).resume()
    }
}
