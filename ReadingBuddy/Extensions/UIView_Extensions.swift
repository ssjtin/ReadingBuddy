//
//  UIView_Extensions.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 17/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

extension Optional where Wrapped == UIView {
    
    mutating func reset() {
        self?.removeFromSuperview()
        self = nil
    }
    
}
