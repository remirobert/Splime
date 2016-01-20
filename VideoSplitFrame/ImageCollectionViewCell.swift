//
//  ImageCollectionViewCell.swift
//  VideoSplitFrame
//
//  Created by Remi Robert on 19/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageView.image = nil
    }
}
