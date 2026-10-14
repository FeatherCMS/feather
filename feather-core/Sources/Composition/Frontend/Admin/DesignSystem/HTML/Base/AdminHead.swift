//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct AdminHead: Component {

    let title: String
    let stylesheet: String
    let scripts: [String]
    let stylesheetPath: String?
    let adminRemoveNonce: String?

    public init(
        title: String,
        stylesheet: String = "",
        scripts: [String] = [],
        stylesheetPath: String? = "/admin/style.css",
        adminRemoveNonce: String? = nil
    ) {
        self.title = title
        self.stylesheet = stylesheet
        self.scripts = scripts
        self.stylesheetPath = stylesheetPath
        self.adminRemoveNonce = adminRemoveNonce
    }

    public func html(context: inout BuilderContext) -> Head {
        Head {
            Meta().charset("utf-8")
            Meta().name(.viewport)
                .content("width=device-width, initial-scale=1")

            if let adminRemoveNonce {
                Meta()
                    .name("admin-remove-nonce")
                    .content(adminRemoveNonce)
            }

            Title(title)

            if let stylesheetPath {
                Link(rel: .stylesheet).href(stylesheetPath)
            }

            if !stylesheet.isEmpty {
                Style(stylesheet)
            }

            for script in scripts where !script.isEmpty {
                Script(script)
            }
        }
    }
}
