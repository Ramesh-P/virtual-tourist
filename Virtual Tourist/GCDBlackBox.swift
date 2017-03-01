//
//  GCDBlackBox.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 3/1/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation

// MARK: GCD BlackBox
func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    
    DispatchQueue.main.async {
        updates()
    }
}

