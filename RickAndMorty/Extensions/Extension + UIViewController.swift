//
//  Extension + UIViewController.swift
//  RickAndMorty
//
//  Created by Кирилл Заборский on 07.07.2020.
//  Copyright © 2020 Кирилл Заборский. All rights reserved.
//

import UIKit

extension UIViewController {
    func transform(for view: UIView, nameAnimation: String, duration: CFTimeInterval, fromValue: Float, toValue: Float, autoreverses: Bool, repeatCount: Float) {
        
        let animation = CASpringAnimation(keyPath: nameAnimation)
        
        animation.duration = duration
        animation.fromValue = duration
        animation.toValue = fromValue
        animation.autoreverses = autoreverses
        animation.repeatCount = repeatCount
        view.layer.add(animation, forKey: nil)
    }
}
