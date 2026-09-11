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
    private let sidebar: NewAdminSidebar

    public init(
        content: T,
        menuGroups: [NewAdminSidebar.Group],
        notification: AdminNotification? = nil
    ) {
        self.topbar = .init(notification: notification.map(NewAdminNotification.init))
        self.sidebar = .init(groups: menuGroups)
        self.content = content
    }

    public func html(context: inout RenderContext) -> Div {
        Div {
            context.render(topbar)
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
