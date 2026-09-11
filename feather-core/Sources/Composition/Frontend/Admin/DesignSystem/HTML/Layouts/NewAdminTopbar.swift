//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import Foundation
import HTML
import SGML
import SVG
import WebComponents
import WebBuilders

public struct NewAdminTopBar: Component {

    private let notification: NewAdminNotification?

    public init(notification: NewAdminNotification? = nil) {
        self.notification = notification
    }

    private func renderMenuTrigger(context: inout RenderContext) -> Div {

        Div {
            Label {
                FeatherIcons.sidebar().class("menu-trigger-icon menu-trigger-desktop")
                FeatherIcons.menu().class("menu-trigger-icon menu-trigger-mobile")
                Span("Menu").class("sr-only")
            }
            .for("menuToggle")
            .ariaLabel("Toggle menu")
            .class("menu-trigger")
        }
        .class("top-bar-brand")
    }

    private func renderTitle(context: inout RenderContext) -> Div {
        Div {
            Div {
                H1 {
                    A("Feather CMS")
                        .href("/")
                        .class("top-bar-title-link")
                }
            }
            .class("top-bar-title-copy")
            if let notification {
                context.render(notification)
            }
        }
        .class("top-bar-title")
    }

    private func renderAccountActions(context: inout RenderContext) -> Div {

        return Div {
            Input()
                .type(.checkbox)
                .id("accountToggle")
                .name("accountToggle")
            Label {
                FeatherIcons.user().class("account-profile-icon")
                Span("My profile")
                    .class("sr-only")
            }
            .for("accountToggle")
            .class("account-trigger")
            .ariaLabel("Toggle account menu")

            Ul {
                Li { A("Profile").href("/admin/auth/profile/") }
                Li { A("Settings").href("/admin/account/settings/") }
                Li { A("Logout").href("/logout") }
            }
            .class("account-menu")
        }
        .class("top-bar-actions")
    }

    public func html(context: inout RenderContext) -> some BasicTag {
        Div {
            renderMenuTrigger(context: &context)
            renderTitle(context: &context)
            renderAccountActions(context: &context)
        }
        .class("top-bar")
    }
}
