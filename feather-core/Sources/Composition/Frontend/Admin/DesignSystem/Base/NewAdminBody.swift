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

public struct NewAdminBody<T: Renderable>: Branch where T.HTML: FlowContent {

    public let content: T

    public init(content: T) {
        self.content = content
    }

    // MARK: -

    public func rules() -> [any Rule] {
        []
    }

    public var children: [any Component] {
        content
    }

    public func html() -> Body {
        Body {
            content.html()
        }
    }
}
