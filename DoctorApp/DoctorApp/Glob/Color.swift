//
//  Color.swift
//  PatientApp
//
//  Created by Salm on 5/22/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexString: String, alpha:CGFloat? = 1.0) {
        // Convert hex string to an integer
        let hexint = Int(UIColor.intFromHexString(hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        // Create color object, specifying alpha as well
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    class func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: NSScanner = NSScanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersInString: "#")
        // Scan hex value
        scanner.scanHexInt(&hexInt)
        return hexInt
    }
}

class LCColor {
    static let LightCyanHex = "30A4C4"
    static let LightCyan = UIColor(hexString: LightCyanHex)
    static let DarkGreen = UIColor(hexString: "0055AF")
    static let DarkOrange = UIColor(hexString: "FF8021")
    static let WeakCyan = UIColor(hexString: "EAF2F4")
}