//
//  ViewController.swift
//  VideoSplitFrame
//
//  Created by Remi Robert on 19/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewSplit: UICollectionView!
    var videoSpliter: VIdeoSpliter!
    
    var images = Array<UIImage>()
    var imagesSplit = Array<UIImage>()
    
    override func viewDidAppear(animated: Bool) {
        if let stringPath = NSBundle.mainBundle().pathForResource("video2", ofType: "mp4") {
            
            videoSpliter = VIdeoSpliter(url: stringPath)
            
            videoSpliter.totalFramesToCapture = 100000000
                        
            //videoSpliter.numberFrames = 50
            videoSpliter.videoFrames({ (images) -> () in
                
                self.images = images
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionView.reloadData()
                })
                
                }, progressBlock: { (progress) -> () in
                  print("current progress : [\(progress)]")
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.registerNib(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.collectionView.dataSource = self
        
        self.collectionViewSplit.registerNib(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.collectionViewSplit.dataSource = self
        
        self.collectionViewSplit.tag = 2
    }
}

extension ViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 2 {
            return imagesSplit.count
        }
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ImageCollectionViewCell
        
        if collectionView.tag == 2 {
            cell.imageView.image = self.imagesSplit[indexPath.row]
        }
        else {
            cell.imageView.image = self.images[indexPath.row]
        }
        cell.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        return cell
    }
}
