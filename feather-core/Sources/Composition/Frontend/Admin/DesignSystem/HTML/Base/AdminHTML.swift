//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import CSS
import Foundation
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminHTML<T: Component>: Component where T.HTML: FlowContent {

    let title: String
    let language: String
    let body: NewAdminBody<T>
    let stylesheetPath: String?
    let richContentEditorBlocks:
        [AdminRichContentEditorBlockDefinition]

    private let cssRenderer: CSSRenderer
    public init(
        title: String,
        language: String = "en-US",
        body: NewAdminBody<T>,
        stylesheetPath: String? = "/admin/style.css",
        richContentEditorBlocks: [AdminRichContentEditorBlockDefinition] = []
    ) {
        self.title = title
        self.language = language
        self.body = body
        self.stylesheetPath = stylesheetPath
        self.richContentEditorBlocks = richContentEditorBlocks

        #if DEBUG
        self.cssRenderer = .init(minify: false)
        #else
        self.cssRenderer = .init(minify: true)
        #endif
    }

    public func html(context: inout BuilderContext) -> Html {

        let renderedBody = context.build(body)
        let style = context.stylesheet()
        let css = cssRenderer.render(style)
        let scripts = context.scripts()
        let renderedHead: Head = context.build(
            NewAdminHead(
                title: title,
                stylesheet: css,
                scripts: [richContentEditorConfigurationScript] + scripts,
                stylesheetPath: stylesheetPath
            )
        )

        return Html {
            renderedHead
            renderedBody
        }
        .lang(language)
    }

    private var richContentEditorConfigurationScript: String {
        let encoded = (try? JSONEncoder().encode(richContentEditorBlocks))
            .flatMap { String(data: $0, encoding: .utf8) } ?? "[]"
        let safeEncoded = encoded
            .replacingOccurrences(of: "<", with: "\\u003C")
            .replacingOccurrences(of: ">", with: "\\u003E")
            .replacingOccurrences(of: "&", with: "\\u0026")
        return "window.featherRichContentEditorBlocks = \(safeEncoded);"
    }
}
