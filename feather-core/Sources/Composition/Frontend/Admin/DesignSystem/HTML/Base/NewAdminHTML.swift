//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminHTML<T: Component>: Component where T.HTML: FlowContent {

    let title: String
    let language: String
    let body: NewAdminBody<T>

    private let cssRenderer: CSSRenderer
    public init(
        title: String,
        language: String = "en-US",
        body: NewAdminBody<T>
    ) {
        self.title = title
        self.language = language
        self.body = body

        #if DEBUG
        self.cssRenderer = .init(minify: false)
        #else
        self.cssRenderer = .init(minify: true)
        #endif
    }

    public func html(context: inout RenderContext) -> Html {

        let renderedBody = context.render(body)
        let style = context.stylesheet()
        let css = cssRenderer.render(style)
        let scripts = context.scripts()
        let renderedHead: Head = context.render(
            NewAdminHead(
                title: title,
                stylesheet: css,
                scripts: scripts
            )
        )

        return Html {
            renderedHead
            renderedBody
        }
        .lang(language)
    }
}
