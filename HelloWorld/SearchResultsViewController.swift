//
//  ViewController.swift
//  HelloWorld
//
//  Created by Laagad El Mehdi on 15/01/2016.
//  Copyright © 2016 Laagad El Mehdi. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var imageCache = [String : UIImage]()
    let kCellIdentifier : String = "SearchResultCell"
    var api = APIController()
    
    @IBOutlet var appsTableView : UITableView?
    var tableData = []
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.api.delegate = self
        api.searchItunesFor("twiter")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        let resultsArr: NSArray = results["results"] as! NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = resultsArr
            self.appsTableView!.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /* return 10;  */
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /*
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier)! as UITableViewCell
        //let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
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
        */
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier)! as UITableViewCell
        
        var rowData: NSDictionary = self.tableData[indexPath.row] as! NSDictionary
        
        // Ajout d'une vérification pour s'assurer qu'il existe.
        let cellText: String? = rowData["trackName"] as? String
        cell.textLabel!.text = cellText
        cell.imageView!.image = UIImage(named: "Blank52")
        
        
        // Obtenir le prix formaté pour l'afficher dans le sous-titre.
        let formattedPrice: NSString = rowData["formattedPrice"] as! NSString
        
        // Utiliser dans une tâche de fond afin d'obtenir l'image de cet élément.
        
        // Obtention de la valeur de la clef « artworkUrl60 » afin d'obtenir l'URL de l'image miniature de l'application.
        
        
        let urlString = rowData["artworkUrl60"] as! String
        
        // Vérifier si notre cache d'images contient la clef. La structure est simplement un dictionnaire d'UIImages.
        //var image: UIImage? = self.imageCache.valueForKey(urlString) as? UIImage
        var image = self.imageCache[urlString]
        
        
        if( image == nil ) {
            // Si l'image n'existe pas, nous devons la télécharger.
            let imgURL: NSURL = NSURL(string: urlString)!
            
            // Télécharger un NSData contenant l'image de l'URL.
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    image = UIImage(data: data!)
                    
                    // Stocker l'image dans notre cache.
                    self.imageCache[urlString] = image
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                        cellToUpdate.imageView!.image = image
                    }
                }
                else {
                    print("Error: \(error!.localizedDescription)")
                }
            })
            
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                    cellToUpdate.imageView!.image = image
                }
            })
        }
        
        cell.detailTextLabel!.text = formattedPrice as String
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Obtenir les données pour la ligne sélectionnée
        let rowData: NSDictionary = self.tableData[indexPath.row] as! NSDictionary
        
        let name: String = rowData["trackName"]as! String
        let formattedPrice: String = rowData["formattedPrice"] as! String
        
        let alert: UIAlertView = UIAlertView()
        alert.title = name
        alert.message = formattedPrice
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
}

