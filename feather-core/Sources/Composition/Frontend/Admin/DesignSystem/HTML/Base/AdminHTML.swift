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

public struct AdminHTML<T: Component>: Component where T.HTML: FlowContent {

    let title: String
    let language: String
    let body: AdminBody<T>
    let stylesheetPath: String?
    let adminRemoveNonce: String?
    let richContentEditorBlocks:
        [AdminRichContentEditorBlockDefinition]

    private let cssRenderer: CSSRenderer
    public init(
        title: String,
        language: String = "en-US",
        body: AdminBody<T>,
        stylesheetPath: String? = "/admin/style.css",
        adminRemoveNonce: String? = nil,
        richContentEditorBlocks: [AdminRichContentEditorBlockDefinition] = []
    ) {
        self.title = title
        self.language = language
        self.body = body
        self.stylesheetPath = stylesheetPath
        self.adminRemoveNonce = adminRemoveNonce
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
            AdminHead(
                title: title,
                stylesheet: css,
                scripts: [richContentEditorConfigurationScript] + scripts,
                stylesheetPath: stylesheetPath,
                adminRemoveNonce: adminRemoveNonce
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
