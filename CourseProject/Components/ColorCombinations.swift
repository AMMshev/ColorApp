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
    
    func mono() {
    }
    
    func contrast(angleForNearColor: Double) -> [CombinationColor] {
        let secondColor = CombinationColor(colorHue: originalColorHue + 0.5 + angleForNearColor, colorSaturation: originalColorSaturation, colorBrightness: originslColorBrightness)
        var combinationValues = [CombinationColor]()
        combinationValues.append(secondColor)
        return combinationValues
    }
    
    func triad(angleBetweenTwoColors: Double) -> [CombinationColor] {
        let secondColor = CombinationColor(colorHue: originalColorHue + (1.0 - angleBetweenTwoColors) / 2, colorSaturation: originalColorSaturation, colorBrightness: originslColorBrightness)
        let thirdColor = CombinationColor(colorHue: (secondColor.colorHue) + angleBetweenTwoColors, colorSaturation: originalColorSaturation, colorBrightness: originslColorBrightness)
        var combinationValues = [CombinationColor]()
        combinationValues.append(secondColor)
        combinationValues.append(thirdColor)
        return combinationValues
    }
    
    func tetrad(angleToCombinatedColor: Double) -> [CombinationColor] {
        let secondColor = CombinationColor(colorHue: originalColorHue + 0.5, colorSaturation: originalColorSaturation, colorBrightness: originslColorBrightness)
        let thirdColor = CombinationColor(colorHue: originalColorHue + angleToCombinatedColor, colorSaturation: originalColorSaturation, colorBrightness: originslColorBrightness)
        let fourthColor = CombinationColor(colorHue: (thirdColor.colorHue) + 0.5, colorSaturation: originalColorSaturation, colorBrightness: originslColorBrightness)
        var combinationValues = [CombinationColor]()
        combinationValues.append(secondColor)
        combinationValues.append(thirdColor)
        combinationValues.append(fourthColor)
        return combinationValues
    }
    
    func analog(angleToSecondColor: Double) -> [CombinationColor] {
        let secondColor = CombinationColor(colorHue: (originalColorHue + angleToSecondColor), colorSaturation: originalColorSaturation, colorBrightness: originslColorBrightness)
        let thirdColor = CombinationColor(colorHue: originalColorHue - angleToSecondColor + 1, colorSaturation: originalColorSaturation, colorBrightness: originslColorBrightness)
        var combinationValues = [CombinationColor]()
        combinationValues.append(secondColor)
        combinationValues.append(thirdColor)
        return combinationValues
    }
    
    func accentAnalog(angleToThirdColor: Double) -> [CombinationColor] {
        let secondColor = CombinationColor(colorHue: originalColorHue + 0.5, colorSaturation: originalColorSaturation, colorBrightness: originslColorBrightness)
        let thirdColor = CombinationColor(colorHue: originalColorHue + angleToThirdColor, colorSaturation: originalColorSaturation, colorBrightness: originslColorBrightness)
        let fourthColor = CombinationColor(colorHue: originalColorHue - angleToThirdColor + 1, colorSaturation: originalColorSaturation, colorBrightness: originslColorBrightness)
        var combinationValues = [CombinationColor]()
        combinationValues.append(secondColor)
        combinationValues.append(thirdColor)
        combinationValues.append(fourthColor)
        return combinationValues
    }
}

struct CombinationColor {
    var colorHue: Double
    var colorSaturation: Double
    var colorBrightness: Double
}
