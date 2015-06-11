//
//  UIKit+WTRequestCenter.swift
//  OpenClasses
//
//  Created by mike on 15/6/5.
//  Copyright (c) 2015年 mike. All rights reserved.
//

import Foundation
import UIKit


extension UIApplication{
    public static func AppVersion()->String?{
        var version = NSBundle.mainBundle().infoDictionary
        var result:String?
        
        return result
    }
}

extension UIAlertView {
    static func showWithTitle(title:String?,message:String?){
        var alert:UIAlertView? = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: nil);
        alert?.show();
        
        
        WTRequestCenter.performBlock({ () -> Void in
            alert?.dismissWithClickedButtonIndex(0, animated: true)
        }, afterDelay: 0)
        
    }
}


var uiimageStoreKey:String? = "uiimage Store Key"
extension UIImageView{
    
    
    
//    setImage
    func setImageWithURL(url:URLStringConvertible?){
        
        if((url) != nil){
            WTRequestCenter.sharedInstance.GETUsingCache(url!, parameters: nil, encoding: ParameterEncoding.URL, finished: { (response, data) -> Void in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                    var image:UIImage? = UIImage(data: data)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.image = image
                    });
                })
                }) { (error) -> Void in
                    
            }
        }
        
        
        
        
    }
    
    
    
//    highlightedImage
    func sethighlightedImageWithURL(url:URLStringConvertible){
        
        
        
        WTRequestCenter.sharedInstance.GETUsingCache(url, parameters: nil, encoding: ParameterEncoding.URL, finished: { (response, data) -> Void in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                var image:UIImage? = UIImage(data: data)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.highlightedImage = image
                })
            })
            }) { (error) -> Void in
                
        }
        
    }
}

extension UIButton{
//    set image
    func setImageWithURL(url:URLStringConvertible, forState state: UIControlState){
        WTRequestCenter.sharedInstance.GETUsingCache(url, parameters: nil, encoding: ParameterEncoding.URL, finished: { (response, data) -> Void in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                var image:UIImage? = UIImage(data: data)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.setImage(image, forState: state)
                });
            })
            }) { (error) -> Void in
                
        }
    }
    
//    set bg image
    func setBackgroundImageWithURL(url:URLStringConvertible, forState state: UIControlState){
        WTRequestCenter.sharedInstance.GETUsingCache(url, parameters: nil, encoding: ParameterEncoding.URL, finished: { (response, data) -> Void in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                var image:UIImage? = UIImage(data: data);
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.setBackgroundImage(image, forState: state)
                });
            })
            }) { (error) -> Void in
                
        }
    }
}

extension UIScrollView{
    
}

extension UIColor
{
    static func colorWithHexString(string:String?)->UIColor{
        var color:UIColor?
        
        
        
        return color!
    }
    
    
    static func integerValueFromHexString(string:String?)->Int{
        var result:Int?
        var scanner = NSScanner(string: string!)
        
        
        return result!
    }
    
}


class WTNetworkActivityIndicatorManager:NSObject{
    var enable:Bool?
    var isNetworkActivityIndicatorVisible:Bool?
    
    
    var activityCount:Int!
    var activityIndicatorVisibilityTimer:NSTimer?
    
    
    static func sharedInstance(){
        let instance:WTNetworkActivityIndicatorManager?
        instance = WTNetworkActivityIndicatorManager()
    }
    
    
    override init(){
        super.init()
        activityCount!=0
    }
    
    /*
    //请求开始的消息
    NSString * const WTNetworkingOperationDidStartNotification = @"WTNetworkingOperationDidStartNotification";
    //请求结束的消息
    NSString * const WTNetworkingOperationDidFinishNotification = @"WTNetworkingOperationDidFinishNotification";

    */
    
    let startNotification = "WTNetworkingOperationDidStartNotification"
    let endNotification = "WTNetworkingOperationDidFinishNotification"
    func handleNofitications(){
        
        NSNotificationCenter.defaultCenter().addObserverForName(startNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (note) -> Void in
            
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(endNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (note) -> Void in
            
        }
        
    
    }
    
    func incrementActivityCount(){
        activityCount!++

    }
    
    
    func decrementActivityCount(){
        activityCount!--
    }
    
    
    func updateNetworkActivityIndicatorVisibilityDelayed(){
        if (self.enable != nil){
            if((self.isNetworkActivityIndicatorVisible) != nil){
                self.activityIndicatorVisibilityTimer?.invalidate();
                self.activityIndicatorVisibilityTimer = NSTimer(timeInterval: 0.1, target: self, selector: Selector("updateNetworkActivityIndicatorVisibilityDelayed"), userInfo: nil, repeats: false)
                NSRunLoop.mainRunLoop().addTimer(activityIndicatorVisibilityTimer!, forMode: NSRunLoopCommonModes)
                
                
            }else{
                WTNetworkActivityIndicatorManager.performSelector(Selector(updateNetworkActivityIndicatorVisibilityDelayed()), onThread: NSThread.mainThread(), withObject: nil, waitUntilDone: false, modes: [NSRunLoopCommonModes])
                
            }
        }
    }
    
    
}











