//
//  Cell.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 3/8/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit

class Cell: UICollectionViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var title: UILabel!
}

