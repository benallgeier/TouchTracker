//
//  Line.swift
//  TouchTracker
//
//  Created by Benjamin Allgeier on 10/6/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

import Foundation
import CoreGraphics

struct Line {
    
    var begin = CGPoint.zero
    var end = CGPoint.zero
    var thickness : CGFloat  // learn about initializers for structs...
    
    // angle in degrees
    // angle is between 0 and 180 (including 0)
    var angle: CGFloat {   // CGFloat because hue in UIColor(hue...) wants CGFloats
        let deltaY = end.y - begin.y
        let deltaX = end.x - begin.x
        let preAngle = atan2(deltaY, deltaX) // atan2 returns CGFloat
        let angle: CGFloat
        // if preAngle is negative, then add pi to it so that we
        // have a positive angle
        // note that because of adjustment below, don't include 0 in ?
        // (0 + 180) and then later (180 - 180) to get back to 0
        angle = preAngle > 0 ? preAngle : preAngle + CGFloat(M_PI)
        // this part is not necessary
        // but since the origin is in the top left and down is up, 
        // this will display the angle in familiar terms
        return (CGFloat(M_PI) - angle) * 180 / CGFloat(M_PI)
    } // end angle - computed property
    
} // end struct Line

