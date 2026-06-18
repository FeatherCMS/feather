//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 07..
//

import CSS
import HTML
import SGML
import SVG
import WebStandards

struct AdminTopBar: Component, FlowContent {

    func content() -> some BasicTag {
        Div {
            Div {
                Label {
                    Icon(
                        svg: FeatherIcons.sidebar(),
                        class: "menu-trigger-icon menu-trigger-desktop"
                    )
                    Icon(
                        svg: FeatherIcons.menu(),
                        class: "menu-trigger-icon menu-trigger-mobile"
                    )
                    Span("Menu").class("sr-only")
                }
                .for("menuToggle")
                .class("menu-trigger")
            }
            .class("top-bar-brand")

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

            Div {
                Input()
                    .type(.checkbox)
                    .id("accountToggle")
                    .name("accountToggle")
                Label {
                    Img(
                        src:
                            "\(AppEnvironmentStore.current.publicOrigins.staticBaseURL)/images/tiborbodecs-2026-512.png",
                        alt: "My profile picture"
                    )
                    .width(32)
                    .height(32)
                    Span("My profile")
                        .class("sr-only")
                }
                .for("accountToggle")
                .class("account-trigger")
                .ariaLabel("Toggle account menu")

                Ul {
                    Li { A("Profile").href("/admin/auth/profile/") }
                    Li { A("Settings").href("/admin/auth/settings/") }
                    Li { A("Logout").href("/logout") }
                }
                .class("account-menu")
            }
            .class("top-bar-actions")

        }
        .class("top-bar")
    }
}
