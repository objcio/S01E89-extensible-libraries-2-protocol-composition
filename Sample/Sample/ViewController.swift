//
//  ViewController.swift
//  Sample
//
//  Created by Chris Eidhof on 01.02.18.
//  Copyright © 2018 objc.io. All rights reserved.
//

import Cocoa

final class LayerView: NSView {
    convenience init(_ rect: CGRect, _ layer: CALayer) {
        self.init(frame: rect)
        self.layer = layer
        self.layerUsesCoreImageFilters = true
    }
    
    override var isFlipped: Bool { return true }
}

final class CGContextView: NSView {
    let render: (CGContext) -> ()
    init(frame: CGRect, render: @escaping (CGContext) -> ()) {
        self.render = render
        super.init(frame: frame)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ dirtyRect: NSRect) {
        render(NSGraphicsContext.current!.cgContext)
    }
    
    override var isFlipped: Bool { return true }
}







import FinalTagless

struct Layer {
    let layer: CALayer
}

extension Layer: Diagram {
    static func rectangle(_ rect: CGRect, _ fill: NSColor) -> Layer {
        let result = CALayer()
        result.frame = rect
        result.backgroundColor = fill.cgColor
        return Layer(layer: result)
    }

    static func ellipse(_ rect: CGRect, _ fill: NSColor) -> Layer {
        let result = CAShapeLayer()
        result.path = CGPath(ellipseIn: rect, transform: nil)
        result.fillColor = fill.cgColor
        return Layer(layer: result)
    }

    static func combined(_ d1: Layer, _ d2: Layer) -> Layer {
        let result = CALayer()
        result.addSublayer(d1.layer)
        result.addSublayer(d2.layer)
        return Layer(layer: result)
    }
}

protocol Alpha {
    static func alpha(_ alpha: CGFloat, _ d: Self) -> Self
}

extension Layer: Alpha {
    static func alpha(_ alpha: CGFloat, _ d: Layer) -> Layer {
        let result = CALayer()
        result.opacity = Float(alpha)
        result.addSublayer(d.layer)
        return Layer(layer: result)
    }
}

func diagram<D: Diagram & Alpha>() -> D {
    return D.combined(
        .rectangle(CGRect(x: 20, y: 20, width: 100, height: 100), .red),
        .alpha(0.5, .ellipse(CGRect(x: 60, y: 60, width: 80, height: 100), .green))
    )
}

class ViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let r: Layer = diagram()
        let diagramView = LayerView(frame, r.layer)
        view.addSubview(diagramView)
    }
}





