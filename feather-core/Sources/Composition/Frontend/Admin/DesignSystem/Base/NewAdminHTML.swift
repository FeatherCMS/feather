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

public struct NewAdminHTML<T: Renderable>: Branch where T.HTML: FlowContent {

    let title: String
    let language: String
    let body: NewAdminBody<T>
    private let designSystem: HTMLDesignSystem
    private let cssRenderer: CSSRenderer
    private let styleCollector: ComponentStyleCollector
    private let scriptCollector: ComponentScriptCollector

    public init(
        title: String,
        language: String = "en-US",
        body: NewAdminBody<T>
    ) {
        self.title = title
        self.language = language
        self.body = body
        self.designSystem = .init()
        #if DEBUG
        self.cssRenderer = .init(minify: false)
        #else
        self.cssRenderer = .init(minify: true)
        #endif
        self.styleCollector = .init()
        self.scriptCollector = .init()
    }

    public var children: [any Component] {
        designSystem
        body
    }

    public func rules() -> [any Rule] {
        Media {
            Universal {
                Margin(0)
                Padding(0)
            }
            
            Custom("ul.inline") {
                Display(.flex)
                FlexWrap(.wrap)
                Gap(16.px)
            }
            Custom("ul.plain li, ul.inline li") {
                ListStyleType(.none)
            }
        }
    }

    public func html() -> Html {
        let style = styleCollector.getStylesheet(from: self)
        let css = cssRenderer.render(style)
        let scripts = scriptCollector.getScripts(from: self)

        return Html {
            NewAdminHead(
                title: title,
                stylesheet: css,
                scripts: scripts
            ).html()
            body.html()
        }
        .lang(language)
    }
}
