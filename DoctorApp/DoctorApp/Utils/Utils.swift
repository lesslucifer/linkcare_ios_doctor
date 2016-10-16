//
//  Utils.swift
//  DoctorApp
//
//  Created by Salm on 4/28/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import GoogleMaterialIconFont
import Masonry

class Utils: NSObject {
    class func isEmpty(o: AnyObject?) -> Bool {
        if o == nil {
            return true
        }
        
        if let str = o as? String {
            return str.isEmpty
        }
        
        return false
    }
    
    class func isEmptyOrZero(num: NSNumber?) -> Bool {
        return num == nil || num!.intValue == 0
    }
    
    class func validField(clazz: AnyClass, map: Map, ignoredFields: Set<String> = [], required: [String] = []) -> Bool {
        let data = APIData(map.JSONDictionary)
        let properties = NSObject.propertyNames(clazz)
        for property in properties {
            if ignoredFields.contains(property) {
                continue
            }
            
            if !data.query(property).exists() {
                return false
            }
        }
        
        for reqField in required {
            if !data.query(reqField).exists() {
                return false
            }
        }
        
        return true
    }
    
    class func checkMap(map: Map, fields: String...) -> Bool {
        let data = APIData(map.JSONDictionary)
        for field in fields {
            if !data.query(field).exists() {
                return false
            }
        }
        
        return true
    }
    
    class func randomString(len : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0..<len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString as String
    }
    
    class func random(min: Double = 0, _ max: Double) -> Double {
        return min + Double(Float(arc4random()) / Float(UINT32_MAX)) * (max - min)
    }
    
    class func isValidEmail(testStr: String?) -> Bool {
        if let testStr = testStr {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluateWithObject(testStr)
        }
        
        return false
    }
    
    
    //MARK: Color
    class func UIColorFromRGB(red red: Int, green:Int, blue:Int) -> UIColor {
        return UIColor(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    //
    class func invokeLater(block: dispatch_block_t) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    class func later(block: dispatch_block_t) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    
    class func converTimetoHour(time: Int) -> Int {
        return (time - time%60) / 60
    }
    
    class func converTimetoMinute(time: Int) -> String {
        let minute = time%60
        if minute < 10 {
            return "0\(minute)"
        } else {
            return "\(minute)"
        }
    }
    
    class func converTimetoString(time: Int) -> String {
        return "\(converTimetoHour(time)):\(converTimetoMinute(time))"
    }
    
    class func converStringTimeToInt(stringTime: String) -> Int {
        let timeArr = stringTime.characters.split{$0 == ":"}.map(String.init)
        let hours = Int(timeArr[0])
        let minute = Int(timeArr[1])
        let intTime = hours! * 60 + minute!
        
        return intTime
    }
    
    class func getIdByTimes() -> Int {
        let currentDateTime = NSDate()
        
        return Int(currentDateTime.timeIntervalSince1970)
    }
    
    class var versionStr: String {
        let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String
//        let build = NSBundle.mainBundle().infoDictionary?[kCFBundleVersionKey as String] as! String
//        let versionStr = "\(version).\(build)"
        return version
    }
}


//MARK: Alert Helper
extension Utils {
    class func showOKAlertPanel(controller: UIViewController, title: String, msg: String, callback: ((UIAlertAction)->())? = nil) {
        let alert = UIAlertController(title:title, message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: callback))
        
        controller.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func showAlertWithError(error: String, delegate: UIAlertViewDelegate) {
        let v_alert: UIAlertView = UIAlertView(title: "", message: error, delegate: delegate, cancelButtonTitle: "Yes", otherButtonTitles: "No")
        v_alert.tag = 20000
        v_alert.show()
    }
}

//MARK: Date time helper
extension Utils {
    class func getNowTimestamp() -> Double {
        let currentDateTime = NSDate()
        
        return currentDateTime.timeIntervalSince1970
    }
    
    
    static func createFormatter(formatString: String) -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = formatString
        return formatter
    }
    
