//
//  ViewController.swift
//  HelloWorld
//
//  Created by Laagad El Mehdi on 15/01/2016.
//  Copyright © 2016 Laagad El Mehdi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var appsTableView : UITableView?
    var tableData = []
    
    func searchItunesFor(searchTerm: String) {
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        let escapedSearchTerm : String = itunesSearchTerm.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        let urlPath: String = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
        print("https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software")
        let url : NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(url, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            do {
                if let _ = NSString(data:data!, encoding:NSUTF8StringEncoding){
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    
                    let results: NSArray = jsonDictionary!["results"] as! NSArray
                    dispatch_async(dispatch_get_main_queue(),{
                        self.tableData = results
                        self.appsTableView?.reloadData()
                    })
                }
            }catch{
                print("Bad ")
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

    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchItunesFor("JQ Software")
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return 10;
        return tableData.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        let rowData: NSDictionary = self.tableData[indexPath.row] as! NSDictionary
        
        cell.textLabel!.text = rowData["trackName"] as? String
        
        // Prenez la clé d'artworkUrl60 pour obtenir une URL d'image pour la miniature de l'application
        let urlString: NSString = rowData["artworkUrl60"] as! NSString
        let imgURL: NSURL = NSURL(string: urlString as String)!
        
        // Télécharger une représentation NSData de l'image à cette URL
        let imgData: NSData = NSData(contentsOfURL: imgURL)!
        cell.imageView!.image = UIImage(data: imgData)
        
        // Obtenir le prix en tant que chaîne formatée pour l'afficher dans le sous-titre
        let formattedPrice: NSString = rowData["formattedPrice"] as! NSString
        
        cell.detailTextLabel!.text = formattedPrice as String
        
        return cell
        
        /*
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
         cell.textLabel!.text = "Ligne #\(indexPath.row)"
         cell.detailTextLabel!.text = "Subtitle #\(indexPath.row)"
        
        return cell
        */
    }
}

