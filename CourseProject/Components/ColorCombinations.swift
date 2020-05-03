//
//  colorCombinations.swift
//  colorApplication
//
//  Created by Артем Манышев on 22.02.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//

import Foundation

class Combinations {
    let originalColorHue: Double
    let originalColorSaturation: Double
    let originslColorBrightness: Double
    
    init(originalColorHue: Double, originalColorSaturation: Double, originslColorBrightness: Double) {
        self.originalColorHue = originalColorHue
        self.originalColorSaturation = originalColorSaturation
        self.originslColorBrightness = originslColorBrightness
    }
    
    func combination(type: CombinationMethods) -> [CombinationColor] {
        var secondColor: CombinationColor?
        var thirdColor: CombinationColor?
        var fourthColor: CombinationColor?
        switch type {
        case .analogous:
            secondColor = CombinationColor(colorHue: originalColorHue + 1 / 8,
                                           colorSaturation: originalColorSaturation,
                                           colorBrightness: originslColorBrightness)
            thirdColor = CombinationColor(colorHue: originalColorHue - 1 / 8 + 1,
                                          colorSaturation: originalColorSaturation,
                                          colorBrightness: originslColorBrightness)
        case .complementary:
            secondColor = CombinationColor(colorHue: originalColorHue + 0.5,
                                           colorSaturation: originalColorSaturation,
                                           colorBrightness: originslColorBrightness)
        case .tetradic:
            secondColor = CombinationColor(colorHue: originalColorHue + 0.5,
                                           colorSaturation: originalColorSaturation,
                                           colorBrightness: originslColorBrightness)
            thirdColor = CombinationColor(colorHue: originalColorHue + 0.25,
                                          colorSaturation: originalColorSaturation,
                                          colorBrightness: originslColorBrightness)
            fourthColor = CombinationColor(colorHue: originalColorHue + 0.75,
                                           colorSaturation: originalColorSaturation,
                                           colorBrightness: originslColorBrightness)
        case .triadic:
            secondColor = CombinationColor(colorHue: originalColorHue + 1 / 3,
                                           colorSaturation: originalColorSaturation,
                                           colorBrightness: originslColorBrightness)
            thirdColor = CombinationColor(colorHue: originalColorHue + 2 / 3,
                                          colorSaturation: originalColorSaturation,
                                          colorBrightness: originslColorBrightness)
        }
        var combinationValues: [CombinationColor] = []
        if let secondColor = secondColor {
            combinationValues.append(secondColor)
        }
        if let thirdColor = thirdColor {
            combinationValues.append(thirdColor)
        }
        if let fourthColor = fourthColor {
            combinationValues.append(fourthColor)
        }
        return combinationValues
    }
}

struct CombinationColor {
    var colorHue: Double
    var colorSaturation: Double
    var colorBrightness: Double
}
