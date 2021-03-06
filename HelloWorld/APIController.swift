//
//  APIController.swift
//  HelloWorld
//
//  Created by Laagad El Mehdi on 18/01/2016.
//  Copyright © 2016 Laagad El Mehdi. All rights reserved.
//

import Foundation

class APIController {
    
    var delegate: APIControllerProtocol
   
    init(delegate: APIControllerProtocol) {
        self.delegate = delegate
    }
    
    func get(path: String) {
        let url : NSURL = NSURL(string: path)!
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(url, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            do {
                if let _ = NSString(data:data!, encoding:NSUTF8StringEncoding){
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    
                    let results: NSArray = jsonDictionary!["results"] as! NSArray
                    self.delegate.didReceiveAPIResults(results)
                    dispatch_async(dispatch_get_main_queue(),{
                        //self.tableData = results
                        //self.appsTableView?.reloadData()
                    })
                }
            }catch{
                print("Bad operation")
            }
        }).resume()
    }

    func lookupAlbum(collectionId: Int) {
        get("https://itunes.apple.com/lookup?id=\(collectionId)&entity=song")
    }
        
    
    func searchItunesFor(searchTerm: String) {
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        let escapedSearchTerm : String = itunesSearchTerm.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        let urlPath: String = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
        get(urlPath)
    }
    
}
protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSArray)
}