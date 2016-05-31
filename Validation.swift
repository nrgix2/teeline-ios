//
//  Validation.swift
//  teeline-app
//

import Foundation

class Validation: NSObject {
    
    // Enumerated failure reasons:
    //
    // Too Long -> Text is too long
    // Too Short -> Text is too short
    // Has Illegal -> Characters out of set found
    // No Domain -> No domain part in email
    // No Match -> Final regular expression check failure
    //
    enum FailureReason {
        case TOO_LONG
        case TOO_SHORT
        case HAS_ILLEGAL
        case NO_DOMAIN
        case NO_MATCH
    }
    
    private override init() {
        // Use the static functions only
    }
    
    // Check username string and return failure on error
    static func validateUsername(text: String) -> FailureReason? {
        if (text.characters.count > 16) {
            return Validation.FailureReason.TOO_LONG
        }
        
        if (text.characters.count < 3) {
            return Validation.FailureReason.TOO_SHORT
        }
        
        let lowerSet = "abcdefghijklmnopqrstuvwxyz"
        let upperSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let miscSet = "0123456789_"
        
        let illegalSet = NSCharacterSet(charactersInString: lowerSet + upperSet + miscSet).invertedSet
        
        if (text.rangeOfCharacterFromSet(illegalSet) != nil) {
            return Validation.FailureReason.HAS_ILLEGAL
        }
        
        // Regex to test whether username is within bounds and character set
        // E.g. jared_123 or jaredtiala or j_tiala
        let regex = try! NSRegularExpression(pattern: "^[A-Za-z0-9_]{1,16}$", options: [])
        
        if (regex.firstMatchInString(text, options: [], range: NSMakeRange(0, text.utf8.count)) == nil) {
            return Validation.FailureReason.NO_MATCH
        }
        
        return nil
    }
    
    // Check username string and return cleaned string automatically
    static func sanitizeUsername(text: String) -> String {
        let lowerSet = "abcdefghijklmnopqrstuvwxyz"
        let upperSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let miscSet = "0123456789_"
        
        let illegalSet = NSCharacterSet(charactersInString: lowerSet + upperSet + miscSet).invertedSet
        
        return text
            .stringByTrimmingCharactersInSet(illegalSet)
            .lowercaseString
    }
    
    // Check password string and return failure on error
    static func validatePassword(text: String) -> FailureReason? {
        if (text.characters.count < 3) {
            return Validation.FailureReason.TOO_SHORT
        }
        
        let regex = try! NSRegularExpression(pattern: "^.*$", options: [])
        
        // Regex to test whether password fits in general character set
        if (regex.firstMatchInString(text, options: [], range: NSMakeRange(0, text.utf8.count)) == nil) {
            return Validation.FailureReason.NO_MATCH
        }
        
        return nil
    }
    
    // Check password string and return cleaned string automatically
    static func sanitizePassword(text: String) -> String {
        return text
            .stringByTrimmingCharactersInSet(NSCharacterSet.controlCharacterSet())
            .stringByTrimmingCharactersInSet(NSCharacterSet.illegalCharacterSet())
            .stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
            .stringByTrimmingCharactersInSet(NSCharacterSet.nonBaseCharacterSet())
    }
    
    // Check email string and return failure on error
    static func validateEmail(text: String) -> FailureReason? {
        if (text.characters.count > 254) {
            return Validation.FailureReason.TOO_LONG
        }
        
        if (text.characters.count < 6) {
            return Validation.FailureReason.TOO_SHORT
        }
        
        let lowerSet = "abcdefghijklmnopqrstuvwxyz"
        let upperSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numericSet = "0123456789"
        let miscSet = ".@!#$%&'*+-/=?^_`{|}~"
        
        let illegalSet = NSCharacterSet(charactersInString: lowerSet + upperSet + numericSet + miscSet).invertedSet
        
        if (text.rangeOfCharacterFromSet(illegalSet) != nil) {
            return Validation.FailureReason.HAS_ILLEGAL
        }
        
        if (text.rangeOfString("@") == nil) {
            return Validation.FailureReason.NO_DOMAIN
        }
        
        // Regex to test whether the email is formatted properly
        // E.g. asdasd@gmail.com or my@email.com
        // Ensures domain exists explicit
        let regex = try! NSRegularExpression(pattern: "^[\\w%+.-]+@[\\w%+.-]+\\.[A-Za-z.]{2,}$", options: [])
        
        if (regex.firstMatchInString(text, options: [], range: NSMakeRange(0, text.utf8.count)) == nil) {
            return Validation.FailureReason.NO_MATCH
        }
        
        return nil
    }
    
    // Check email string and return clean email automatically
    static func sanitizeEmail(text: String) -> String {
        let lowerSet = "abcdefghijklmnopqrstuvwxyz"
        let upperSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numericSet = "0123456789"
        let miscSet = ".@!#$%&'*+-/=?^_`{|}~"
        
        let illegalSet = NSCharacterSet(charactersInString: lowerSet + upperSet + numericSet + miscSet).invertedSet
        
        return text
            .trim()
            .stringByTrimmingCharactersInSet(illegalSet)
    }
    
    // Check session string and return failure on error
    static func validateSession(text: String) -> FailureReason? {
        if (text.characters.count > 64) {
            return Validation.FailureReason.TOO_LONG
        }
        
        if (text.characters.count < 64) {
            return Validation.FailureReason.TOO_SHORT
        }
        
        // Regex to test whether the session was fetched correctly
        // E.g. A long session string
        let regex = try! NSRegularExpression(pattern: "^[a-f\\d]{64}$", options: [])
        
        if (regex.firstMatchInString(text, options: [], range: NSMakeRange(0, text.utf8.count)) == nil) {
            return Validation.FailureReason.NO_MATCH
        }
        
        return nil
    }
    
    // Check JSON response string and return failure on error
    static func validateJSON(text: String) -> FailureReason? {
        if (text.characters.count < 3) {
            return Validation.FailureReason.TOO_SHORT
        }
        
        let regex = try! NSRegularExpression(pattern: "\\{.+\\}", options: [.DotMatchesLineSeparators])
        
        if (regex.firstMatchInString(text, options: [], range: NSMakeRange(0, text.utf8.count)) == nil) {
            return Validation.FailureReason.NO_MATCH
        }
        
        return nil
    }
    
    // Ensure string is number and return failure on error
    static func validateNumber(text: String) -> FailureReason? {
        if (text.characters.count > 32) {
            return Validation.FailureReason.TOO_LONG
        }
        
        // Regex to test whether the text is a number
        // E.g. 121 or 15.519
        let regex = try! NSRegularExpression(pattern: "^\\d+(?:\\.\\d+)?$", options: [.DotMatchesLineSeparators])
        
        if (regex.firstMatchInString(text, options: [], range: NSMakeRange(0, text.utf8.count)) == nil) {
            return Validation.FailureReason.NO_MATCH
        }
        
        return nil
    }
}
