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

struct PasswordField: Component, FlowContent {

    struct State: Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    var state: State

    func selectors() -> [any Selector] {
        Class("error") {
            Color(.red)
        }
    }

    func content() -> some BasicTag {

        Span(state.label)

        Input()
            .type(.password)
            .id(state.key)
            .name(state.key)
            .value(state.value)

        if let error = state.error {
            Span(error)
                .class("error")
        }
    }
}
