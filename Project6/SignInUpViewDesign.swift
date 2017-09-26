//
//  SignInUpViewDesign.swift
//  Project6
//
//  Created by  Yujiro Saito on 2017/06/11.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

class SignInUpViewDesign: UIView, CAAnimationDelegate {
    let gradientLayer = CAGradientLayer()
    
    /*
     
     let colors: [CGColor] = [
     #colorLiteral(red: 0.09411764706, green: 0.3058823529, blue: 0.4078431373, alpha: 1),
     #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
     ].map { $0.cgColor }
     
     
     let colors: [CGColor] = [
     #colorLiteral(red: 0.03529411765, green: 0.1254901961, blue: 0.2470588235, alpha: 1),
     #colorLiteral(red: 0.3254901961, green: 0.4705882353, blue: 0.5843137255, alpha: 1)
     ].map { $0.cgColor }
     
     let colors: [CGColor] = [
     #colorLiteral(red: 0.07239989191, green: 0.1719785929, blue: 0.1734149456, alpha: 1),
     #colorLiteral(red: 0.3254901961, green: 0.4705882353, blue: 0.5843137255, alpha: 1)
     ].map { $0.cgColor }


     let colors: [CGColor] = [
     #colorLiteral(red: 0.07239989191, green: 0.1719785929, blue: 0.1734149456, alpha: 1),
     #colorLiteral(red: 0.3254901961, green: 0.4705882353, blue: 0.5843137255, alpha: 1)
     ].map { $0.cgColor }

     let colors: [CGColor] = [
     #colorLiteral(red: 0.07239989191, green: 0.1719785929, blue: 0.1734149456, alpha: 1),
     #colorLiteral(red: 0.3254901961, green: 0.4705882353, blue: 0.5843137255, alpha: 1)
     ].map { $0.cgColor }

    */
    
    let colors: [CGColor] = [
        #colorLiteral(red: 0.02375288887, green: 0.02398806599, blue: 0.02398806599, alpha: 1),
        #colorLiteral(red: 0.1821230025, green: 0.1839262005, blue: 0.1839262005, alpha: 1)
        ].map { $0.cgColor }

    
    var currentIndex = (start: 1, end: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        gradientLayer.colors = [colors[currentIndex.start], colors[currentIndex.end]]
        
        gradientLayer.drawsAsynchronously = true
        layer.addSublayer(gradientLayer)
        
       // aniamte()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    func aniamte() {
        currentIndex = ((currentIndex.start + 1) % colors.count, (currentIndex.end + 1) % colors.count)
        
        let fromColors = gradientLayer.colors
        let anim = CABasicAnimation(keyPath: "colors")
        anim.fromValue = fromColors
        
        anim.toValue =  [colors[currentIndex.start], colors[currentIndex.end]]
        
        anim.duration = 5
                anim.delegate = self
        gradientLayer.add(anim, forKey: "colors")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        gradientLayer.colors = [colors[currentIndex.start], colors[currentIndex.end]]
        aniamte()
    }
}
