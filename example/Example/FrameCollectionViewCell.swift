//
//  FrameCollectionViewCell.swift
//  Example
//
//  Created by Remi Robert on 21/01/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit

class FrameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewFrame: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageViewFrame.image = nil
    }
}
