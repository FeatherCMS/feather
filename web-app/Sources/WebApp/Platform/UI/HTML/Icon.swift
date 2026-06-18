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

struct Icon: Component, FlowContent {

    let svg: SVG
    let `class`: String?

    init(
        svg: SVG,
        class: String? = nil
    ) {
        self.svg = svg
        self.class = `class`
    }

    func content() -> some BasicTag {
        svg.if(`class` != nil) {
            $0.addAttribute(name: "class", value: `class`)
        }

    }
}
