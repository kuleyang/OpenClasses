//
//  UIKit+WTRequestCenter.swift
//  OpenClasses
//
//  Created by mike on 15/6/5.
//  Copyright (c) 2015年 mike. All rights reserved.
//

import Foundation
import UIKit
extension UIAlertView {
    static func showWithTitle(title:String?,message:String?){
        var alert:UIAlertView? = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: nil);
        alert?.show();
    }
}