    static func createDateTransformer(formatter: NSDateFormatter) -> TransformOf<NSDate, String> {
        return TransformOf<NSDate, String>(fromJSON: { s in
            if Utils.isEmpty(s) {
                return nil
            }
            
            return formatter.dateFromString(s!)
            }, toJSON: { d in
                if Utils.isEmpty(d) {
                    return nil
                }
                
                return formatter.stringFromDate(d!)
        })
    }
    
    class func age(date: NSDate) -> Int {
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        return calendar.components(.Year,
                                   fromDate: date,
                                   toDate: now,
                                   options: []).year
    }
}

extension String {
    var emptyCheck: String? {
        if Utils.isEmpty(self) {
            return nil
        }
        
        return self
    }
    
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
            return from ..< to
        }
        return nil
    }
    
    func cutTail(tail: String) -> String {
        if self.hasSuffix(tail) {
            let endIndex = self.endIndex.advancedBy(-tail.characters.count)
            return self.substringToIndex(endIndex)
        }
        
        return self
    }
    
    func extractNameComps() -> (String, String, String) {
        var lastName = ""
        var midleName = ""
        var firstName = ""
        
        var comps = self.characters.split(" ")
        if comps.count == 0 {
            return (lastName, midleName, firstName)
        }
        
        if comps.count == 1 {
            firstName = String(comps[0])
            return (lastName, midleName, firstName)
        }
        
        lastName = String(comps.removeFirst())
        firstName = String(comps.removeLast())
        midleName = comps.map(String.init).joinWithSeparator(" ")
        return (lastName, midleName, firstName)
    }
    
    var trimmedString: String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}

extension CGRect {
    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5)
        
        self.init(origin: origin, size: size)
    }
    
    func setCenter(center: CGPoint) -> CGRect {
        return CGRect(center: center, size: size)
    }
    
    func setCenterX(centerX: CGFloat) -> CGRect {
        let x = centerX - size.width * 0.5
        
        return CGRect(x: x, y: origin.y, width: size.width, height: size.height)
    }
    
    func setTop(top: CGFloat) -> CGRect {
        return CGRect(x: origin.x, y: top, width: size.width, height: size.height)
    }
    
    func changeHeight(dHeight: CGFloat) -> CGRect {
        return CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height + dHeight)
    }
    
    func changeY(dY: CGFloat) -> CGRect {
        return CGRect(x: origin.x, y: origin.y + dY, width: size.width, height: size.height)
    }
    
    var bottom: CGFloat {
        return origin.y + size.height
    }
}

extension CollectionType {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class MaterialFontUIImageCache {
    class IconFont: AnyObject, Equatable, Hashable {
        var fontSize: Int = 32
        var name: MaterialIconFont = .Image
        
        init(size: CGFloat, name: MaterialIconFont) {
            self.fontSize = Int(size)
            self.name = name
        }
        
        var hashValue: Int {
            return fontSize * (2<<16) + name.hashValue
        }
    }
    
    static var images: [IconFont: UIImage] = [:]
}

func ==(lhs: MaterialFontUIImageCache.IconFont, rhs: MaterialFontUIImageCache.IconFont) -> Bool {
    return lhs.fontSize == rhs.fontSize && lhs.name == rhs.name
}

public extension UIImage {
    
