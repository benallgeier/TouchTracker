//
//  DrawView.swift
//  TouchTracker
//
//  Created by Benjamin Allgeier on 10/6/16.
//  Copyright © 2016 ballgeier. All rights reserved.
//

//import Foundation
import UIKit

class DrawView: UIView, UIGestureRecognizerDelegate {
    
    // MARK: Properties
    
//    var currentLine: Line?     // used for single touch
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    var selectedLineIndex: Int? {
        didSet {
            if selectedLineIndex == nil {
                let menu = UIMenuController.shared
                menu.setMenuVisible(false, animated: true)
//                deleteMenuPresented = false
            } // end if
        } // end didSet
    } // end selectedLineIndex
    
    // previous method used to fix bug in silver challenge
//    var deleteMenuPresented: Bool = false  // if true, then we have a selected
//                                           // line that we don't want to move
//                                           // in moveLine(_:) and we want to set 
//                                           // selectedLineIndex to nil
    
    var moveRecognizer: UIPanGestureRecognizer!
    var longPressRecognizer: UILongPressGestureRecognizer!
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    // for a different coloring option -- use of these below is commented out
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        } // end didSet
    } // end var finishedLineColor
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        } // end didSet
    } // end var currentLineColor
    
    @IBInspectable var lineThickness : CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        } // end didSet
    } // end var lineThickness
    
    // MARK: init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        tapRecognizer.delaysTouchesBegan = true  // we put this before the longPressRecognizer
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        addGestureRecognizer(longPressRecognizer)
        
        moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveLine(_:)))
        moveRecognizer.delegate = self
        moveRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(moveRecognizer)
        
    } // end init?(coder:)
    
    // MARK: - Drawing methods
    
    func strokeLine(_ line: Line) {
        let path = UIBezierPath()
        //        path.lineWidth = 10
        path.lineWidth = line.thickness  // was lineThickness
        path.lineCapStyle = CGLineCap.round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    } // end strokeLine(_:withWidth:)
    
    // a UIView method
    override func draw(_ rect: CGRect) {
        // Draw finished lines in black
//        UIColor.black.setStroke()
        
        // @IBInspectable
//        finishedLineColor.setStroke()
        
        for line in finishedLines {
            let color = UIColor(hue: line.angle / CGFloat(180), saturation: 1, brightness: 1, alpha: 1)
            color.setStroke()
            strokeLine(line)
        } // end for
        
//        if let line = currentLine {
//            // If there is a line currently beign drawn, do it in red
//            UIColor.red.setStroke()
//            strokeLine(line)
//        } // end if let
        
        // Draw current lines in red
//        UIColor.red.setStroke()
        
        // @IBInspectable
//        currentLineColor.setStroke()
        for (_, line) in currentLines {
            let color = UIColor(hue: line.angle / CGFloat(180), saturation: 1, brightness: 1, alpha: 1)
            color.setStroke()
            strokeLine(line)
        } // end for
        
        // color selected line green
        if let index = selectedLineIndex {
            UIColor.green.setStroke()
            let selectedLine = finishedLines[index]
            strokeLine(selectedLine)
        } // end if let
    } // end draw(_:)
    
    func indexOfLineAtPoint(_ point: CGPoint) -> Int? {
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
            // Check a few points
            for t in stride(from: 0, to: 1, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * CGFloat(t))
                let y = begin.y + ((end.y - begin.y) * CGFloat(t))
                
                // If the tapped point is within 20 points, let's return this line
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                } // end if
            } // end for
        } // end for
        
        // If nothing is close enough to the tapped point, then we did not select a line
        return nil
    } // end indexOfLineAtPoint(_:)
    
    func thicknessFromVelocity(_ velocity: CGPoint) -> CGFloat {
        let velocity = moveRecognizer.velocity(in: self)
        let thickness = hypot(velocity.x, velocity.y) / 100
        return thickness
    } // end thicknessFromVelocity
    
    // MARK: - UIResponder methods 
    // (UIView is a subclass of UIResponder)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
        
