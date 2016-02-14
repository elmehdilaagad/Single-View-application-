//
//  DetailViewController.swift
//  HelloWorld
//
//  Created by Laagad El Mehdi on 13/02/2016.
//  Copyright © 2016 Laagad El Mehdi. All rights reserved.
//

import UIKit
import MediaPlayer

class DetailViewController: UIViewController, APIControllerProtocol {
    
    lazy var api: APIController = APIController(delegate: self)
    var album: Album?
    var tracks = [Track]()
    var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
    var indexOfTrackPlaying : NSIndexPath? = nil
    
    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = self.album?.title
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)!)!)
        if self.album != nil {
            api.lookupAlbum(self.album!.collectionId)
        }
    }
    
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tracks = Track.tracksWithJSON(results)
            self.tracksTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let track = tracks[indexPath.row]
        var indexPathThatWasPlaying : NSIndexPath? = nil
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
            if(trackPlaying(indexPath)) {
                cell.playIcon.text = "▶️"
                stopPlayingTrack()
            }
            else {
                cell.playIcon.text = "⏹"
                indexPathThatWasPlaying = stopPlayingTrack()
                mediaPlayer.contentURL = NSURL(string: track.previewUrl)
                mediaPlayer.play()
                indexOfTrackPlaying = indexPath
            }
            var paths : [NSIndexPath] = [indexPath]
            if (indexPathThatWasPlaying != nil)
            {
                paths = [indexPath, indexPathThatWasPlaying!]
            }
            tableView.reloadRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    func stopPlayingTrack() -> NSIndexPath?
    {
        mediaPlayer.stop()
        let indexPathThatWasPlaying = indexOfTrackPlaying
        indexOfTrackPlaying = nil
        return indexPathThatWasPlaying
    }
    
    func trackPlaying(indexPath: NSIndexPath) -> Bool {
        return indexOfTrackPlaying == indexPath
    }
    
/*
        let track = tracks[indexPath.row]
        mediaPlayer.stop()
        mediaPlayer.contentURL = NSURL(string: track.previewUrl)
        mediaPlayer.play()
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
            cell.playIcon.text = "⏹"
        }
    }
*/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as! TrackCell
        let track = tracks[indexPath.row]
        cell.titleLabel.text = track.title
        cell.playIcon.text = "▶️"
        print("table view")
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.50, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
}
