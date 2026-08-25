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

public struct EmailField: Component, FlowContent {

    public struct State: Object {
        public var key: String
        public var label: String
        public var value: String?
        public var error: String?

        public init(
            key: String,
            label: String,
            value: String? = nil,
            error: String? = nil
        ) {
            self.key = key
            self.label = label
            self.value = value
            self.error = error
        }
    }

    var state: State

    public init(state: State) {
        self.state = state
    }

    public func selectors() -> [any Selector] {
        Class("error") {
            Color(.red)
        }
    }

    public func content() -> some BasicTag {

        Span(state.label)

        Input()
            .type(.text)
            .id(state.key)
            .name(state.key)
            .value(state.value)

        if let error = state.error {
            Span(error)
                .class("error")
        }
    }
}