//        // Get location of the touch in view's coordinate system
//        let location = touch.location(in: self)
//
//        currentLine = Line(begin: location, end: location)
        
        // Let's put in a log statement to see the order of events
//        print(#function)
        
        // don't want moveLine(_:) to move a selected line - unselect line if necessary
//        selectedLineIndex = nil   // this is too late -- need to look at pan
        
        for touch in touches {
            print("touchesBegan: location is \(touch.location(in: self))")

            let location = touch.location(in: self)
            
            let thickness = thicknessFromVelocity(moveRecognizer.velocity(in: self))
            let newLine = Line(begin: location, end: location, thickness: thickness)
            
            let key = NSValue(nonretainedObject: touch)
            print("key is \(key)")
            currentLines[key] = newLine
        } // end for
        
        setNeedsDisplay()
    } // end touchesBegan(_:with:)
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
//        let location = touch.location(in: self)
        
//        currentLine?.end = location
        
        // Let's put in a log statement to see the order of events
//        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            print("touchesMoved: location is \(touch.location(in: self))")
            
            currentLines[key]?.end = touch.location(in: self)
            // only change thickness if it increased
            let thickness = thicknessFromVelocity(moveRecognizer.velocity(in: self))
            
            // only change thickness if increased
            if currentLines[key] != nil {
                if thickness > currentLines[key]!.thickness {
                    currentLines[key]!.thickness = thickness
                } // end if
            } // end if
            
            // see comments in touchesEnded. Structs are passed in by value
            // so we were not updating original line
            
