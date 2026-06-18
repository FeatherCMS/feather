//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 01..
//

import CSS
import HTML
import SGML
import WebStandards

struct PageComponent: Component, FlowContent {

    func selectors() -> [any Selector] {
        Class("foo") {
            Color(.red)
        }
        Class("haha") {
            Color(.green)
        }
    }

    func content() -> some BasicTag {
        Div {
            P("Component subtree")
        }
        .class("haha")
    }
}