    /// Get a FontAwesome image with the given icon name, text color, size and an optional background color.
    ///
    /// - parameter name: The preferred icon name.
    /// - parameter textColor: The text color.
    /// - parameter size: The image size.
    /// - parameter backgroundColor: The background color (optional).
    /// - returns: A string that will appear as icon with FontAwesome
    public static func materialFont(name: MaterialIconFont, textColor: UIColor, fontSize: CGFloat, backgroundColor: UIColor = UIColor.clearColor()) -> UIImage {
        let iconFont = MaterialFontUIImageCache.IconFont(size: fontSize, name: name)
        if let img = MaterialFontUIImageCache.images[iconFont] {
            return img
        }
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.Center
        
        let attributedString = NSAttributedString(string: String.materialIcon(name), attributes: [NSFontAttributeName: UIFont.materialIconOfSize(fontSize), NSForegroundColorAttributeName: textColor, NSBackgroundColorAttributeName: backgroundColor, NSParagraphStyleAttributeName: paragraph])
        UIGraphicsBeginImageContextWithOptions(CGSize(width: fontSize, height: fontSize), false , 0.0)
        attributedString.drawInRect(CGRectMake(0, 0, fontSize, fontSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        MaterialFontUIImageCache.images[iconFont] = image
        
        return image!
    }
}

extension UIViewController {
    func setNavigationTitle(title: String) {
        self.navigationController?.navigationBar.topItem?.title = title
    }
    
    func showPopup(popup: UIViewController, heightRatio: CGFloat = 0.6, widthRatio: CGFloat = 0.9) -> (UIView, UIViewController) {
        popup.willMoveToParentViewController(self)
        
        let overlay = UIView(frame: self.view.frame)
        overlay.backgroundColor = UIColor(colorLiteralRed: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        self.view.addSubview(overlay)
        overlay.mas_makeConstraints { make in
            make.edges.equalTo()(self.view)
        }
        
        popup.view.layer.cornerRadius = 20
        popup.view.layer.masksToBounds = true
        popup.view.layer.borderWidth = 1
        popup.view.layer.borderColor = LCColor.LightCyan.CGColor
        overlay.addSubview(popup.view)
        self.addChildViewController(popup)
        
        popup.view.mas_makeConstraints { make in
            make.centerX.equalTo()(overlay.mas_centerX)
            make.centerY.equalTo()(overlay.mas_centerY)
            make.width.equalTo()(overlay.mas_width).multipliedBy()(widthRatio)
            make.height.equalTo()(overlay.mas_height).multipliedBy()(heightRatio)
        }
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        popup.didMoveToParentViewController(self)
        
        return (overlay, popup)
    }
    
    func closePopup(popup: (UIView, UIViewController)) {
        popup.1.willMoveToParentViewController(nil)
        popup.0.removeFromSuperview()
        popup.1.removeFromParentViewController()
        popup.1.didMoveToParentViewController(nil)
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    var rootVC: UIViewController? {
        return UIApplication.sharedApplication().keyWindow?.rootViewController
    }
}

extension UINavigationController {
    func pushUniqueController<T: UIViewController>(type: T.Type, controller: T, animated: Bool = true) {
        if let index = self.viewControllers.indexOf({$0.isKindOfClass(type)}) {
            var newControllers = self.viewControllers
            newControllers.removeAtIndex(index)
            newControllers.append(controller)
            
            self.setViewControllers(newControllers, animated: animated)
        }
        else {
            self.pushViewController(controller, animated: animated)
        }
    }
}

extension Object {
    func write(block: ()->()) {
        if let r = self.realm {
            try! r.write(block)
        }
        else {
            block()
        }
    }
}

extension UIView {
    func addUnderline(weight: CGFloat = 1, color: UIColor, leftInset: CGFloat = -2, rightInset: CGFloat = 2, spacing: CGFloat = 1) {
        let line = UIView()
        line.backgroundColor = color;
        self.superview!.addSubview(line)
        line.mas_makeConstraints { make in
            make.height.equalTo()(weight)
            make.left.equalTo()(self.mas_left).valueOffset()(leftInset)
            make.right.equalTo()(self.mas_right).valueOffset()(-rightInset)
            make.top.equalTo()(self.mas_bottom).valueOffset()(spacing)
        }
    }
    
    func dismissKeyboardOnTap(var target: UIView? = nil) {
        if (target == nil) {
            target = self
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: target!, action: #selector(UIView._doDismissKeyboard))
        self.addGestureRecognizer(tap)
    }
    
    func _doDismissKeyboard() {
        self.endEditing(true)
    }
}

extension UIButton {
    func linkcarelize(border: Bool = true) {
        self.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
        self.setTitleColor(LCColor.LightCyan, forState: .Normal)
        self.setTitle(self.titleForState(.Normal)?.uppercaseString, forState: .Normal)
        
        if (border) {
            self.layer.borderColor = LCColor.LightCyan.CGColor
            self.layer.borderWidth = 0.8
            self.layer.cornerRadius = self.frame.height / 2
        }
    }
}
