//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import CSS
import DOM
import HTML
import SGML
import SVG
import WebComponents
import WebBuilders

public struct NewAdminBaseLayout<T: Leaf>: Branch {

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

    public func rules() -> [any Rule] {
        Media {
            Class("menu-container") {
                Display(.grid)
                GridTemplateColumns(.tracks([.fraction(1.fr)]))
                AlignItems(.flexStart)
                AlignContent(.flexStart)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                MinHeight(100.vh)
            }
            Custom(".menu-container main") {
                Margin(15.px)
                MarginBottom(32.px)
                Padding(15.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Border(1.px, .solid, .variable(TokenKey.Colors.Materials.Primary.border))
                BorderRadius(20.px)
                BoxShadow(
                    0.px,
                    12.px,
                    blur: 26.px,
                    spread: 2.px,
                    color: CSSColor(stringLiteral: "var(--\(TokenKey.Colors.BoxShadow.tint.propertyName))")
                )
            }
        }
        Media(.minWidth("600px")) {
            Class("menu-container") {
                GridTemplateColumns(.tracks([.auto, .fraction(1.fr)]))
            }
        }
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
