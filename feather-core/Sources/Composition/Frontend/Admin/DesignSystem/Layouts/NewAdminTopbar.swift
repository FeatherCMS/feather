//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import CSS
import Foundation
import HTML
import SGML
import SVG
import WebComponents
import WebBuilders

public struct NewAdminTopBar: Leaf {

    public func rules() -> [any Rule] {
        Media {
            Class("top-bar") {
                Position(.relative)
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.spaceBetween)
                Padding(vertical: 8.px, horizontal: 16.px)
                Background(.variable(TokenKey.Colors.Background.primary))
                BorderBottom(0.5.px, .solid, .variable(TokenKey.Colors.Border.primary))
            }
            Class("top-bar-brand") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
            }
            Class("top-bar-title") {
                Position(.absolute)
                Left(50.percent)
                Transform(.translateX((-50).percent))
                Display(.flex)
                FlexDirection(.column)
                AlignItems(.center)
                TextAlign(.center)
                UnsafeRawProperty(
                    name: "max-width",
                    value: "calc(100% - 120px)"
                )
            }
            Custom(".top-bar-title h1") {
                Margin(0.px)
                WhiteSpace(.nowrap)
                Overflow(.hidden)
                TextOverflow(.ellipsis)
            }
            Class("top-bar-title-link") {
//                Color(.inherit)
            }
            Class("menu-trigger") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Cursor(.pointer)
                Padding(2.px)
            }
            Class("menu-trigger-icon") {
                Display(.block)
            }
            Custom(".menu-trigger .sr-only") {
                Position(.absolute)
                Width(1.px)
                Height(1.px)
                Padding(0)
                Margin((-1).px)
                Overflow(.hidden)
                UnsafeRawProperty(name: "clip", value: "rect(0, 0, 0, 0)")
                WhiteSpace(.nowrap)
                Border(0)
            }
            Custom(".menu-trigger-mobile line") {
                UnsafeRawProperty(
                    name: "transition",
                    value: "transform 0.32s ease 0s"
                )
                UnsafeRawProperty(name: "transform-origin", value: "center")
                UnsafeRawProperty(name: "transform-box", value: "fill-box")
            }
            Class("top-bar-actions") {
                Display(.flex)
                AlignItems(.center)
                Position(.relative)
            }
        }
    }

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
        let fallbackProfileImageURL =
            "\(AppEnvironmentStore.current.publicOrigins.staticBaseURL)/images/tiborbodecs-2026-512.png"

        return Div {
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

    public func html() -> some BasicTag {
        Div {
            renderMenuTrigger()
            renderTitle()
            renderAccountActions()
        }
        .class("top-bar")
    }
}
