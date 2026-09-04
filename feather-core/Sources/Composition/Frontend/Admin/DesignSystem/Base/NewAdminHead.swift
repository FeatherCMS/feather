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

public struct NewAdminHead: Leaf {

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

    public func html() -> Head {
        Head {
            Meta().charset("utf-8")
            Meta().name(.viewport).content("width=device-width, initial-scale=1")
            
            Title(title)

            if !stylesheet.isEmpty {
                Style(stylesheet)
            }

            for script in scripts where !script.isEmpty {
                Script(script)
            }
        }
    }
}
