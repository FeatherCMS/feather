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

public struct NewAdminBaseLayout<T: Renderable>: Branch {

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

    public var children: [any Component] {
        topbar
        if let toast {
            toast
        }
        sidebar
        content
    }

    public func html() -> Div {
        Div {
            topbar.html()
            if let toast {
                toast.html()
            }

            Div {
                sidebar.html()

                Main {
                    Div {
                        content.html()
                    }
                }
            }
            .class("menu-container")
        }
    }

}
