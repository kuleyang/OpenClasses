//
//  WTRequestCenter.swift
//  CreditWallet
//
//  Created by mike on 15/6/3.
//  Copyright (c) 2015年 mike. All rights reserved.
//

import UIKit
import Foundation


public enum Method: String {
    case OPTIONS = "OPTIONS"
    case GET = "GET"
    case HEAD = "HEAD"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
}

public enum ParameterEncoding
{
    /**
    A query string to be set as or appended to any existing URL query for `GET`, `HEAD`, and `DELETE` requests, or set as the b    mki9ody for requests with any other HTTP method. The `Content-Type` HTTP header field of an encoded request with HTTP body is set to `application/x-www-form-urlencoded`. Since there is no published specification for how to encode collection types, the convention of appending `[]` to the key for array values (`foo[]=1&foo[]=2`), and appending the key surrounded by square brackets for nested dictionary values (`foo[bar]=baz`).
    */
    case URL
    
    /**
    Uses `NSJSONSerialization` to create a JSON representation of the parameters object, which is set as the body of the request. The `Content-Type` HTTP header field of an encoded request is set to `application/json`.
    */
    case JSON
    
    /**
    Uses `NSPropertyListSerialization` to create a plist representation of the parameters object, according to the associated format and write options values, which is set as the body of the request. The `Content-Type` HTTP header field of an encoded request is set to `application/x-plist`.
    */
    case PropertyList(NSPropertyListFormat, NSPropertyListWriteOptions)
    
    /**
    Uses the associated closure value to construct a new request given an existing request and parameters.
    */
    case Custom((URLRequestConvertible, [String: AnyObject]?) -> (NSURLRequest, NSError?))
    
    /**
    Creates a URL request by encoding parameters and applying them onto an existing request.
    
    :param: URLRequest The request to have parameters applied
    :param: parameters The parameters to apply
    
    :returns: A tuple containing the constructed request and the error that occurred during parameter encoding, if any.
    */
    public func encode(URLRequest: URLRequestConvertible, parameters: [String: AnyObject]?) -> (NSURLRequest, NSError?) {
        if parameters == nil {
            return (URLRequest.URLRequest, nil)
        }
        
        var mutableURLRequest: NSMutableURLRequest! = URLRequest.URLRequest.mutableCopy() as! NSMutableURLRequest
        var error: NSError? = nil
        
        switch self {
        case .URL:
            func query(parameters: [String: AnyObject]) -> String {
                var components: [(String, String)] = []
                for key in sorted(Array(parameters.keys), <) {
                    let value: AnyObject! = parameters[key]
                    components += self.queryComponents(key, value)
                }
                
                return join("&", components.map{"\($0)=\($1)"} as [String])
            }
            
            func encodesParametersInURL(method: Method) -> Bool {
                switch method {
                case .GET, .HEAD, .DELETE:
                    return true
                default:
                    return false
                }
            }
            
            let method = Method(rawValue: mutableURLRequest.HTTPMethod)
            if method != nil && encodesParametersInURL(method!) {
                if let URLComponents = NSURLComponents(URL: mutableURLRequest.URL!, resolvingAgainstBaseURL: false) {
                    URLComponents.percentEncodedQuery = (URLComponents.percentEncodedQuery != nil ? URLComponents.percentEncodedQuery! + "&" : "") + query(parameters!)
                    mutableURLRequest.URL = URLComponents.URL
                }
            } else {
                if mutableURLRequest.valueForHTTPHeaderField("Content-Type") == nil {
                    mutableURLRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                }
                
                mutableURLRequest.HTTPBody = query(parameters!).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            }
        case .JSON:
            let options = NSJSONWritingOptions.allZeros
            if let data = NSJSONSerialization.dataWithJSONObject(parameters!, options: options, error: &error) {
                mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.HTTPBody = data
            }
        case .PropertyList(let (format, options)):
            if let data = NSPropertyListSerialization.dataWithPropertyList(parameters!, format: format, options: options, error: &error) {
                mutableURLRequest.setValue("application/x-plist", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.HTTPBody = data
            }
        case .Custom(let closure):
            return closure(mutableURLRequest, parameters)
        }
        
        return (mutableURLRequest, error)
    }
    
    func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else {
            components.extend([(escape(key), escape("\(value)"))])
        }
        
        return components
    }
    
