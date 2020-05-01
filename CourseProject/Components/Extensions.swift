//
//  Extensions.swift
//  CourseProject
//
//  Created by Artem Manyshev on 30.04.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//
//swiftlint:disable all

import UIKit

extension UIView {
    func getPixelColorAt(point: CGPoint) -> UIColor {
        
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel,
                                width: 1,
                                height: 1,
                                bitsPerComponent: 8,
                                bytesPerRow: 4,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo.rawValue)
        var color = UIColor()
        if let context = context {
            context.translateBy(x: -point.x, y: -point.y)
            self.layer.render(in: context)
            
            color = UIColor(red: CGFloat(pixel[0])/255.0,
                                green: CGFloat(pixel[1])/255.0,
                                blue: CGFloat(pixel[2])/255.0,
                                alpha: CGFloat(pixel[3])/255.0)
        }
        return color
    }
    
    func makeConicGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.width - 30)
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.cyan.cgColor, UIColor.blue.cgColor, UIColor.purple.cgColor, UIColor.systemPink.cgColor]
        gradientLayer.cornerRadius = gradientLayer.frame.height / 2
        gradientLayer.type = .conic
        gradientLayer.locations = [0, 0.14, 0.29, 0.43, 0.57, 0.71, 0.85, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.borderWidth = 10
        gradientLayer.borderColor = UIColor.white.cgColor
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func makeConicGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.red.cgColor, UIColor.white.cgColor]
        gradientLayer.cornerRadius = gradientLayer.frame.height / 2
        gradientLayer.type = .axial
//        gradientLayer.locations = [0, 0.33, 0.67, 1]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
