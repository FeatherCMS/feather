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
import WebBuilders
import WebComponents

public struct NewAdminBaseLayout<T: Component>: Component {

    public let content: T

    private let topbar: NewAdminTopBar
    private let sidebar: NewAdminSideBar

    public init(
        content: T,
        menuGroups: [NewAdminSideBar.Group],
        notification: NewAdminNotification.State? = nil
    ) {
        self.topbar = .init(
            notification: notification.map(NewAdminNotification.init)
        )
        self.sidebar = .init(groups: menuGroups)
        self.content = content
    }

    public func html(context: inout BuilderContext) -> Div {
        Div {
            context.build(topbar)
            Div {
                context.build(sidebar)

                Main {
                    Div {
                        context.build(content)
                    }
                }
            }
            .class("menu-container")
        }
    }

}
