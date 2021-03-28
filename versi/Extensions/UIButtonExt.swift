//
//  UIButtonExt.swift
//  UAE Info
//
//  Created by sHiKoOo on 12/29/20.
//  Copyright © 2020 Ashraf Essam. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func changeButtonLines(numberOfLines: Int) {
        self.titleLabel?.numberOfLines = numberOfLines
        self.titleLabel?.minimumScaleFactor = 0.1
        self.clipsToBounds = true
    }
}
