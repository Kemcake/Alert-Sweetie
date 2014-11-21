//
//  Alert.swift
//
//
//  Created by Remi Santos on 13/11/14.
//  Copyright (c) 2014 Remi Santos. All rights reserved.
//

import UIKit

class Alert: NSObject, UIAlertViewDelegate {
    
    var alertController : UIAlertController?
    var alertView : UIAlertView?
    var delegate:UIAlertViewDelegate! {
        didSet {
            if (alertView != nil) {
                alertView?.delegate = delegate
            }
        }
    }
    var useAlertController:Bool = (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0 {
        didSet {
            if (UIDevice.currentDevice().systemVersion as NSString).floatValue < 8.0 {
                useAlertController = false
            }
        }
    }
    
    private var index:Int = 0
    private var handlers:[(Int->Void)?] = []
    
    var tintColor:UIColor = UIColor.blueColor() {
        didSet {
            if (useAlertController) {
                alertController?.view.tintColor = tintColor
            }
        }
    }
    
    init(title:String?, message:String?){
        super.init()
        
        if (useAlertController) {
            alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        } else {
            delegate = self
            alertView = UIAlertView(
                title: title,
                message: message,
                delegate: delegate,
                cancelButtonTitle: nil)
        }
        
    }
    
    class func show(#title:String?, message:String?, button:String, handler:((Int)->Void)?) {
        let alert = Alert(title: title, message: message)
        alert.tintColor = UIColor.blueColor()
        alert.addAction(title: button, style: .Cancel, handler: handler)
        alert.show()
    }
    
    func addAction(#title:String, style:UIAlertActionStyle, handler:(Int->Void)?) {
        if (useAlertController) {
            let currentIndex:Int! = index
            var action = UIAlertAction(title: title, style: style, handler: { (alertAction) -> Void in
                if (handler != nil) {
                    handler!(currentIndex)
                }
            })
            alertController?.addAction(action)
        } else {
            alertView?.addButtonWithTitle(title)
            if(style == .Cancel) {
                alertView?.cancelButtonIndex = index
            } else if (style == .Destructive) {
                //re-init the alertView with a destructive button ?
            }
            handlers.append(handler)
        }
        index++
    }
    
    func show(onViewController controller:UIViewController, completion:(() -> Void)?) {
        if (useAlertController) {
            controller.presentViewController(alertController!, animated: true, completion: {()->Void in
                if completion != nil {
                    completion!()
                }
            })
        } else {
            alertView?.show()
            if completion != nil {
                completion!()
            }
        }
    }
    
    func show() {
        var rootController = (UIApplication.sharedApplication().keyWindow?.rootViewController)
        if((rootController?.presentedViewController) != nil) {
            rootController = rootController?.presentedViewController as UIViewController!
        }
        self.show(onViewController: rootController!, completion: nil)
    }
    
    //MARK: AlertView delegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (useAlertController) {
            //never
        } else {
            if ( handlers[buttonIndex] != nil) {
                handlers[buttonIndex]!(buttonIndex)
            }
        }
    }
    
    //MARK: Errors
    class func show(#error:NSError?) {
        var title:String?
        if(error != nil){
            let userInfo = error?.userInfo as [String:AnyObject]
            if (userInfo["error"] != nil) {
                let errorString = userInfo["error"] as String
                let errorCode = Alert.errorCode(string: errorString)
                if (errorCode != NSNotFound) {
                    let pttrn = "Error\(errorCode)"
                    let string = NSLocalizedString(pttrn, comment:"")
                    if (string != pttrn) {
                        title = string
                    }
                }
            }
        }
        
        if (title == nil) {
            title = NSLocalizedString("GenericErrorMessage", comment:"")
        }
        
        Alert.show(title:"Error", message:title, button:"OK", handler:nil)
    }
    
    class func errorCode(#string:String?) -> Int {
        if string == nil { return NSNotFound }
        
        //convert into JSON
        var jsonError:NSError?
        let stringData = (string as NSString!).dataUsingEncoding(NSUTF8StringEncoding) as NSData!
        let infos = NSJSONSerialization.JSONObjectWithData(stringData, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as NSDictionary?
        
        if (jsonError != nil && infos?["text"] != nil) {
            let infosData = (infos?["text"] as NSString).dataUsingEncoding(NSUTF8StringEncoding) as NSData!
            var errorInfo = NSJSONSerialization.JSONObjectWithData(infosData, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as NSDictionary
            
            if (jsonError != nil) {
                var errorCode:Int = 0
                if (errorInfo["code"] != nil) {
                    errorCode = errorInfo["code"] as Int
                } else if (errorInfo["error"] != nil) {
                    errorCode = (errorInfo["error"] as NSDictionary)["code"] as Int
                }
                return errorCode
            }
        }
        return NSNotFound
    }
}
