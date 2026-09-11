//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminBody<T: Component>: Component where T.HTML: FlowContent {

    public let content: T

    public init(content: T) {
        self.content = content
    }

    public func html(context: inout RenderContext) -> Body {
        Body {
            context.render(content)

            Div {
                P("Powered by Feather CMS")
            }
            .id("footer")
        }
    }
}
