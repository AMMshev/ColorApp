//
//  Enums.swift
//  CourseProject
//
//  Created by Artem Manyshev on 05.05.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//

import Foundation

enum CombinationMethods: String {
    case analogous
    case complementary
    case tetradic
    case triadic
    case monochromatic
}

enum SegueIdentificators: String {
    case colorCircle = "showColorCircle"
    case colorList = "showColorList"
    case threeColors = "showThreeColors"
    case colorDetail = "showColorDetail"
}

enum DarkModeColors: String {
    case blackWhiteBackColor = "backColor"
    case blackWhiteElementColor = "elementColor"
}

enum NetworkParameters: String {
    case clientID = "97fb096aa24f64d"
    case uploadURL = "https://api.imgur.com/3/image"
    case downloadURL = "https://api.imagga.com/v2/colors?image_url="
    case downloadAuthorisation = "Basic YWNjXzU5ZjJjMTA5ZWE5YmRiMjo2MTI2ZDA3ZTkzZjA4YTBkY2RmMmI4Yzc2Mjg3YzU3Yw=="
}

enum Keys: String {
    case colorTableViewCellID = "colorCell"
}
