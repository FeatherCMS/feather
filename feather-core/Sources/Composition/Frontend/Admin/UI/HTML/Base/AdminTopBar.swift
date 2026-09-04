//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 07..
//

import CSS
import Foundation
import HTML
import SGML
import SVG
import WebComponents
import WebBuilders

public struct AdminTopBar: Leaf {

    public func renderHTML() -> some BasicTag {
        let fallbackProfileImageURL =
            "\(AppEnvironmentStore.current.publicOrigins.staticBaseURL)/images/tiborbodecs-2026-512.png"

        return Div {
            Div {
                Label {
                    Icon(
                        svg: FeatherIcons.sidebar(),
                        class: "menu-trigger-icon menu-trigger-desktop"
                    ).renderHTML()
                    Icon(
                        svg: FeatherIcons.menu(),
                        class: "menu-trigger-icon menu-trigger-mobile"
                    ).renderHTML()
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
                        src: fallbackProfileImageURL,
                        alt: "My profile picture"
                    )
                    .id("adminProfileImage")
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
                    Li { A("Settings").href("/admin/account/settings/") }
                    Li { A("Logout").href("/logout") }
                }
                .class("account-menu")
            }
            .class("top-bar-actions")

        }
        .class("top-bar")

    }
}
