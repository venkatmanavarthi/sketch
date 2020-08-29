//
//  Slate.swift
//  sketch
//
//  Created by manavarthivenkat on 27/08/20.
//  Copyright © 2020 manavarthi. All rights reserved.
//

import UIKit
class Slate : UIView {
    public var lines = [Line]()
    fileprivate var strokeColor : CGColor = UIColor.black.cgColor
    fileprivate var opacity : Float = 1
    fileprivate var lineWidth : Float = 10
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        lines.forEach { (line) in
            context.setStrokeColor(line.strokeColor)
            context.setAlpha(CGFloat(line.opacity))
            context.setLineWidth(CGFloat(line.strokeWidth))
            for (index,each_point) in line.point.enumerated(){
                if index == 0{
                    context.move(to: each_point)
                }else{
                    context.addLine(to: each_point)
                }
            }
            context.strokePath()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(Line(strokeColor: strokeColor, strokeWidth: Float(lineWidth), point: [], opacity: Float(opacity)))
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else {
            return
        }
//        print(point)
        guard var lastLine = lines.popLast()else {
            return
        }
        lastLine.point.append(point)
        lines.append(lastLine)
        setNeedsDisplay()
    }
    //MARK: - change stroke color
    func changeStrokeColor(color : CGColor){
        self.strokeColor = color
    }
    func changeOpacity(value : Float){
        self.opacity = value
    }
    func changeLineWidth(value : Float){
        self.lineWidth = value
    }
}
