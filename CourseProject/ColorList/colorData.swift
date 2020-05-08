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
    
    func takeColorsFromFile() -> [ColorList]? {
        var colorList: [ColorList]?
        guard let url = Bundle.main.url(forResource: "colorList", withExtension: "txt") else { return nil }
        do {
            let txtFile = try String(contentsOf: url)
            guard let data = txtFile.data(using: .utf8) else { return nil }
            colorList = try JSONDecoder().decode(ColorsSource.self, from: data).colors
            colorList?.sort(by: {$0.hex < $1.hex})
        } catch {}
        return colorList
    }
}

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
