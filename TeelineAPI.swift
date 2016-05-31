//
//  TeelineAPI.swift
//  teeline-app
//

import Foundation

class TeelineAPI: NSObject {
    
    // Base URL, where to send the requests
    private static let baseUrl = "https://api.teeline.co/v1"
    // Cache of requests for when
    private static var requestCache = [String: Response]()
    
    // Abstraction of HTTP methods
    //
    // FETCH -> HTTP GET
    // CREATE -> HTTP POST
    // UPDATE -> HTTP PUT
    //
    enum RequestType: String {
        
        case FETCH = "GET"
        case CREATE = "POST"
        case UPDATE = "PUT"
    }
    
    // Request data object to hold request info
    struct Request {
        
        var path: String = "/"
        var type: RequestType = .FETCH
    }
    
    // Response data object, will be RC'd later
    struct Response {
        
        let json: AnyObject
        let jsonError: Int
        let error: NSError?
    }
    
    private override init() {
        // Use the static functions only
    }
    
    // Send a request but do not cache the response
    static func sendRequest(request: Request, handler: Response -> Void) {
        let url = NSURL(string: "\(baseUrl)\(request.path)")
        let urlRequest = NSMutableURLRequest(URL: url!)
        
        // Set the HTTP method from the request
        urlRequest.HTTPMethod = request.type.rawValue
        // Set the user agent as proof this is from an iOS device
        urlRequest.setValue("Teeline Mobile / iOS", forHTTPHeaderField: "User-Agent")
        
        NSURLSession.sharedSession().dataTaskWithRequest(urlRequest, completionHandler: {
            (data, response, error) in
            
            let httpResponse = response as! NSHTTPURLResponse
            
            if (httpResponse.statusCode == 200) {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    let jsonValidation = Validation.validateJSON(NSString(data: data!, encoding: NSUTF8StringEncoding) as! String)
                    
                    // Ensure JSON response is within valid bounds
                    if let reasonValue = jsonValidation {
                        switch (reasonValue) {
                        case Validation.FailureReason.TOO_SHORT:
                            print("JSON returned empty")
                        case Validation.FailureReason.NO_MATCH:
                            print("Invalid JSON format")
                        default:
                            print("JSON validation failure")
                        }
                        
                        return
                    }
                    
                    // Send a response in time with UI updates
                    dispatch_async(dispatch_get_main_queue(), {
                        handler(TeelineAPI.Response(json: json, jsonError: json["error"] as! Int, error: error))
                    })
                } catch {
                    //
                }
            }
        }).resume()
    }
    
    // Send a request and cache the response
    static func sendCachedRequest(request: Request, secondaryHandler: Response -> Void) {
        // Check if a response is already cached and available
        for cachedRequest in self.requestCache {
            if (cachedRequest.0 == request.path.lowercaseString) {
                // Return with the current cached request
                secondaryHandler(cachedRequest.1)
                
                return
            }
        }
        
        // Send request if not current cached
        TeelineAPI.sendRequest(request, handler: {
            response in
            
            self.requestCache[request.path.lowercaseString] = response
            
            secondaryHandler(response)
        })
    }
}
