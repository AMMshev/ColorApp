//
//  ThreeColorsViewController.swift
//  CourseProject
//
//  Created by Артем Манышев on 26.03.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//

import UIKit

class ThreeColorsViewController: UIViewController {
    
    @IBOutlet weak var sourceImage: UIImageView!
    @IBOutlet weak var mainColor: UIView!
    @IBOutlet weak var secondaryColor: UIView!
    @IBOutlet weak var additionalColor: UIView!
    
    static var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceImage.image = ThreeColorsViewController.image
        Networking.shared.uploadData(image: ThreeColorsViewController.image, completion: { imageLink in
            print(imageLink as Any)
            Networking.shared.getData(imageLink: imageLink ?? "", completion: { data in
                do {
                    let json = try JSONDecoder().decode(JSONAnswer.self, from: data )
                    var rForRGB: [Int] = []
                    var bForRGB: [Int] = []
                    var gForRGB: [Int] = []
                    json.result.colors.image_colors.forEach({rForRGB.append($0.r)})
                    json.result.colors.image_colors.forEach({gForRGB.append($0.g)})
                    json.result.colors.image_colors.forEach({bForRGB.append($0.b)})
                    DispatchQueue.main.sync {
                        self.mainColor.backgroundColor = UIColor(red: CGFloat(rForRGB[0]) / 255,
                                                                 green: CGFloat(gForRGB[0]) / 255,
                                                                 blue: CGFloat(bForRGB[0]) / 255,
                                                                 alpha: 1)
                        self.secondaryColor.backgroundColor = UIColor(red: CGFloat(rForRGB[1]) / 255,
                                                                      green: CGFloat(gForRGB[1]) / 255,
                                                                      blue: CGFloat(bForRGB[1]) / 255,
                                                                      alpha: 1)
                        self.additionalColor.backgroundColor = UIColor(red: CGFloat(rForRGB[2]) / 255,
                                                                       green: CGFloat(gForRGB[2]) / 255,
                                                                       blue: CGFloat(bForRGB[2]) / 255,
                                                                       alpha: 1)
                        self.mainColor.setNeedsDisplay()
                        self.secondaryColor.setNeedsDisplay()
                        self.additionalColor.setNeedsDisplay()
                    }
                } catch {
                    print("JSON error")
                }
            })
        })
    }
}