    func escape(string: String) -> String {
        let legalURLCharactersToBeEscaped: CFStringRef = ":&=;+!@#$()',*"
        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
}

// MARK: - URLStringConvertible

/**
Types adopting the `URLStringConvertible` protocol can be used to construct URL strings, which are then used to construct URL requests.
*/
public protocol URLStringConvertible {
    /// The URL string.
    var URLString: String { get }
}

extension String: URLStringConvertible {
    public var URLString: String {
        return self
    }
}

extension NSURL: URLStringConvertible {
    public var URLString: String {
        return absoluteString!
    }
}

extension NSURLComponents: URLStringConvertible {
    public var URLString: String {
        return URL!.URLString
    }
}

extension NSURLRequest: URLStringConvertible {
    public var URLString: String {
        return URL!.URLString
    }
}

// MARK: - URLRequestConvertible

/**
Types adopting the `URLRequestConvertible` protocol can be used to construct URL requests.
*/
public protocol URLRequestConvertible {
    /// The URL request.
    var URLRequest: NSURLRequest { get }
}

extension NSURLRequest: URLRequestConvertible {
    public var URLRequest: NSURLRequest {
        return self
    }
}


class WTRequestCenter: NSObject {

    
    /// The underlying session.
    internal let session: NSURLSession
    
    /// The session delegate handling all the task and session delegate callbacks.
//    public let delegate: NSURLSessionDelegate
    
    /// Whether to start requests immediately after being constructed. `true` by default.
    internal var startRequestsImmediately: Bool = true
    
    internal let delegateQueue:NSOperationQueue

    required init(configuration:NSURLSessionConfiguration? = nil){
        
        delegateQueue = NSOperationQueue();
        
        self.session = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: delegateQueue)
        
        
        
    }
    
    internal static let sharedInstance: WTRequestCenter = {
        let configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        return WTRequestCenter(configuration: configuration)
        }()
    
    func request(method: Method,_ URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL) -> NSMutableURLRequest {
        var request:NSMutableURLRequest?
        request = requestWith(URLString, method: method);
        request = encoding.encode(request!, parameters: parameters).0 as? NSMutableURLRequest;
        
        return request!;
        
    }
    
    func requestWith(urlString:URLStringConvertible,method:Method) -> NSMutableURLRequest
    {
        let request:NSMutableURLRequest?
        var url :NSURL?
        if(true)
        {
            url = NSURL(string: urlString.URLString)
        }
        
        request = NSMutableURLRequest(URL: url!)
        request?.HTTPMethod = method.rawValue;
        return request!;
    }
    
    
    static func performBlock(block:() -> Void, afterDelay:Int64){
        var queue = dispatch_get_main_queue()
        var t = dispatch_time(DISPATCH_TIME_NOW, afterDelay*1000*1000*1000);
        dispatch_after(t, queue, block)
        
    }
    
    
    
    
    
    class func doURLRequest(request:NSURLRequest,finished:(response:NSURLResponse,data:NSData)-> Void,failed:(error:NSError)-> Void)
    {
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error == nil){
                finished(response: response, data: data);
            }else
            {
                failed(error: error);
            }
        })
        /*
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if (error == nil){
                finished(response: response, data: data);
            }else
            {
                failed(error: error);
            }
        }
        */
    }
    
    
    
    class func doURLRequest(method:Method,urlString:URLStringConvertible,parameters:[String: AnyObject]? = nil,encoding: ParameterEncoding = .URL,finished:(response:NSURLResponse,data:NSData)-> Void,failed:(error:NSError)-> Void)
    {
        var request = self.sharedInstance.request(method, urlString, parameters: parameters, encoding: encoding)
        
        self.doURLRequest(request, finished: finished, failed: failed)
    }
    
    
    
    
}
