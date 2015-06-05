//
//  OCModelCenter.swift
//  OpenClasses
//
//  Created by mike on 15/6/5.
//  Copyright (c) 2015年 mike. All rights reserved.
//

import UIKit

class OCModelCenter: NSObject {
    static func showError(error:NSError){
        UIAlertView.showWithTitle("error", message: error.localizedDescription)
    }
}
