//
//  Constants.swift
//  DisplayData
//
//  Created by Aadesh Maheshwari on 1/19/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit

class Constants: NSObject {

}

extension UIColor {
    static func themeRedColor(withalpha alpha: CGFloat = 0.6) -> UIColor {
        return UIColor.red.withAlphaComponent(alpha)
    }
    static func themeGreenColor(withalpha alpha: CGFloat = 0.6) -> UIColor {
        return UIColor.green.withAlphaComponent(alpha)
    }
}
