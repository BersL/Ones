//
//  bordedButton.swift
//  Ones
//
//  Created by Bers on 15/2/7.
//  Copyright (c) 2015年 Bers. All rights reserved.
//

import UIKit

class bordedButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = globalTextColor.CGColor
        self.layer.borderWidth = 0.6
    }
}
