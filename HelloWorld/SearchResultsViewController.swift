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
    var api = APIController!()
    
    @IBOutlet var appsTableView : UITableView?
    var albums = [Album]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        api = APIController(delegate: self)
        // networkActivityIndicator : Pour montrer à l'utilisateur qu'on va utiliser une opération de réseau qui se déroule
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api.searchItunesFor("twiter")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.albums = Album.albumsWithJSON(results)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailsViewController: DetailViewController = segue.destinationViewController as? DetailViewController {
            let albumIndex = appsTableView!.indexPathForSelectedRow!.row
            let selectedAlbum = self.albums[albumIndex]
            detailsViewController.album = selectedAlbum
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return albums.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier)! as UITableViewCell
        
        let album = self.albums[indexPath.row]
         // Obtenir la chaîne des prix formatée pour l'affichage dans le sous-titre
        cell.detailTextLabel?.text = album.price
        // / Mise à jour le texte TextLabel d'utiliser le titre à partir du modèle de l'album
        cell.textLabel?.text = album.title
        
        // Définition de l'image de la cellule d'un fichier statique
        cell.imageView!.image = UIImage(named: "Blank52")
        
        let thumbnailURLString = album.thumbnailImageURL
        let thumbnailURL = NSURL(string: thumbnailURLString)!
        
        // Si cette image est déjà en cache je ne la télécharge pas 
        if let img = imageCache[thumbnailURLString] {
            cell.imageView?.image = img
        }
        else {
            // L'image n'est pas mise en cache, Faut télécharger l'image
            // Nous devons effectuer cette opération dans un thread d'arrière-plan
            let request: NSURLRequest = NSURLRequest(URL: thumbnailURL)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convertir les données téléchargées pour un objet UIImage
                    let image = UIImage(data: data!)
                    // Stocke l'image dans notre cache
                    self.imageCache[thumbnailURLString] = image
                    // Mise à jour de la cellule
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                            cellToUpdate.imageView?.image = image
                        }
                    })
                }
                else {
                    print("Error: \(error!.localizedDescription)")
                }
            })
        }
        return cell
    }
}


