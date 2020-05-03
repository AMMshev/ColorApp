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
    
}

extension NSObject {
    func setConstraintsOn(view: UIView,
                          parantView: UIView,
                          manualConstraints: Bool = true,
                          height: CGFloat? = nil,
                          width: CGFloat? = nil,
                          topConstant: CGFloat? = nil,
                          leadingConstant: CGFloat? = nil,
                          bottomConstant: CGFloat? = nil,
                          trailingConstant: CGFloat? = nil,
                          centeringxConstant: CGFloat? = nil,
                          centeringyConstant: CGFloat? = nil) {
        parantView.addSubview(view)
        if manualConstraints {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        if let height = height {
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width = width {
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let topConstant = topConstant {
            view.topAnchor.constraint(equalTo: parantView.topAnchor, constant: topConstant).isActive = true
        }
        if let bottomConstant = bottomConstant {
            view.bottomAnchor.constraint(equalTo: parantView.bottomAnchor, constant: bottomConstant).isActive = true
        }
        if let centeringxConstant = centeringxConstant {
            view.centerXAnchor.constraint(equalTo: parantView.centerXAnchor, constant: centeringxConstant).isActive = true
        }
        if let centeringyConstant = centeringyConstant {
            view.centerYAnchor.constraint(equalTo: parantView.centerYAnchor, constant: centeringyConstant).isActive = true
        }
        if let leadingConstant = leadingConstant {
            view.leadingAnchor.constraint(equalTo: parantView.leadingAnchor, constant: leadingConstant).isActive = true
        }
        if let trailingConstant = trailingConstant {
            view.trailingAnchor.constraint(equalTo: parantView.trailingAnchor, constant: trailingConstant).isActive = true
        }
    }
    
    func makeGradientLayerWith(width: CGFloat, height: CGFloat,
                                       colors: [CGColor],
                                       gradientType: CAGradientLayerType? = nil,
                                       cornerRadius: CGFloat? = nil,
                                       borderWidth: CGFloat? = nil, borderColor: CGColor? = nil) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        if let gradientType = gradientType {
            gradientLayer.type = gradientType
        }
        if gradientType == .conic {
            let colorsCount = colors.count
            var locations: [NSNumber] = [0]
            for location in 1...(colorsCount - 1) {
                locations.append(NSNumber(value: Double(location) / (Double(colorsCount) - 1)))
            }
            gradientLayer.locations = locations
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        }
        gradientLayer.colors = colors
        if let cornerRadius = cornerRadius {
            gradientLayer.cornerRadius = cornerRadius
        }
        if let borderWidth = borderWidth {
            gradientLayer.borderWidth = borderWidth
        }
        if let borderColor = borderColor {
            gradientLayer.borderColor = borderColor
        }
        return gradientLayer
    }
}
