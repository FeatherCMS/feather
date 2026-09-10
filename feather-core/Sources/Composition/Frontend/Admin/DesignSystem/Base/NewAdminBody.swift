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
        Media {
            Custom("body") {
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                FontFamily(.family("'SF Pro Display', 'SF Pro Icons', 'Helvetica Neue', Helvetica, Arial, sans-serif"))
            }
            Id("footer") {
                Padding(32.px)
                TextAlign(.center)
                BorderTop(1.px, .solid, .variable(TokenKey.Colors.Materials.Primary.border))
            }
        }
    }

    public var children: [any Component] {
        content
    }

    public func html() -> Body {
        Body {
            content.html()

            Div {
                P("Powered by Feather CMS")
            }
            .id("footer")
        }
    }
}
