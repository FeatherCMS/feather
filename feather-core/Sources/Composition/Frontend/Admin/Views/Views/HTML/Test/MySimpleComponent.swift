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

public struct MySimpleComponent: Component, FlowContent {

    let text: String

    public func properties() -> [any Property] {
        Background(color: .red)
        Color(.cyan)
    }

    public func content() -> some BasicTag {
        P(text)
        Span("foobarbaz")
    }
}
