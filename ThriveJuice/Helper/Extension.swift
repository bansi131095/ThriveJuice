//
//  Extension.swift
//  Easy Homes Realty
//
//  Created by My Mac on 5/1/17.
//  Copyright © 2017 ciestosolutions. All rights reserved.
//

import Photos
import MBProgressHUD
import AVFoundation
import CoreLocation

// Bullets : \u{2022}

var category:String = String()
var sub_category:String = String()

var bundleKey: UInt8 = 0

class AnyLanguageBundle: Bundle {
    
    override func localizedString(forKey key: String,
                                  value: String?,
                                  table tableName: String?) -> String {
        
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
              let bundle = Bundle(path: path) else {
            
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension CLLocation {
    
    
    func getRadiansFrom(degrees: Double ) -> Double {
        
        return degrees * .pi / 180
        
    }
    
    func getDegreesFrom(radians: Double) -> Double {
        
        return radians * 180 / .pi
        
    }
    
    func bearingRadianTo(location: CLLocation) -> Double {
        
        let lat1 = self.getRadiansFrom(degrees: self.coordinate.latitude)
        let lon1 = self.getRadiansFrom(degrees: self.coordinate.longitude)
        
        let lat2 = self.getRadiansFrom(degrees: location.coordinate.latitude)
        let lon2 = self.getRadiansFrom(degrees: location.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        
        var radiansBearing = atan2(y, x)
        
        if radiansBearing < 0.0 {
            
            radiansBearing += 2 * .pi
            
        }
        
        
        return radiansBearing
    }
    
    func bearingDegreesTo(location: CLLocation) -> Double {
        
        return self.getDegreesFrom(radians: self.bearingRadianTo(location: location))
        
    }
    
}

extension CLLocationCoordinate2D {
    
    func bearing(to point: CLLocationCoordinate2D) -> Double {
        func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
        func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }
        
        let lat1 = degreesToRadians(latitude)
        let lon1 = degreesToRadians(longitude)
        
        let lat2 = degreesToRadians(point.latitude);
        let lon2 = degreesToRadians(point.longitude);
        
        let dLon = lon2 - lon1;
        
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x);
        let degree = radiansToDegrees(radiansBearing)
        return (degree >= 0) ? degree : (360 + degree)
    }
    
}

extension Bundle {
    
    class func setLanguage(_ language: String) {
        
        defer {
            
            object_setClass(Bundle.main, AnyLanguageBundle.self)
        }
        
        objc_setAssociatedObject(Bundle.main, &bundleKey,    Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
}

extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}

public extension UIResponder {
    
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc private func _trap() {
        Static.responder = self
    }
}

extension String {
    
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: Returns percent-escaped string.
    
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
    //    var html2AttributedString: NSAttributedString? {
    //        do {
    //            return try NSAttributedString(data: Data(utf8), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
    //        } catch {
    //            print("error:", error)
    //            return nil
    //        }
    //    }
    //    var html2String: String {
    //        return html2AttributedString?.string ?? ""
    //    }
    //    
}

fileprivate var __maxLengths = [UITextField: Int]()
//fileprivate var __minLengths = [UITextField: Int]()
extension UITextField
{
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
    
    @IBInspectable var padding_left: CGFloat
    {
        get {
            //LF.log("WARNING no getter for UITextField.padding_left")
            return 0
        }
        set (f) {
            layer.sublayerTransform = CATransform3DMakeTranslation(f, 0, 0)
        }
    }
    @IBInspectable var paddingRightCustom: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
    
    @IBInspectable var placeholderColor: UIColor {
        get {
            return self.attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .lightText
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor: newValue])
        }
    }
    
    func AddDashLine(strokeColor: UIColor, lineWidth: CGFloat) {
        backgroundColor = .clear
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DashedTopLine"
        shapeLayer.bounds = bounds
        shapeLayer.frame = CGRect(x: 0, y: self.frame.size.height - lineWidth, width:  self.frame.size.width, height: self.frame.size.height)
        //        shapeLayer.position = CGPoint(x:frame.height, y: 40)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [4, 4]
        
        let path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x:frame.width, y: 0))
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
    
    /*@IBDesignable
     class FormTextField: UITextField {
     
     @IBInspectable var paddingLeft: CGFloat = 0
     @IBInspectable var paddingRight: CGFloat = 0
     
     override func textRect(forBounds bounds: CGRect) -> CGRect {
     return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y, width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height)
     }
     
     override func editingRect(forBounds bounds: CGRect) -> CGRect {
     return textRect(forBounds: bounds)
     }
     }*/
    
}

extension UITextView
{
    @IBInspectable var padding_left: CGFloat
    {
        get {
            //LF.log("WARNING no getter for UITextField.padding_left")
            return 0
        }
        set (f) {
            self.layer.sublayerTransform = CATransform3DMakeTranslation(f, 0, 0)
        }
    }
    
}

extension UITableView {
    
    func indicatorView() -> UIActivityIndicatorView{
        var activityIndicatorView = UIActivityIndicatorView()
        if self.tableFooterView == nil{
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 40)
            activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            activityIndicatorView.isHidden = false
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            activityIndicatorView.isHidden = true
            self.tableFooterView = activityIndicatorView
            return activityIndicatorView
        }else{
            return activityIndicatorView
        }
    }
    
    func addLoading(_ indexPath:IndexPath, closure: @escaping (() -> Void)){
        indicatorView().startAnimating()
        if let lastVisibleIndexPath = self.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath && indexPath.row == self.numberOfRows(inSection: 0) - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    closure()
                }
            }
        }
        indicatorView().isHidden = false
    }
    
    func stopLoading(){
        indicatorView().stopAnimating()
        indicatorView().isHidden = true
    }
}

