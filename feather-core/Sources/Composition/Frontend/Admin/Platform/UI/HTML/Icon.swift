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
import WebStandards

public struct Icon: Component, FlowContent {

    public let svg: SVG
    public let `class`: String?

    public init(
        svg: SVG,
        class: String? = nil
    ) {
        self.svg = svg
        self.class = `class`
    }

    public func content() -> some BasicTag {
        svg.if(`class` != nil) {
            $0.addAttribute(name: "class", value: `class`)
        }

    }
}
