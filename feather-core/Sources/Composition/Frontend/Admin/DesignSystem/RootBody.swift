//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import HTML
import CSS
import SGML
import WebComponents
import WebBuilders

public struct RootBody<T: Renderable>: Branch where T.HTML: FlowContent {

    public struct State: Sendable {
        public let content: T

        public init(
            content: T
        ) {
            self.content = content
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    // MARK: -

    public func rules() -> [any Rule] {
        []
    }

    public var children: [any Component] {
        state.content
    }

    public func html() -> Body {
        Body {
            state.content.html()
        }
    }
}
