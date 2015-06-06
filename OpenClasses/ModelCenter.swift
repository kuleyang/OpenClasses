//
//  OCModelCenter.swift
//  OpenClasses
//
//  Created by mike on 15/6/5.
//  Copyright (c) 2015年 mike. All rights reserved.
//

import UIKit


public enum RequestInterface:String{
    case recommanded = "http://c.open.163.com/mobile/recommend/v1.do" // recommanded
    case guessYouLike = "http://c.open.163.com/opensg/mopensg.do"   //guess you like
    case classInfo = "http://so.open.163.com/movie/MAOG4A1R7/getMovies4Ipad.htm" // class info
    
}
class ModelCenter: NSObject {
    static func showError(error:NSError){
        UIAlertView.showWithTitle("error", message: error.localizedDescription)
    }

}
