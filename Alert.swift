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
}
