//
//  Extensions.swift
//  teeline-app
//

import UIKit
import CryptoSwift

// Add defaults to UIFont to prevent redundant code
extension UIFont {
    
    static func system() -> UIFont {
        return UIFont.systemFontOfSize(17)
    }
    
    static func systemBold() -> UIFont {
        return UIFont.boldSystemFontOfSize(22)
    }
    
    static func systemItalic() -> UIFont {
        return UIFont.italicSystemFontOfSize(17)
    }
}

// Add extra utility functions to the string class
extension String {
    
    // Remove whitespace from the current string object
    // I.e. "   Jared " becomes "Jared"
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    // Returns a secure SHA-256 hash for a specific string
    func secureHash() -> String {
        return self.sha256()
    }
}

extension UIColor {
    
    // Convert a hexadecimal string to a corresponding color
    convenience init(hexadecimal: String) {
        let hexadecimalCast = hexadecimal as NSString
        
        let red = hexadecimalCast.substringToIndex(2)
        let green = (hexadecimalCast.substringFromIndex(2) as NSString).substringToIndex(2)
        let blue = (hexadecimalCast.substringFromIndex(4) as NSString).substringToIndex(2)
        
        var redValue: CUnsignedInt = 0
        var greenValue: CUnsignedInt = 0
        var blueValue: CUnsignedInt = 0
        
        // Read the value of the rgb as an integer representation
        NSScanner(string: red).scanHexInt(&redValue)
        NSScanner(string: green).scanHexInt(&greenValue)
        NSScanner(string: blue).scanHexInt(&blueValue)
        
        // Init a new color from the values
        self.init(
            red: CGFloat(redValue) / CGFloat(255),
            green: CGFloat(greenValue) / CGFloat(255),
            blue: CGFloat(blueValue) / CGFloat(255),
            alpha: 1
        )
    }
    
    static func indexColor(index: Int) -> UIColor {
        // Return a random color based on an index
        let colors = [
            UIColor.redColorE(),
            UIColor.blueColorE(),
            UIColor.greenColorE(),
            UIColor.yellowColorE(),
            UIColor.orangeColorE(),
            UIColor.turquoiseColorE(),
            UIColor.purpleColorE()
        ]
        
        return colors[index]
    }
    
    // Color definition start
    static func pureWhite() -> UIColor {
        return UIColor(hexadecimal: "ffffff")
    }
    
    static func pureBlack() -> UIColor {
        return UIColor(hexadecimal: "000000")
    }
    
    static func turquoiseColorE() -> UIColor {
        return UIColor(hexadecimal: "1abc9c")
    }
    
    static func darkTurquoiseColorE() -> UIColor {
        return UIColor(hexadecimal: "16a085")
    }
    
    static func greenColorE() -> UIColor {
        return UIColor(hexadecimal: "2ecc71")
    }
    
    static func darkGreenColorE() -> UIColor {
        return UIColor(hexadecimal: "27ae60")
    }
    
    static func blueColorE() -> UIColor {
        return UIColor(hexadecimal: "3498db")
    }
    
    static func darkBlueColorE() -> UIColor {
        return UIColor(hexadecimal: "2980b9")
    }
    
    static func purpleColorE() -> UIColor {
        return UIColor(hexadecimal: "9b59b6")
    }
    
    static func darkPurpleColorE() -> UIColor {
        return UIColor(hexadecimal: "8e44ad")
    }
    
    static func blackColorE() -> UIColor {
        return UIColor(hexadecimal: "34495e")
    }
    
    static func darkBlackColorE() -> UIColor {
        return UIColor(hexadecimal: "2c3e50")
    }
    
    static func yellowColorE() -> UIColor {
        return UIColor(hexadecimal: "f1c40f")
    }
    
    static func darkYellowColorE() -> UIColor {
        return UIColor(hexadecimal: "f39c12")
    }
    
    static func orangeColorE() -> UIColor {
        return UIColor(hexadecimal: "e67e22")
    }
    
    static func darkOrangeColorE() -> UIColor {
        return UIColor(hexadecimal: "d35400")
    }
    
    static func redColorE() -> UIColor {
        return UIColor(hexadecimal: "e74c3c")
    }
    
    static func darkRedColorE() -> UIColor {
        return UIColor(hexadecimal: "c0392b")
    }
    
    static func whiteColorE() -> UIColor {
        return UIColor(hexadecimal: "ecf0f1")
    }
    
    static func darkWhiteColorE() -> UIColor {
        return UIColor(hexadecimal: "bdc3c7")
    }
    
    static func grayColorE() -> UIColor {
        return UIColor(hexadecimal: "95a5a6")
    }
    
    static func darkGrayColorE() -> UIColor {
        return UIColor(hexadecimal: "7f8c8d")
    }
    // Color definition end
}
