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

public struct NewAdminHead: Component {

    let title: String
    let stylesheet: String
    let scripts: [String]

    public init(
        title: String,
        stylesheet: String = "",
        scripts: [String] = []
    ) {
        self.title = title
        self.stylesheet = stylesheet
        self.scripts = scripts
    }

    public func html(context: inout RenderContext) -> Head {
        Head {
            Meta().charset("utf-8")
            Meta().name(.viewport)
                .content("width=device-width, initial-scale=1")

            Title(title)

            Link(rel: .stylesheet).href("/admin/style.css")

            if !stylesheet.isEmpty {
                Style(stylesheet)
            }

            for script in scripts where !script.isEmpty {
                Script(script)
            }
        }
    }
}
