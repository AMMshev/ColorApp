//
//  ColorCyrcleViewController.swift
//  CourseProject
//
//  Created by Artem Manyshev on 30.04.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//

import UIKit

class ColorCircleViewController: UIViewController {
    
    private let tapGesture = UITapGestureRecognizer()
    private let backgroundGradientLayer = CAGradientLayer()
    private var chosenColor: ColorModel = ColorModel(name: "", r: 0, g: 0, b: 0, hex: "")
    private let backgroundColorCircleView = UIView()
    private let colorCircleView: UIView = {
        let colorCircleView = UIView()
        colorCircleView.isUserInteractionEnabled = true
        return colorCircleView
    }()
    private let loupeView: UIImageView = {
        let loupeView = UIImageView()
        loupeView.isUserInteractionEnabled = true
        loupeView.image = UIImage(named: "loop")
        loupeView.layer.shadowColor = UIColor.gray.cgColor
        loupeView.layer.shadowOffset = CGSize(width: 2, height: 3)
        loupeView.layer.shadowOpacity = 0.5
        return loupeView
    }()
    private let loupeColorView: UIView = {
        let loopColorView = UIView()
        loopColorView.layer.cornerRadius = 30
        loopColorView.isUserInteractionEnabled = true
        return loopColorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        setConstraintsOn(view: backgroundColorCircleView,
                         parantView: view,
                         height: UIScreen.main.bounds.width,
                         width: UIScreen.main.bounds.width,
                         needCentering: true)
        
        setConstraintsOn(view: colorCircleView,
                         parantView: backgroundColorCircleView,
                         height: UIScreen.main.bounds.width - 30,
                         width: UIScreen.main.bounds.width - 30,
                         needCentering: true)
        
        view.addSubview(loupeView)
        setConstraintsOn(view: loupeColorView,
                         parantView: loupeView,
                         height: 60,
                         width: 60, needCentering: true,
                         yConstant: -16)
        loupeColorView.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(chosenColorTapped))
        colorCircleView.makeConicGradientBackground()
        backgroundGradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        backgroundGradientLayer.cornerRadius = backgroundGradientLayer.frame.height / 2
        backgroundColorCircleView.layer.insertSublayer(backgroundGradientLayer, at: 0)
    }
    
    private func setConstraintsOn(view: UIView,
                                  parantView: UIView,
                                  height: CGFloat,
                                  width: CGFloat,
                                  needCentering: Bool, xConstant: CGFloat? = 0, yConstant: CGFloat? = 0) {
        parantView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        if needCentering {
            view.centerXAnchor.constraint(equalTo: parantView.centerXAnchor, constant: xConstant ?? 0).isActive = true
            view.centerYAnchor.constraint(equalTo: parantView.centerYAnchor, constant: yConstant ?? 0).isActive = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor(named: "navBarColor")
    }
    
    private func outOfColor(location: CGPoint, view: UIView, borderSize: CGFloat) -> Bool {
        return pow(location.x / (view.bounds.width - borderSize) - 0.5, 2) + pow(location.y / (view.bounds.width - borderSize) - 0.5, 2) > 0.25
    }
    
    private func selectColorOn(locationOnMainView: CGPoint,
                               locationOnColorCircle: CGPoint,
                               locationOnTintLine: CGPoint) {
        loupeView.isHidden = false
        if !outOfColor(location: locationOnColorCircle, view: colorCircleView, borderSize: 10) {
            setloupe(mainLocation: locationOnMainView,
                     secondaryLocation: locationOnColorCircle,
                     isOnColorCircle: true)
            
        } else {
            if !outOfColor(location: locationOnTintLine, view: backgroundColorCircleView, borderSize: 0) {
                setloupe(mainLocation: locationOnMainView,
                         secondaryLocation: locationOnTintLine,
                         isOnColorCircle: false)
            } else {
                loupeView.isHidden = true
            }
        }
    }
    
    private func setloupe(mainLocation: CGPoint,
                          secondaryLocation: CGPoint,
                          isOnColorCircle: Bool) {
        loupeView.frame = CGRect(x: mainLocation.x - 39,
                                 y: mainLocation.y - 110,
                                 width: 78, height: 110)
        let color = backgroundColorCircleView.getPixelColorAt(point: secondaryLocation)
        loupeColorView.backgroundColor = color
        if isOnColorCircle { backgroundGradientLayer.colors = [UIColor.black.cgColor,
                                                               color.cgColor,
                                                               UIColor.white.cgColor] }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let firstLocation = touches.first?.location(in: self.view),
            let colorCircleLocation = touches.first?.location(in: colorCircleView),
            let backgroundColorCircleLocation = touches.first?.location(in: backgroundColorCircleView) else { return }
        selectColorOn(locationOnMainView: firstLocation,
                      locationOnColorCircle: colorCircleLocation,
                      locationOnTintLine: backgroundColorCircleLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let destinationLocation = touches.first?.location(in: self.view),
            let colorLocation = touches.first?.location(in: colorCircleView),
            let backgroundColorCircleLocation = touches.first?.location(in: backgroundColorCircleView) else { return }
        selectColorOn(locationOnMainView: destinationLocation,
                      locationOnColorCircle: colorLocation,
                      locationOnTintLine: backgroundColorCircleLocation)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let lastColorCircleLocation = touches.first?.location(in: colorCircleView),
            let lastColorTintLocation = touches.first?.location(in: backgroundColorCircleView) else { return }
        if !outOfColor(location: lastColorCircleLocation, view: colorCircleView, borderSize: 10) {
            setFinal(fromView: colorCircleView, location: lastColorCircleLocation)
        } else {
            if !outOfColor(location: lastColorTintLocation, view: backgroundColorCircleView, borderSize: 0) {
                setFinal(fromView: backgroundColorCircleView, location: lastColorTintLocation)
            } else {
                loupeView.isHidden = true
            }
        }
    }
    
    private func setFinal(fromView: UIView, location: CGPoint) {
        guard let color = fromView.getPixelColorAt(point: location).cgColor.components else { return }
        chosenColor =
            ColorsFromFileData.shared.makeModelOfColor(Int(color[0] * 255),
                                                       Int(color[1] * 255),
                                                       Int(color[2] * 255))
            ?? ColorModel(name: "", r: 0, g: 0, b: 0, hex: "")
    }
    
    @objc private func chosenColorTapped() {
        loupeView.isHidden = true
        self.performSegue(withIdentifier: "showColorDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showColorDetail" {
            let destinationVC = segue.destination as? DetailColorViewController
            destinationVC?.color = chosenColor
        }
    }
}
