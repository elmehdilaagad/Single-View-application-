//
//  DetailViewController.swift
//  HelloWorld
//
//  Created by Laagad El Mehdi on 13/02/2016.
//  Copyright © 2016 Laagad El Mehdi. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController {
        
        var album: Album?
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
        }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            titleLabel.text = self.album?.title
            albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)!)!)
        }
    }
