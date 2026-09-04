//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 07..
//

import CSS
import HTML
import SGML
import SVG
import WebComponents
import WebBuilders

public struct Icon: Leaf {

    public let svg: SVG
    public let `class`: String?

    public init(
        svg: SVG,
        class: String? = nil
    ) {
        self.svg = svg
        self.class = `class`
    }

    public func html() -> SVG {
        svg.if(`class` != nil) {
            $0.addAttribute(name: "class", value: `class`)
        }

    }
}
