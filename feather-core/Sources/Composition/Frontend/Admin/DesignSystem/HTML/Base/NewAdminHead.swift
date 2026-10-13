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

public struct NewAdminHead: Component {

    let title: String
    let stylesheet: String
    let scripts: [String]
    let stylesheetPath: String?

    public init(
        title: String,
        stylesheet: String = "",
        scripts: [String] = [],
        stylesheetPath: String? = "/admin/style.css"
    ) {
        self.title = title
        self.stylesheet = stylesheet
        self.scripts = scripts
        self.stylesheetPath = stylesheetPath
    }

    public func html(context: inout BuilderContext) -> Head {
        Head {
            Meta().charset("utf-8")
            Meta().name(.viewport)
                .content("width=device-width, initial-scale=1")

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