extension Bundle {
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version : String = dictionary["CFBundleName"] as? String {
            return version
        } else {
            return ""
        }
    }
}

extension UILabel
{
    func halfTextColorChange (fullText : String , changeText : String ,color:UIColor) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        self.attributedText = attribute
    }
    
    func heightForLabel(text:String, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
    
}

extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: Double(size.width), height: Double(size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension Array where Element: Hashable {
    func differences(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        let c = self
        if (c.count <= n ) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
    
    //    func isValidEmail() -> Bool {
    //        // here, `try!` will always succeed because the pattern is valid
    //        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
    //        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) != nil
    //    }
    /*
    var isValidEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
    */
    func isValidEmail() -> Bool {
              // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,3})$", options: .caseInsensitive)
        let valid = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        print("Email validation \(valid)")
        return valid
    }

    // vrify Valid PhoneNumber or Not
    func isValidPhone() -> Bool {

        let regex = try! NSRegularExpression(pattern: "^[0-9]\\d{9}$", options: .caseInsensitive)
        let valid = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        print("Mobile validation \(valid)")
        return valid
    }
    
    func encodeUrl() -> String?
    {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    func decodeUrl() -> String?
    {
        let result = self.replacingOccurrences(of: "+", with: " ")
        return result.removingPercentEncoding
    }
    
}

extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String
    {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
    
}

extension UIImageView
{
    public func imageFromServerURL(urlString: String)
    {
        //        self.activityIndicatorView.startAnimating()
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error!)
                //                self.activityIndicatorView.stopAnimating()
                self.image = UIImage(named: "img.jpg")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                if(image == nil) {
                    //                    self.activityIndicatorView.stopAnimating()
                    self.image = UIImage(named: "img.jpg")
                } else {
                    //                    self.activityIndicatorView.stopAnimating()
                    self.image = image
                }
            })
        }).resume()
    }
    
    public func imageFromServerURL(urlString: String,PlaceHolder: UIImage)
    {
        //        self.activityIndicatorView.startAnimating()
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error!)
                //                self.activityIndicatorView.stopAnimating()
                self.image = PlaceHolder
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                if(image == nil) {
                    //                    self.activityIndicatorView.stopAnimating()
                    self.image = PlaceHolder
                } else {
                    //                    self.activityIndicatorView.stopAnimating()
                    self.image = image
                }
            })
        }).resume()
    }
}

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
    public class func gifImageWithData(data: NSData) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            print("image doesn't exist")
            return nil
        }
        return UIImage.animatedImageWithSource(source: source)
    }
    
    public class func gifImageWithURL(gifUrl:String) -> UIImage? {
        guard let bundleURL = NSURL(string: gifUrl)
        else {
            print("image named \"\(gifUrl)\" doesn't exist")
            return nil
        }
        guard let imageData = NSData(contentsOf: bundleURL as URL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        return gifImageWithData(data: imageData)
    }
    
    public class func gifImageWithName(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
                .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }
        guard let imageData = NSData(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        return gifImageWithData(data: imageData)
    }
    
    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(CFDictionaryGetValue(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
        
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a! < b! {
            let c = a!
            a = b!
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b!
                b = rest
            }
        }
    }
    
    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(a: val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(index: Int(i), source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(array: delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
        
        return animation
    }
    
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data {
        let bytes = kb * 1024
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.05
        var holderImage = self
        var complete = false
        while(!complete) {
            if let data = holderImage.jpegData(compressionQuality: 1.0) {
                let ratio = data.count / bytes
                if data.count < Int(CGFloat(bytes) * (1 + allowedMargin)) {
                    complete = true
                    return data
                } else {
                    let multiplier:CGFloat = CGFloat((ratio / 5) + 1)
                    compression -= (step * multiplier)
                }
            }
            
            guard let newImage = holderImage.resized(withPercentage: compression) else { break }
            holderImage = newImage
        }
        return Data()
    }
}

extension PHAsset
{
    
    var originalFilename: String?
    {
        
        var fname:String?
        
        if #available(iOS 9.0, *)
        {
            let resources = PHAssetResource.assetResources(for: self)
            if let resource = resources.first {
                fname = resource.originalFilename
            }
        }
        
        if fname == nil {
            // this is an undocumented workaround that works as of iOS 9.1
            fname = self.value(forKey: "filename") as? String
        }
        
        return fname
    }
}

extension String
{
    var isAlpha: Bool
    {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    var isnumeric: Bool
    {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
    
    var htmlToAttributedString: NSMutableAttributedString?
    {
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            guard let attributedString = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            else {
                return .init(string: "Invalid content")
            }
            let range = NSRange(location: 0, length: attributedString.length)
            
            attributedString.enumerateAttribute(.font, in: range) { value, range, pointer in
                guard let currentFont = value as? UIFont else { return }
                
                let isBold = currentFont.fontName.lowercased().contains("bold")
                let replacementFont = UIFont(name: isBold ? "Jost Bold" : "Jost Regular", size: 15.0)
                
                let replacementAttribute = [NSAttributedString.Key.font: replacementFont]
                attributedString.addAttributes(replacementAttribute, range: range)
            }
            
            return attributedString
        } catch {
            return NSMutableAttributedString()
        }
                    
        
    }
    var htmlToString: String
    {
        return htmlToAttributedString?.string ?? ""
    }
    
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        
        if vc.isKind(of: UINavigationController.self) {
            
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
            
        } else if vc.isKind(of: UITabBarController.self) {
            
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
            
        } else {
            
            if let presentedViewController = vc.presentedViewController {
                
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController.presentedViewController!)
                
            } else {
                
                return vc;
            }
        }
    }
}

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
}



