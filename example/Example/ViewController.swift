//
//  ViewController.swift
//  Example
//
//  Created by Remi Robert on 21/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import Splime

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var splimeVideo: Splime!
    
    var frames = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let stringPath = NSBundle.mainBundle().pathForResource("video", ofType: "mp4") {
            self.splimeVideo = Splime(url: stringPath)
            
            self.splimeVideo.everyFrames = 10
            
            
            self.splimeVideo.split({ (images) -> () in
                
                self.frames = images
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionView.reloadData()                    
                })
                
                }, progressBlock: { (progress) -> () in
                    print("current progress : \(progress)")
            })
        }
        self.collectionView.registerNib(UINib(nibName: "FrameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.collectionView.dataSource = self
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.frames.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! FrameCollectionViewCell
        
        cell.imageViewFrame.image = self.frames[indexPath.row]
        return cell
    }
}
