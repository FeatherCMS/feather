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

public struct NewAdminTopBar: Leaf {

    private func renderMenuTrigger() -> Div {
        Div {
            Label {
                Icon(
                    svg: FeatherIcons.sidebar(),
                    class: "menu-trigger-icon menu-trigger-desktop"
                ).html()
                Icon(
                    svg: FeatherIcons.menu(),
                    class: "menu-trigger-icon menu-trigger-mobile"
                ).html()
                Span("Menu").class("sr-only")
            }
            .for("menuToggle")
            .ariaLabel("Toggle menu")
            .class("menu-trigger")
        }
        .class("top-bar-brand")
    }

    private func renderTitle() -> Div {
        Div {
            Div {
                H1 {
                    A("Feather CMS")
                        .href("/")
                        .class("top-bar-title-link")
                }
            }
            .class("top-bar-title-copy")
        }
        .class("top-bar-title")
    }

    private func renderAccountActions() -> Div {
        return Div {
            Input()
                .type(.checkbox)
                .id("accountToggle")
                .name("accountToggle")
            Label {
                Icon(
                    svg: FeatherIcons.user(),
                    class: "account-profile-icon"
                ).html()
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

    public func html() -> some BasicTag {
        Div {
            renderMenuTrigger()
            renderTitle()
            renderAccountActions()
        }
        .class("top-bar")
    }
}
