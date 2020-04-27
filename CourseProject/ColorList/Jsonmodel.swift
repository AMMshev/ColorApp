//
//  ColorListNetwork.swift
//  CourseProject
//
//  Created by Artem Manyshev on 27.04.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//
//swiftlint:disable all
import Foundation

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
