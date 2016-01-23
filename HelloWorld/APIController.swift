//
//  APIController.swift
//  HelloWorld
//
//  Created by Laagad El Mehdi on 18/01/2016.
//  Copyright © 2016 Laagad El Mehdi. All rights reserved.
//

import Foundation

class APIController {
    
    var delegate: APIControllerProtocol?
    
    init(){
        
    }
    
    func searchItunesFor(searchTerm: String) {
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        let escapedSearchTerm : String = itunesSearchTerm.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        let urlPath: String = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
        //print("https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software")
        let url : NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(url, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            do {
                if let _ = NSString(data:data!, encoding:NSUTF8StringEncoding){
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    
                    let _: NSArray = jsonDictionary!["results"] as! NSArray
                    self.delegate?.didReceiveAPIResults(jsonDictionary!)
                    dispatch_async(dispatch_get_main_queue(),{
                        //self.tableData = results
                        //self.appsTableView?.reloadData()
                    })
                }
            }catch{
                print("Bad operation")
            }
        }).resume()
        
        /*
        
        if(error) {
        // Si une erreur survient lors de la requête web, l'afficher en console
        println(error.localizedDescription)
        }
        var err: NSError?
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        if(err != nil) {
        // Si une erreur survient pendant l'analyse du JSON, l'afficher en console
        println("JSON Error \(err!.localizedDescription)")
        }
        let results: NSArray = jsonResult["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
        self.tableData = results
        self.appsTableView!.reloadData()
        })
        })
        task.resume()
        */
    }
    
}
protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSDictionary)
}