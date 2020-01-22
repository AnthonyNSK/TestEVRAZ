//
//  MainView.swift
//  TestEVRAZ
//
//  Created by Kuzhelev Anton on 22.01.2020.
//  Copyright © 2020 Kuzhelev Anton. All rights reserved.
//

import UIKit

//@IBDesignable
class MainView: UIView {

    override func draw(_ rect: CGRect) {
        
        let track = UIBezierPath(ovalIn: CGRect(x: 50, y: 50, width: rect.width - 100, height: rect.height - 100))
        let color = UIColor.gray
        color.setStroke()
        track.lineWidth = 50
        track.stroke()
        
    }
}
