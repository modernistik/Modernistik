//
//  Modernistik
//  Copyright © Modernistik LLC. All rights reserved.
//

import Foundation

/// A basic empty completion block that provides an error in case of failure.
/// - parameter error: An error if not successful.
public typealias CompletionResultBlock = (_ error:Error?) -> ()
public typealias ResultBlock = CompletionResultBlock

/// A completion block that returns a boolean result.
/// - parameter success: A boolean result whether it was completed successfully.
public typealias CompletionSuccessBlock = (_ success:Bool) -> ()
public typealias SuccessBlock = CompletionSuccessBlock


/// A basic completion block with no parameters or result.
public typealias CompletionBlock = () -> Void

// MARK: NSBundle
extension Bundle {
    
    /// Returns the current build version based on the `CFBundleVersion` of the Info.plist. Defaults 0.
    public class var currentBuildVersion:Int {
        if let buildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String,
            let buildNumber = Int(buildVersion) {
                return buildNumber
        }
        return 0
    }
    
}

// MARK: Array NSLayoutConstraint extensions
extension Array where Element: NSLayoutConstraint {
    /// Activates an array of NSLayoutConstraints
    public func activate() {
        NSLayoutConstraint.activate(self)
    }
    
    /// Deactivates an array of NSLayoutConstraints
    public func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
    
}

extension FileManager {
    /// Returns the documents directory
    
    public var documentsDirectory:URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    /// Returns the caches directory
    public var cachesDirectory: URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
}

// MARK: NSUserDefaults
extension UserDefaults {
    
    /**
    Sets true to the given key in NSUserDefaults. If the value has not been
     previously flagged this method returns true. If it has been previously flagged it returns false.
    
    Assume you want to run some code that should only happen once, you can do
     the following:
    ````
     let key = "ShouldShowOneTimePopUp"
     
     if( UserDefaults.flagOnce(forKey: key) ) {
       // show one-time popup
     }
     
     // this will now return false
     UserDefaults.flagOnce(forKey: key) // => false
     
    ````
    - parameter key: The NSUserDefaults string key name to use for storing the flag.
    - returns: true if the flag was successfully created or changed from false to true.
     */
    public class func flagOnce(forKey key:String) -> Bool {
        let d = standard
        var flagged = false //only flag if we've never flagged before.
        
        if d.object(forKey: key) == nil || d.bool(forKey: key) == false {
            flagged = true
            d.set(true, forKey: key)
            d.synchronize()
        }
        
        return flagged;
        
    }
    
    /// Sets false to the NSUserDefaults key provided. This basically resets the flag state.
    ///
    /// - parameter key: The NSUserDefaults string key name.
    public class func resetFlag(forKey key:String) {
        standard.removeObject(forKey: key)
        standard.synchronize()
    }
    
}

/// A short macro to perform an `dispatch_async` (main thread) at a later time in seconds, using the `dispatch_after` call.
///
/// - parameter seconds: The number of seconds to wait before performing the closure
/// - parameter closure: A void closure to perform at a later time on the main thread.
public func async_delay(_ seconds:Double, closure: @escaping CompletionBlock) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
}

/// Dispatch a block on the main queue
///
/// - parameter closure: The closure to execute on the main thread.
public func async_main(_ closure: @escaping CompletionBlock ) {
    DispatchQueue.main.async(execute: closure)
}

/// Dispatch a block in the background queue
///
/// - parameter closure: The closure to execute on the background thread.
public func async_background(_ closure: @escaping CompletionBlock ) {
    DispatchQueue.global().async(execute: closure)
}