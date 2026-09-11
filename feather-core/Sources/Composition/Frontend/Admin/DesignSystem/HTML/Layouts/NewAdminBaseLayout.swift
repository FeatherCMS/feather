//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import DOM
import HTML
import SGML
import SVG
import WebComponents
import WebBuilders

public struct NewAdminBaseLayout<T: Component>: Component {

    public let content: T

    private let topbar: NewAdminTopBar
    private let toast: AdminToastBootstrap?
    private let sidebar: NewAdminSidebar

    public init(
        content: T,
        menuGroups: [NewAdminSidebar.Group],
        toast: AdminToastRedirect.Payload? = nil
    ) {
        self.topbar = .init()
        if let toast {
            self.toast = AdminToastBootstrap(payload: toast)
        }
        else {
            self.toast = nil
        }
        self.sidebar = .init(groups: menuGroups)
        self.content = content
    }

    public func html(context: inout RenderContext) -> Div {
        Div {
            context.render(topbar)
            if let toast {
                context.render(toast)
            }

            Div {
                context.render(sidebar)

                Main {
                    Div {
                        context.render(content)
                    }
                }
            }
            .class("menu-container")
        }
    }

}
