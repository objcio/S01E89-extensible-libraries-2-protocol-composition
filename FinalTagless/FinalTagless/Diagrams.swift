//
//  Diagrams.swift
//  FinalTagless
//
//  Created by Chris Eidhof on 01.02.18.
//  Copyright © 2018 objc.io. All rights reserved.
//

import Foundation

public protocol Diagram {
    static func rectangle(_ rect: CGRect, _ fill: NSColor) -> Self
    static func ellipse(_ rect: CGRect, _ fill: NSColor) -> Self
    static func combined(_ d1: Self, _ d2: Self) -> Self
}

public struct ContextRenderer {
    public let render: (CGContext) -> ()
    public init(_ draw: @escaping (CGContext) -> ()) {
        self.render = { context in
            context.saveGState()
            draw(context)
            context.restoreGState()
        }
    }
}

extension ContextRenderer: Diagram {
    public static func rectangle(_ rect: CGRect, _ fill: NSColor) -> ContextRenderer {
        return ContextRenderer { context in
            context.setFillColor(fill.cgColor)
            context.fill(rect)
        }
    }
    
    public static func ellipse(_ rect: CGRect, _ fill: NSColor) -> ContextRenderer {
        return ContextRenderer { context in
            context.setFillColor(fill.cgColor)
            context.fillEllipse(in: rect)
        }
    }
    
    public static func combined(_ d1: ContextRenderer, _ d2: ContextRenderer) -> ContextRenderer {
        return ContextRenderer { context in
            d1.render(context)
            d2.render(context)
        }
    }
}
