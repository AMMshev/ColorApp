//
//  ColorListNetwork.swift
//  CourseProject
//
//  Created by Artem Manyshev on 27.04.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//
//swiftlint:disable all
import Foundation

class ColorsFromFileData {
    
    static let shared = ColorsFromFileData()
    private init() {}
    
// MARK: - make array of colors from json from file colorList.txt and sort it
    func makeURLToFile(name: String, fileExtension: String) -> URL? {
        guard  let URL = Bundle.main.url(forResource: name, withExtension: fileExtension) else { return nil }
        return URL
    }
    func takeColorsFromFile(urlToFile: URL?) -> [ColorList]? {
        var colorList: [ColorList]?
        guard let urlToFile = urlToFile else { return nil }
        do {
            let txtFile = try String(contentsOf: urlToFile)
            guard let data = txtFile.data(using: .utf8) else { return nil }
            colorList = try JSONDecoder().decode(ColorsSource.self, from: data).colors
//            colorList?.sort(by: {$0.hex < $1.hex})
        } catch {}
        return colorList
    }
// MARK: - method that takes a color and looks for the most similar in the array
    func makeModelOfColor(_ rColor: Int, _ gColor: Int, _ bColor: Int) -> ColorModel? {
        guard let allColors = ColorsFromFileData.shared.takeColorsFromFile(urlToFile:
            makeURLToFile(name: "colorList", fileExtension: "txt")) else { return nil }
        var recognizedColor: [ColorModel] = []
        var colorFromList: [ColorList] = []
        var error: Int = 0
        while colorFromList.isEmpty {
            colorFromList = allColors.filter({(
                (rColor - error)...(rColor + error)).contains($0.rgb.r) &&
                ((gColor - error)...(gColor + error)).contains($0.rgb.g) &&
                ((bColor - error)...(bColor + error)).contains($0.rgb.b)})
            error += 1
        }
        if colorFromList.first != nil {
            let model = ColorModel(name: colorFromList.first!.name,
                                   r: colorFromList.first!.rgb.r,
                                   g: colorFromList.first!.rgb.g,
                                   b: colorFromList.first!.rgb.b,
                                   hex: colorFromList.first!.hex)
            recognizedColor.append(model)
        }
        return recognizedColor.first
    }
}

// MARK: - json structure of colorList.txt
struct ColorsSource: Codable {
    let colors: [ColorList]
}

struct ColorList: Codable {
    let hex: String
    let name: String
    let rgb: Rgb
}

struct Rgb: Codable {
    let r: Int
    let g: Int
    let b: Int
}
