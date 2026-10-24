//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import DOM
public import HTML
import SGML
import SVG
import WebBuilders
public import WebComponents

public struct AdminBaseLayout<T: Component>: Component {

    public let content: T

    private let topbar: AdminTopBar
    private let sidebar: AdminSideBar

    public init(
        content: T,
        menuGroups: [AdminSideBar.Group],
        notification: AdminNotification.State? = nil,
        accountTopBarState: AdminTopBar.State = .init()
    ) {
        self.topbar = .init(
            notification: notification.map(AdminNotification.init),
            state: accountTopBarState
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

            context.build(AdminDialogHost())
        }
    }

}
