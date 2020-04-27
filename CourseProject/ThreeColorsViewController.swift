//
//  ThreeColorsViewController.swift
//  CourseProject
//
//  Created by Артем Манышев on 26.03.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//

import UIKit

class ThreeColorsViewController: UIViewController {
    
    @IBOutlet weak var sourceImageView: UIImageView!
    @IBOutlet weak var mainColor: UIView!
    @IBOutlet weak var secondaryColor: UIView!
    @IBOutlet weak var additionalColor: UIView!
    
    var sourceImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let sourceImage = sourceImage else { return }
        sourceImageView.image = sourceImage
        Networking.shared.uploadData(image: sourceImage, completion: { imageLink in
            guard let imageLink = imageLink else { return }
            print(imageLink)
            Networking.shared.getData(imageLink: imageLink, completion: { data in
                do {
                    let json = try JSONDecoder().decode(JSONAnswer.self, from: data )
                    var rForRGB: [Int] = []
                    var bForRGB: [Int] = []
                    var gForRGB: [Int] = []
                    json.result.colors.image_colors.forEach({rForRGB.append($0.r)})
                    json.result.colors.image_colors.forEach({gForRGB.append($0.g)})
                    json.result.colors.image_colors.forEach({bForRGB.append($0.b)})
                    DispatchQueue.main.sync {
                        self.mainColor.backgroundColor = UIColor(red: rForRGB[0],
                                                                 green: gForRGB[0],
                                                                 blue: bForRGB[0],
                                                                 alpha: 1)
                        self.secondaryColor.backgroundColor = UIColor(red: rForRGB[1],
                                                                      green: gForRGB[1],
                                                                      blue: bForRGB[1],
                                                                      alpha: 1)
                        self.additionalColor.backgroundColor = UIColor(red: rForRGB[2],
                                                                       green: gForRGB[2],
                                                                       blue: bForRGB[2],
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
