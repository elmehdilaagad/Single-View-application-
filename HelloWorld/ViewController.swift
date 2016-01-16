//
//  ViewController.swift
//  HelloWorld
//
//  Created by Laagad El Mehdi on 15/01/2016.
//  Copyright © 2016 Laagad El Mehdi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
         cell.textLabel!.text = "Ligne #\(indexPath.row)"
         cell.detailTextLabel!.text = "Subtitle #\(indexPath.row)"
        
        return cell
        
    }
}

