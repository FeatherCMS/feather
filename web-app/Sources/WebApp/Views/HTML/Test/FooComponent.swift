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

struct FooComponent: Component, FlowContent {

    let text: String

    func content() -> some BasicTag {
        Span(text)
    }
}
