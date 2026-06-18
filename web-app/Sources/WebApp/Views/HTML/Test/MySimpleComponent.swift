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

struct MySimpleComponent: Component, FlowContent {

    let text: String

    func properties() -> [any Property] {
        Background(color: .red)
        Color(.cyan)
    }

    func content() -> some BasicTag {
        P(text)
        Span("foobarbaz")
    }
}
