//
//  ColorCyrcleViewController.swift
//  CourseProject
//
//  Created by Artem Manyshev on 30.04.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//

import UIKit

class ColorCircleViewController: UIViewController {
    
    let tapGesture = UITapGestureRecognizer()
    var chosenColor: ColorModel = ColorModel(name: "", r: 0, g: 0, b: 0, hex: "")
    let colorCircleView: UIImageView = {
        let colorCircleView = UIImageView()
        colorCircleView.translatesAutoresizingMaskIntoConstraints = false
        colorCircleView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        colorCircleView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        colorCircleView.image = UIImage(named: "colorCircle")
        return colorCircleView
    }()
    
    let loopView: UIImageView = {
        let loopView = UIImageView()
        loopView.isUserInteractionEnabled = true
        loopView.image = UIImage(named: "loop")
        loopView.layer.shadowColor = UIColor.gray.cgColor
        loopView.layer.shadowOffset = CGSize(width: 2, height: 3)
        loopView.layer.shadowOpacity = 0.5
        return loopView
    }()
    
    let loopColorView: UIView = {
        let loopColorView = UIView()
        loopColorView.translatesAutoresizingMaskIntoConstraints = false
        loopColorView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        loopColorView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        loopColorView.layer.cornerRadius = 30
        loopColorView.isUserInteractionEnabled = true
        return loopColorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        view.addSubview(colorCircleView)
        colorCircleView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        colorCircleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        colorCircleView.isUserInteractionEnabled = true
        view.addSubview(loopView)
        loopView.addSubview(loopColorView)
        loopColorView.centerYAnchor.constraint(equalTo: loopView.centerYAnchor, constant: -16).isActive = true
        loopColorView.centerXAnchor.constraint(equalTo: loopView.centerXAnchor).isActive = true
        colorCircleView.bringSubviewToFront(loopView)
        loopView.bringSubviewToFront(loopColorView)
        tapGesture.addTarget(self, action: #selector(chosenColorTapped))
        loopColorView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor(named: "navBarColor")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let firstLocation = touches.first?.location(in: self.view) else { return }
        guard let colorLocation = touches.first?.location(in: colorCircleView) else { return }
        loopView.isHidden = false
        loopView.frame = CGRect(x: firstLocation.x - 39, y: firstLocation.y - 110, width: 78, height: 110)
        loopColorView.backgroundColor = colorCircleView.getPixelColorAtPoint(point: colorLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let destinationLocation = touches.first?.location(in: self.view) else { return }
        guard let colorLocation = touches.first?.location(in: colorCircleView) else { return }
        loopView.frame = CGRect(x: destinationLocation.x - 39, y: destinationLocation.y - 110, width: 78, height: 110)
        loopColorView.backgroundColor = colorCircleView.getPixelColorAtPoint(point: colorLocation)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let lastColorLocation = touches.first?.location(in: colorCircleView),
            let color = colorCircleView.getPixelColorAtPoint(point: lastColorLocation).cgColor.components else { return }
        chosenColor = ColorsFromFileData.shared.makeModelOfColor(Int(color[0] * 255),
                                                                 Int(color[1] * 255),
                                                                 Int(color[2] * 255)) ?? ColorModel(name: "",
                                                                                                    r: 0,
                                                                                                    g: 0,
                                                                                                    b: 0,
                                                                                                    hex: "")
    }
    
    @objc func chosenColorTapped() {
        loopView.isHidden = true
        self.performSegue(withIdentifier: "showColorDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? DetailColorViewController
        destinationVC?.color = chosenColor
    }
}
