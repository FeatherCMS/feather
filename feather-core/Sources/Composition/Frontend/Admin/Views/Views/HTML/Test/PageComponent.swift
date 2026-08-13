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

public struct PageComponent: Component, FlowContent {

    public func selectors() -> [any Selector] {
        Class("foo") {
            Color(.red)
        }
        Class("haha") {
            Color(.green)
        }
    }

    public func content() -> some BasicTag {
        Div {
            P("Component subtree")
        }
        .class("haha")
    }
}