//            if var line = currentLines[key] {
//                line.end = touch.location(in: self)
//                let thickness = thicknessFromVelocity(moveRecognizer.velocity(in: self))
//                line.thickness = thickness
//            } // end if var
            
        } // end for
        setNeedsDisplay()
    } // end touchesMoved(_:with:)
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if var line = currentLine {
//            let touch = touches.first!
//            let location = touch.location(in: self)
//            line.end = location
//            
//            finishedLines.append(line)
//        } // end if var
//        currentLine = nil
        
        // Let's put in a log statement to see the order of events
//        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            print("touchesEnded: location is \(touch.location(in: self))")
            
            // I don't think the location has changed since last touchesMoved was called
            // but just in case
            currentLines[key]?.end = touch.location(in: self)
            if let line = currentLines[key] {  // line is an instance of struct
                                               // can't change properties in an if let 
                                               // so we use if var
                
                                               // changed to if let since commented out mutation
                
                
                // comments above are true -- BUT
                // even more important - structs are passed by value
                // so we are not changing the original line
                // there is no harm here because the location has not changed 
                // since last touchesMoved was called and finishedLines 
                // is an array of Lines (so passing in the same value)
                // and currentLines is being checked by its key
                
//                line.end = touch.location(in: self)  // replaced this above if var
                                                       // but still don't think its necessary
                
//                let thickness = thicknessFromVelocity(moveRecognizer.velocity(in: self))
//                line.thickness = thickness
                
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
                print("angle of line is \(line.angle)")
            } // end if var
        } // end for
        
        setNeedsDisplay()
    } // end touchesEnded(_:with:)
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Let's put a log statement to see the order of events
        print(#function)
        
        currentLines.removeAll()
        
        setNeedsDisplay()
    } // end touchesCancelled(_:with:)
    
    // MARK: - Actions
    
    func doubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a double tap")
        
        // if we have a line selected, then selectedLineIndex has a value
        // then in draw(_:) we access finishedLines[selectedLineIndex]
        // leading to a trap
        // so if we double tap, we should have no line selected
        selectedLineIndex = nil
        currentLines.removeAll(keepingCapacity: false)  // not sure why this is necessary but...
        finishedLines.removeAll(keepingCapacity: false)
        setNeedsDisplay()
    } // end doubleTap(_:)
    
    func tap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a tap")
        
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLineAtPoint(point)
        
        // Grab the menu controller
        // want this outside of if because
        // we hide it in the else
        // in case the user taps to select a line
        // and then taps elsewhere to cancel that action
        let menu = UIMenuController.shared
        
        if selectedLineIndex != nil {
            
//            deleteMenuPresented = true
            
            // Make DrawVivew the target of menu item action messages
            becomeFirstResponder()
            
            // Create a new "Delete" UIMenuItem
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(deleteLine(_:)))
            menu.menuItems = [deleteItem]
            
            // Tell the menu where it should come from and show it
            menu.setTargetRect(CGRect(x: point.x, y: point.y, width: 2, height: 2), in: self)
            menu.setMenuVisible(true, animated: true)
        } // end if
        else {
               // we are only here if selectedLineIndex is set to nil
               // in which case our propertyObserver does this
               // so this seems to be unnecessary
            
            // Hide the menu if no line is selected
//            menu.setMenuVisible(false, animated: true)
        } // end else
        
        setNeedsDisplay()
    } // end tap(_:)
    
    func deleteLine(_ sender: AnyObject) {
        // Remove the selected line from the list of finishedLines
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            selectedLineIndex = nil
            
            // Redraw everything
            setNeedsDisplay()
        } // end if let
    } // end deleteLine(_:)
    
    func longPress(_ gestureRecognizer: UIGestureRecognizer) {
//        print("Recognized a long press")
        
        if gestureRecognizer.state == .began {
            print("longPress began")
            selectedLineIndex = nil    // removes delete menu if present
            let point = gestureRecognizer.location(in: self)
            selectedLineIndex = indexOfLineAtPoint(point)
            
            // purpose of this???
            if selectedLineIndex != nil {
                currentLines.removeAll(keepingCapacity: false)
            } // end if
            
        } // end if
        else if gestureRecognizer.state == .ended {
            print("longPress ended")
            selectedLineIndex = nil
        } // end else if
        
        setNeedsDisplay()
    } // end longPress(_:)
    
    func moveLine(_ gestureRecognizer: UIPanGestureRecognizer) {
//        print("Recognized a pan")
        
        if gestureRecognizer.state == .began {
            print("pan started")
        }
        else if gestureRecognizer.state == .changed {
            // note we can use gestureRecognizer or moveRecognizer
            print("\n pan changed with velocity \(gestureRecognizer.velocity(in: self)) which has length \( hypot( moveRecognizer.velocity(in: self).x, moveRecognizer.velocity(in: self).y)) \n")
        }
        else if gestureRecognizer.state == .ended {
            print("pan ended")
        }
        
        // to prevent previously selected line from moving
        // we only want to move line if selectedLineIndex is determined from a longPress
        // if selectedLineIndex is from a tap (which promts delete menu),
        // then we want to unselect that line and do no more
        //        if deleteMenuPresented == true {
        //            selectedLineIndex = nil
        //            return
        //        }

        
        // more of a direct technique -- test if longPress in .changed
        if longPressRecognizer.state != .changed {
            selectedLineIndex = nil // we may have a selected line and delete menu present
            return
        }
        
        // If a line is selected
        if let index = selectedLineIndex {
            // When the pan recognizer changes its position...
            if gestureRecognizer.state == .changed {
                // How far has the pan moved
                let translation = gestureRecognizer.translation(in: self)
                
                // Add the translation to the current beginning and end points of the line
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                
                // Redraw the screen
                setNeedsDisplay()
            } // end if
        } // end if let
        else {
            // If no line is selected, do not do anything
            return
        }

    } // end moveLine(_:)
    
    // MARK: - UIGestureRecognizerDelegate methods
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    } // end gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:)
    
    // this gets called before pan started and the touch is the same as
    // in touchBegan -- but not sure if this helps here
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        print(#function + " \(touch.location(in: self))")
//
//        return true
//    } // end gestureRecognizer(_:shouldReceive:)
    
} // end class DrawView
