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

struct CheckboxField: Component, FlowContent {

    struct State: Object {
        var key: String
        var label: String
        var value: Bool
        var error: String?
    }

    var state: State

    func selectors() -> [any Selector] {
        Class("error") {
            Color(.red)
        }
    }

    func properties() -> [any Property] {
        Background(color: .red)
    }

    func content() -> some BasicTag {

        Span(state.label)

        Input()
            .type(.checkbox)
            .id(state.key)
            .name(state.key)
            .if(state.value) {
                $0.checked()
            }

        if let error = state.error {
            Span(error)
                .class("error")
        }
    }
}