extension UIViewController
{
    
    func SetSwip_Gesture() {
        self.view.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(self.Swip_PopVC)))
    }
    
    @objc func Swip_PopVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    public func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    //    MARK:-    SHOW ALERT WITH ACTION
    
    func showPopup(withTitle: String = "", message: String, okClicked: @escaping () -> ()){
        let alert  = UIAlertController.init(title: withTitle, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK" , style: .default) { (action) in
            okClicked()
        }
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Alert with two Buttons'
    
    
    func showPopupTwoBtn(withTitle: String, message: String, okClicked: @escaping () -> ()){
        let alert  = UIAlertController.init(title: withTitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "YES", style: .default) { (action) in
            okClicked()
        }
        let cancelAction = UIAlertAction.init(title: "CANCEL", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func showActionSheet(withTitle: String = "", message: String, FirstBtn: String, secondBtn: String, FirstAction: @escaping () -> (), SecondAction: @escaping () -> ()){
        let alert  = UIAlertController.init(title: withTitle, message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction.init(title: FirstBtn, style: .default) { (action) in
            FirstAction()
        }
        
        let DeleteAction = UIAlertAction.init(title: secondBtn, style: .default) { (action) in
            SecondAction()
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.addAction(DeleteAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertwithOptions (Title: String?, optionTitle:String,cancelTitle:String,message:String,completion:@escaping (Bool) -> Void) {
        guard let viewController = self as? UIViewController else {
            return
        }
        let alert: UIAlertController = UIAlertController(title: Title,
                                                         message: message,
                                                         preferredStyle: .alert)
        let yesAction = UIAlertAction(title: optionTitle, style: .default) { (alert) in
            completion(true)
        }
        let noAction = UIAlertAction(title: cancelTitle, style: .default) { (alert) in
            completion(false)
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    func validatePassword(password: String?, complition: @escaping(String, Bool) -> ()) {
        var errorMsg = ""
        
        if let txt = password {
            if (txt.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil) {
                errorMsg += "Password requires at least one upper case letter"
            }
            if (txt.rangeOfCharacter(from: CharacterSet.lowercaseLetters) == nil) {
                errorMsg += ", one lower case letter"
            }
            if (txt.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil) {
                errorMsg += ", one number"
            }
            if txt.count < 8 {
                errorMsg += ", and eight characters"
            }
        }
        if errorMsg != "" {
            complition(errorMsg, true)
        } else {
            complition(errorMsg, false)
        }
    }
    
    //MARK:- Function
    func text_changes(lbl: UILabel, lbl_line: UILabel, active:Bool) {
        if active {
            lbl.textColor = #colorLiteral(red: 0.6588235294, green: 0.1254901961, blue: 0.2509803922, alpha: 1)
            lbl_line.backgroundColor = #colorLiteral(red: 0.6588235294, green: 0.1254901961, blue: 0.2509803922, alpha: 1)
        } else {
            lbl.textColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
            lbl_line.backgroundColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
        }
    }
    
    func add(stringList: [String],
             font: UIFont,
             bullet: String = "\u{2022}",
             indentation: CGFloat = 20,
             lineSpacing: CGFloat = 2,
             paragraphSpacing: CGFloat = 12,
             textColor: UIColor = #colorLiteral(red: 0.3450980392, green: 0.3450980392, blue: 0.3450980392, alpha: 1),
             bulletColor: UIColor = #colorLiteral(red: 0.6589999795, green: 0.125, blue: 0.2509999871, alpha: 1)) -> NSAttributedString {
        
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
        let bulletAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: bulletColor]
        
        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        //paragraphStyle.firstLineHeadIndent = 0
        //paragraphStyle.headIndent = 20
        //paragraphStyle.tailIndent = 1
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation
        
        let bulletList = NSMutableAttributedString()
        for string in stringList {
            let formattedString = "\(bullet)\t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)
            
            attributedString.addAttributes(
                [NSAttributedString.Key.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))
            
            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))
            
            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }
        
        return bulletList
    }
    /*
    func changeRootViewController(rootViewIdentifier : String, storyBoardTitle:String)
    {
        let mainStoryBoard = UIStoryboard(name: storyBoardTitle, bundle: nil)
        let rootViewController = mainStoryBoard.instantiateViewController(withIdentifier: rootViewIdentifier)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootViewController
    }
     */
    
    func show_alert(msg:String)
    {
        let alertController = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Alert method
    
    func showAlertToast(message:String)
    {
        // the alert view
        let alert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
        self.present(alert, animated: true)
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func alertWithImage(title: String, Msg: String)
    {
       let alert = UIAlertController(title: title, message: Msg, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default, handler: nil)

        let imgTitle = UIImage(named:"Alert")
        let imgViewTitle = UIImageView(frame: CGRect(x: 100, y: 10, width: 30, height: 30))
        imgViewTitle.image = imgTitle

        alert.view.addSubview(imgViewTitle)
        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showProgressBar()
    {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //hud.label.text = message
        hud.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        hud.isUserInteractionEnabled = true
    }
    
    func hideProgressBar()
    {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    //MARK:- Color Function
    func UIColorFromRGB(_ rgbValue: UInt) -> UIColor
    {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var fourDigitNumber: String {
        var result = ""
        repeat {
            // Create a string with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
        } while Set<Character>(result).count < 4
        return result
    }
    
    struct State {
        let name: String
        let long: CLLocationDegrees
        let lat: CLLocationDegrees
    }
    
    func maskMobileNumber(_ number: String) -> String {
        let digitCount = number.count
        let startIndex = number.index(number.startIndex, offsetBy: 2)
        let endIndex = number.index(number.endIndex, offsetBy: -2)
        let maskedRange = startIndex..<endIndex

        let maskedDigits = String(repeating: "*", count: digitCount - 4)
        let maskedNumber = number.replacingCharacters(in: maskedRange, with: maskedDigits)

        return maskedNumber
    }
    
}

extension CALayer {

    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

        let border = CALayer()

        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: UIScreen.main.bounds.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }

        border.backgroundColor = color.cgColor;

        self.addSublayer(border)
    }

}


fileprivate var ActivityIndicatorViewAssociativeKey = "ActivityIndicatorViewAssociativeKey"
//MARK: - UIView

extension UIView
{
    
    //    func showProgressBarr()
    //    {
    //        let hud = MBProgressHUD.showAdded(to: self, animated: true)
    //        //hud.label.text = message
    //        hud.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    //        hud.isUserInteractionEnabled = true
    //    }
    //
    //    func hideProgressBarr()
    //    {
    //        MBProgressHUD.hide(for: self, animated: true)
    //    }
    //
    //    func showHud()
    //    {
    //        let HUD = MBProgressHUD.showAdded(to: self, animated: true)
    ////        HUD.bezelView.color = UIColor.clear
    //        let imageViewAnimatedGif = UIImageView()
    //        //The key here is to save the GIF file or URL download directly into a NSData instead of making it a UIImage. Bypassing UIImage will let the GIF file keep the animation.
    //        let filePath: String? = Bundle.main.path(forResource: "loader", ofType: "gif")
    //        let gifData = NSData(contentsOfFile: filePath ?? "") as Data?
    //        imageViewAnimatedGif.image = UIImage.gifImageWithData(data: gifData! as NSData)
    //        HUD.customView = UIImageView(image: imageViewAnimatedGif.image)
    //        let btn = UIButton()
    //        btn.setTitle(Localization("Cancel"), for: .normal)
    //        btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
    //        btn.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    //        btn.addTarget(self, action: #selector(data), for: .touchUpInside)
    //        HUD.customView = btn
    //        HUD.mode = .customView
    //        HUD.customView?.backgroundColor = UIColor.clear
    //        //        HUD.backgroundColor = UIColor.white
    //        //        HUD.alpha = 0.5
    ////        HUD.label.text = "Data"
    ////        HUD.button.setTitle("CANCEL", for: .normal)
    ////        HUD.button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
    ////        HUD.button.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    //        HUD.show(animated: true)
    //    }
    
    @objc func data()  {
        print("Datat")
    }
    /*
     func showHud()
     {
     let HUD = MBProgressHUD.showAdded(to: self, animated: true)
     HUD.bezelView.color = UIColor.clear
     let imageViewAnimatedGif = UIImageView()
     //The key here is to save the GIF file or URL download directly into a NSData instead of making it a UIImage. Bypassing UIImage will let the GIF file keep the animation.
     let custom = UIView(frame: CGRect(x: (UIScreen.main.bounds.width/2)-100, y: (UIScreen.main.bounds.height/2)-100, width: 200, height: 200))
     let filePath: String? = Bundle.main.path(forResource: "loader", ofType: "gif")
     let gifData = NSData(contentsOfFile: filePath ?? "") as Data?
     imageViewAnimatedGif.image = UIImage.gifImageWithData(data: gifData! as NSData)
     let img = UIImageView(image: imageViewAnimatedGif.image)
     custom.addSubview(img)
     let btn = UIButton.init(frame: CGRect(x: 0, y: custom.frame.height-30, width: 200, height: 30))
     btn.setTitle("CANCEL", for: .normal)
     btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
     btn.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
     custom.addSubview(btn)
     HUD.customView = custom
     HUD.mode = .customView
     HUD.customView?.backgroundColor = UIColor.clear
     //        HUD.backgroundColor = UIColor.white
     //        HUD.alpha = 0.5
     HUD.show(animated: true)
     }
     */
    
    //    func hideHud()
    //    {
    //        MBProgressHUD.hide(for: self, animated: true)
    //    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func addDashedLine(strokeColor: UIColor, lineWidth: CGFloat) {
        backgroundColor = .clear
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DashedTopLine"
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x:30, y: 40)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [4, 4]
        
        let path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x:500, y: 0))
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    @IBInspectable
    var cornerRadius: CGFloat
    {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat
    {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor?
    {
        get
        {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set
        {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat
    {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = shadowRadius
        }
    }
    
    func vw_corner_radius(radius:CGFloat)
    {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func vw_set_border(width:CGFloat,color:UIColor)
    {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    var activityIndicatorView: UIActivityIndicatorView
    {
        get
        {
            if let activityIndicatorView = getAssociatedObject(&ActivityIndicatorViewAssociativeKey) as? UIActivityIndicatorView
            {
                return activityIndicatorView
            }
            else
            {
                let activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                activityIndicatorView.style = .gray
                activityIndicatorView.color = .black
                activityIndicatorView.center = center
                activityIndicatorView.hidesWhenStopped = true
                addSubview(activityIndicatorView)
                
                setAssociatedObject(activityIndicatorView, associativeKey: &ActivityIndicatorViewAssociativeKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return activityIndicatorView
            }
        }
        
        set
        {
            addSubview(newValue)
            setAssociatedObject(newValue, associativeKey:&ActivityIndicatorViewAssociativeKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    
}

extension Date {
    static func getDates(forLastNDays nDays: Int) -> [String] {
        let cal = NSCalendar.current
        // start with today
        var date = cal.startOfDay(for: Date())

        var arrDates = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        arrDates.append(dateString)
        
        for _ in 1 ... nDays {
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day, value: 1, to: date)!
            
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        print(arrDates)
        return arrDates
    }
}

extension UIView {
    func addDashedBorder() {
        let color = #colorLiteral(red: 0.6823529412, green: 0.7647058824, blue: 1, alpha: 1).cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}

public extension NSObject
{
    func setAssociatedObject(_ value: AnyObject?, associativeKey: UnsafeRawPointer, policy: objc_AssociationPolicy)
    {
        if let valueAsAnyObject = value
        {
            objc_setAssociatedObject(self, associativeKey, valueAsAnyObject, policy)
        }
    }
    
    func getAssociatedObject(_ associativeKey: UnsafeRawPointer) -> Any?
    {
        guard let valueAsType = objc_getAssociatedObject(self, associativeKey)
        else
        {
            return nil
        }
        return valueAsType
    }
}

import UIKit

class Extension: NSObject
{
    
    
}

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        //        context.drawLinearGradient(gradient,
        //                                   start: startPoint,
        //                                   end: endPoint,
        //                                   options: [])
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsAfterEndLocation)
    }
}


class DashedBorderView: UIView {
    
    //    @IBInspectable var cornerRadius: CGFloat = 4
    //    @IBInspectable var borderColor: UIColor = UIColor.black
    @IBInspectable var dashPaintedSize: Int = 2
    @IBInspectable var dashUnpaintedSize: Int = 2
    
    let dashedBorder = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        //custom initialization
        self.layer.addSublayer(dashedBorder)
        applyDashBorder()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        applyDashBorder()
    }
    
    func applyDashBorder() {
        dashedBorder.strokeColor = borderColor?.cgColor
        dashedBorder.lineDashPattern = [NSNumber(value: dashPaintedSize), NSNumber(value: dashUnpaintedSize)]
        dashedBorder.fillColor = nil
        dashedBorder.cornerRadius = cornerRadius
        dashedBorder.path = UIBezierPath(rect: self.bounds).cgPath
        dashedBorder.frame = self.bounds
    }
}


class LoadMoreActivityIndicator {
    
    private let spacingFromLastCell: CGFloat
    private let spacingFromLastCellWhenLoadMoreActionStart: CGFloat
    private weak var activityIndicatorView: UIActivityIndicatorView?
    private weak var scrollView: UIScrollView?
    
    private var defaultY: CGFloat {
        guard let height = scrollView?.contentSize.height else { return 0.0 }
        return height + spacingFromLastCell
    }
    
    deinit { activityIndicatorView?.removeFromSuperview() }
    
    init (scrollView: UIScrollView, spacingFromLastCell: CGFloat, spacingFromLastCellWhenLoadMoreActionStart: CGFloat) {
        self.scrollView = scrollView
        self.spacingFromLastCell = spacingFromLastCell
        self.spacingFromLastCellWhenLoadMoreActionStart = spacingFromLastCellWhenLoadMoreActionStart
        let size:CGFloat = 40
        let frame = CGRect(x: (scrollView.frame.width-size)/2, y: scrollView.contentSize.height + spacingFromLastCell, width: size, height: size)
        let activityIndicatorView = UIActivityIndicatorView(frame: frame)
        if #available(iOS 13.0, *)
        {
            activityIndicatorView.color = .label
        }
        else
        {
            activityIndicatorView.color = .black
        }
        activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        activityIndicatorView.hidesWhenStopped = true
        scrollView.addSubview(activityIndicatorView)
        self.activityIndicatorView = activityIndicatorView
    }
    
    private var isHidden: Bool {
        guard let scrollView = scrollView else { return true }
        return scrollView.contentSize.height < scrollView.frame.size.height
    }
    
    func start(closure: (() -> Void)?) {
        guard let scrollView = scrollView, let activityIndicatorView = activityIndicatorView else { return }
        let offsetY = scrollView.contentOffset.y
        activityIndicatorView.isHidden = isHidden
        if !isHidden && offsetY >= 0 {
            let contentDelta = scrollView.contentSize.height - scrollView.frame.size.height
            let offsetDelta = offsetY - contentDelta
            
            let newY = defaultY-offsetDelta
            if newY < scrollView.frame.height {
                activityIndicatorView.frame.origin.y = newY
            } else {
                if activityIndicatorView.frame.origin.y != defaultY {
                    activityIndicatorView.frame.origin.y = defaultY
                }
            }
            
            if !activityIndicatorView.isAnimating {
                if offsetY > contentDelta && offsetDelta >= spacingFromLastCellWhenLoadMoreActionStart && !activityIndicatorView.isAnimating {
                    activityIndicatorView.startAnimating()
                    closure?()
                }
            }
            
            if scrollView.isDecelerating {
                if activityIndicatorView.isAnimating && scrollView.contentInset.bottom == 0 {
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        if let bottom = self?.spacingFromLastCellWhenLoadMoreActionStart {
                            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
                        }
                    }
                }
            }
        }
    }
    
    func stop(completion: (() -> Void)? = nil) {
        guard let scrollView = scrollView , let activityIndicatorView = activityIndicatorView else { return }
        let contentDelta = scrollView.contentSize.height - scrollView.frame.size.height
        let offsetDelta = scrollView.contentOffset.y - contentDelta
        if offsetDelta >= 0 {
            UIView.animate(withDuration: 0.3, animations: {
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }) { _ in completion?() }
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            completion?()
        }
        activityIndicatorView.stopAnimating()
    }
}

class RefreshControl: UIRefreshControl {
    
    private weak var actionTarget: AnyObject?
    private var actionSelector: Selector?
    override init() { super.init() }
    
    convenience init(actionTarget: AnyObject?, actionSelector: Selector) {
        self.init()
        self.actionTarget = actionTarget
        self.actionSelector = actionSelector
        addTarget()
    }
    
    private func addTarget() {
        guard let actionTarget = actionTarget, let actionSelector = actionSelector else { return }
        addTarget(actionTarget, action: actionSelector, for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    func endRefreshing(deadline: DispatchTime? = nil) {
        guard let deadline = deadline else { endRefreshing(); return }
        DispatchQueue.global(qos: .default).asyncAfter(deadline: deadline) { [weak self] in
            DispatchQueue.main.async { self?.endRefreshing() }
        }
    }
    
    func refreshActivityIndicatorView() {
        guard let selector = actionSelector else { return }
        let _isRefreshing = isRefreshing
        removeTarget(actionTarget, action: selector, for: .valueChanged)
        endRefreshing()
        if _isRefreshing { beginRefreshing() }
        addTarget()
    }
    
    func generateRefreshEvent() {
        beginRefreshing()
        sendActions(for: .valueChanged)
    }
}

public extension UIScrollView {
    
    private var _refreshControl: RefreshControl? { return refreshControl as? RefreshControl }
    
    func addRefreshControll(actionTarget: AnyObject?, action: Selector, replaceIfExist: Bool = false) {
        if !replaceIfExist && refreshControl != nil { return }
        refreshControl = RefreshControl(actionTarget: actionTarget, actionSelector: action)
    }
    
    func scrollToTopAndShowRunningRefreshControl(changeContentOffsetWithAnimation: Bool = false) {
        _refreshControl?.refreshActivityIndicatorView()
        guard   let refreshControl = refreshControl,
                contentOffset.y != -refreshControl.frame.height else { return }
        setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.height), animated: changeContentOffsetWithAnimation)
    }
    
    private var canStartRefreshing: Bool {
        guard let refreshControl = refreshControl, !refreshControl.isRefreshing else { return false }
        return true
    }
    
    func startRefreshing() {
        guard canStartRefreshing else { return }
        _refreshControl?.generateRefreshEvent()
    }
    
    func pullAndRefresh() {
        guard canStartRefreshing else { return }
        scrollToTopAndShowRunningRefreshControl(changeContentOffsetWithAnimation: true)
        _refreshControl?.generateRefreshEvent()
    }
    
    func endRefreshing(deadline: DispatchTime? = nil) { _refreshControl?.endRefreshing(deadline: deadline) }
}


var disabledColorHandle: UInt8 = 0
var highlightedColorHandle: UInt8 = 0
var selectedColorHandle: UInt8 = 0

extension UIButton {
    // https://stackoverflow.com/questions/14523348/how-to-change-the-background-color-of-a-uibutton-while-its-highlighted
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }

    @IBInspectable
    var disabledColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &disabledColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    @IBInspectable
    var highlightedColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &highlightedColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .highlighted)
                objc_setAssociatedObject(self, &highlightedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .highlighted)
                objc_setAssociatedObject(self, &highlightedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    @IBInspectable
    var selectedColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &selectedColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .selected)
                objc_setAssociatedObject(self, &selectedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .selected)
                objc_setAssociatedObject(self, &selectedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

extension UIViewController {

    func flag(country:String) -> String {
        let base = 127397
        var usv = String.UnicodeScalarView()
        for i in country.utf16 {
            usv.append(UnicodeScalar(base + Int(i))!)
        }
        return String(usv)
    }
    
    
    func statusBarColorChange() {
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = UIColor(named: "AccentColor")
            statusBar.tag = 100
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(statusBar)
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor(named: "AccentColor")
        }
    }
}

extension UIView{
    func animationZoom(scaleX: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: y)
    }
    
    func animationRoted(angle : CGFloat) {
        self.transform = self.transform.rotated(by: angle)
    }

}

extension UIViewController {
    
    func getColorForRoundProduct(clr: String) -> String {
        
        switch clr {
            case "Black" : return "#000000"
            case "Dark Green" : return "#013220"
            case "Khaki" : return "#c3b091"
            case "Ivory" : return "#FFFFF0"
            case "Orange" : return "#FFA500"
            case "Purple" : return "#800080"
            case "Sky Blue" : return "#87ceeb"
            case "Beige" : return "#F5F5DC"
            case "Army Green" : return "#4b5320"
            case "Green" : return "#008000"
            case "Dark Grey" : return "#A9A9A9"
            case "Blue" : return "#0000FF"
            case "Brown" : return "#a52a2a"
            case "Gray" : return "#808080"
            case "Gold" : return "#FFD700"
            case "YELLOW" : return "#FFFF00"
            case "Lavender" : return "#E6E6FA"
            case "Pink" : return "#FFC0CB"
            case "Coral Red" : return "#ff4040"
            case "Camel" : return "#c19a6b"
            case "MULTI" : return "#ff00e1"
            case "royal blue" : return "#002366"
            case "Mint" : return "#3EB489"
            case "Clear" : return "#ffffff00"
            case "Fuchsia" : return "#FF00FF"
            case "Turquoise" : return "#40E0D0"
            case "Red" : return "#FF0000"
            case "Champagne" : return "#F7E7CE"
            case "Silver" : return "#c0c0c0"
            case "Navy Blue" : return "#000080"
            case "Burgundy" : return "#800020"
            case "Light Green" : return "#90EE90"
            case "Light Yellow" : return "#FFFF99"
            case "RHODO" : return "#b05a64"
            case "Deep Purple" : return "#3a243b"
            case "Light Grey" : return "#D3D3D3"
            case "Milky White" : return "#b7bdac"
            case "Fluorescent Green" : return "#39FF14"
            case "Fluorescent Yellow" : return "#ccff00"
            case "GINGER" : return "#b06500"
            case "Emerald Green" : return "#50C878"
            case "PEACOCK BLUE" : return "#005f69"
            case "Bright Yellow" : return "#FFFF00"
            case "Desert Camouflage" : return "#C19A6B"
            case "Lake Blue" : return "#5d89ba"
            case "Light Blue" : return "#00FFFF"
            case "Light Gray" : return "#D3D3D3"
            case "Lemon Yellow" : return "#fff44f"
            case "Dark Purple" : return "#301934"
            case "Light Purple" : return "#b19cd9"
            case "cyan" : return "#00FFFF"
            case "Coffee" : return "#6f4e37"
            case "Transparent" : return "#ffffff00"
            case "Maroon" : return "#800000"
            case "Watermelon red" : return "#fc6c85"
            case "Wine red" : return "#722f37"
            case "Dark Gray" : return "#A9A9A9"
            case "Dark Brown" : return "#654321"
            case "Light Brown" : return "#b5651d"
            case "Tangerine" : return "#F28500"
            case "Rose Red" : return "#FF033E"
            case "Plum" : return "#DDA0DD"
            case "Dark Khaki" : return "#bdb76b"
            case "Black Green" : return "#013220"
            case "Deep Blue" : return "#0000FF"
            case "Apricot" : return "#fbceb1"
            case "only-buckle" : return "#8B2332"
            case "Pale Pinkish Grey" : return "#968388"
            case "Chocolate" : return "#7b3f00"
            case "Camouflage" : return "#78866b"
            case "BlackGold" : return "#aa6c39"
            case "White" : return "#FFFFFF"
            
        default: return ""
        }
    }
    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}


extension String {
    func textHeight(withWidth width: CGFloat) -> CGFloat {
    // Jost Bold 14.0
        return self.height(withConstrainedWidth: UIScreen.main.bounds.width, font: UIFont(name: "Jost Regular", size: 13.0) ?? UIFont.systemFont(ofSize: 17))
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
}


public class DashedView: UIView {

    public struct Configuration {
        public var color: UIColor
        public var dashLength: CGFloat
        public var dashGap: CGFloat

        public init(
            color: UIColor,
            dashLength: CGFloat,
            dashGap: CGFloat) {
            self.color = color
            self.dashLength = dashLength
            self.dashGap = dashGap
        }

        static let `default`: Self = .init(
            color: .lightGray,
            dashLength: 7,
            dashGap: 3)
    }

    // MARK: - Properties

    /// Override to customize height
    public class var lineHeight: CGFloat { 1.0 }

    override public var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: Self.lineHeight)
    }

    public final var config: Configuration = .default {
        didSet {
            drawDottedLine()
        }
    }

    private var dashedLayer: CAShapeLayer?

    // MARK: - Life Cycle

    override public func layoutSubviews() {
        super.layoutSubviews()

        // We only redraw the dashes if the width has changed.
        guard bounds.width != dashedLayer?.frame.width else { return }

        drawDottedLine()
    }

    // MARK: - Drawing

    private func drawDottedLine() {
        if dashedLayer != nil {
            dashedLayer?.removeFromSuperlayer()
        }

        dashedLayer = drawDottedLine(
            start: bounds.origin,
            end: CGPoint(x: bounds.width, y: bounds.origin.y),
            config: config)
    }

}

// Thanks to: https://stackoverflow.com/a/49305154/4802021
private extension DashedView {
    func drawDottedLine(
        start: CGPoint,
        end: CGPoint,
        config: Configuration) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = config.color.cgColor
        shapeLayer.lineWidth = Self.lineHeight
        shapeLayer.lineDashPattern = [config.dashLength as NSNumber, config.dashGap as NSNumber]

        let path = CGMutablePath()
        path.addLines(between: [start, end])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)

        return shapeLayer
    }
}


extension UIView {
    func setshadow(offset:CGSize) {
        layer.cornerRadius = 4.0
        layer.shadowRadius = 7
        layer.shadowOpacity = 0.16
        layer.shadowOffset = offset
        self.clipsToBounds = false
        
    }
    
    func applyGradentColor(radius:CGFloat=0,color1:UIColor,color2:UIColor,color3:UIColor)  {
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.cornerRadius = radius
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [color1.cgColor,color2.cgColor,color3.cgColor]
        //Use diffrent colors
        self.layer.addSublayer(gradientLayer)
    }
    
    func applyGradientColorBottomToTop(color1:UIColor,color2:UIColor,color3:UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color3.cgColor,color1.cgColor,color1.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    
    func roundCorners(with CACornerMask: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [CACornerMask]
    }
    
    func roundCornersWithBezier(corners: UIRectCorner, radius: CGFloat) {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    
    func ConvertDateFormat(date : String ,inputdate : String , outputdateformat : String) -> String {
        if date.isEmpty  || date.contains("0000"){
            return date
        }
        do {
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = inputdate
            let showDate = inputFormatter.date(from: date)
            inputFormatter.dateFormat = outputdateformat
            let resultString = inputFormatter.string(from: showDate!)
            print(resultString)
            return resultString;
        } catch {
            return date
        }
    }
    
}


extension UITableView {

    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}


extension UIImage {

    /// Get image from given view
    ///
    /// - Parameter view: the view
    /// - Returns: UIImage
    public class func image(fromView view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)

        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}


extension UIButton {
  func alignVertical(spacing: CGFloat = 6.0) {
    guard let imageSize = imageView?.image?.size,
      let text = titleLabel?.text,
      let font = titleLabel?.font
    else { return }

    titleEdgeInsets = UIEdgeInsets(
      top: 0.0,
      left: -imageSize.width,
      bottom: -(imageSize.height + spacing),
      right: 0.0
    )

    let titleSize = text.size(withAttributes: [.font: font])
    imageEdgeInsets = UIEdgeInsets(
      top: -(titleSize.height + spacing),
      left: 0.0,
      bottom: 0.0,
      right: -titleSize.width
    )

    let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
    contentEdgeInsets = UIEdgeInsets(
      top: edgeOffset,
      left: 0.0,
      bottom: edgeOffset,
      right: 0.0
    )
  }
}

@IBDesignable
class AppTabBar: UITabBar {

    private var shapeLayer: CALayer?

    override func draw(_ rect: CGRect) {
        self.addShape()
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = #colorLiteral(red: 0.9782002568, green: 0.9782230258, blue: 0.9782107472, alpha: 1)
        shapeLayer.lineWidth = 0.5
        shapeLayer.shadowOffset = CGSize(width:0, height:0)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.gray.cgColor
        shapeLayer.shadowOpacity = 0.3

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }

    func createPath() -> CGPath {
        let height: CGFloat = 86.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - height ), y: 0))
        path.addCurve(to: CGPoint(x: centerWidth, y: height - 40),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height - 40))
        path.addCurve(to: CGPoint(x: (centerWidth + height ), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height - 40), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
}

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 74
        return sizeThatFits
    }
}


class CustomNavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let tabBarController = tabBarController as? CustomTabBarController {
            tabBarController.menuButton.isHidden = true // Hide the button when pushing
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if let tabBarController = tabBarController as? CustomTabBarController {
            tabBarController.menuButton.isHidden = false // Show the button when popping
        }
        return super.popViewController(animated: animated)
    }
}


class CustomTextField: UITextField {
    private let underlineLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        // Add the underline layer
        underlineLayer.backgroundColor = UIColor.lightGray.cgColor
        layer.addSublayer(underlineLayer)

        // Customize other appearance properties as needed
        borderStyle = .none
        // Other customization...
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Position the underline layer at the bottom of the text field
        let lineHeight: CGFloat = 1.0 // Adjust as needed
        underlineLayer.frame = CGRect(x: 0, y: frame.height + 5 - lineHeight, width: frame.width, height: lineHeight)
    }

    // Call this method to change the underline color
    func setUnderlineColor(_ color: UIColor) {
        underlineLayer.backgroundColor = color.cgColor
    }
}


@IBDesignable
class RoundedTopCornersView: UIView {
    
    @IBInspectable var topLeftCornerRadius: CGFloat = 0.0 {
        didSet {
            updateCorners()
        }
    }
    
    @IBInspectable var topRightCornerRadius: CGFloat = 0.0 {
        didSet {
            updateCorners()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCorners()
    }
    
    private func updateCorners() {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(
                width: min(topLeftCornerRadius, bounds.width),
                height: min(topRightCornerRadius, bounds.width)
            )
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}
