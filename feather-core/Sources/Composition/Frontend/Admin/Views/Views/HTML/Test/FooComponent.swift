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

public struct FooComponent: Component, FlowContent {

    let text: String

    public func content() -> some BasicTag {
        Span(text)
    }
}
