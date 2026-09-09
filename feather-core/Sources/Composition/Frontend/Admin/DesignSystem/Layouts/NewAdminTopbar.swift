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
                BorderBottom(1.px, .solid, .variable(TokenKey.Colors.Border.primary))
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
                FontSize(22.px)
                WhiteSpace(.nowrap)
                Overflow(.hidden)
                TextOverflow(.ellipsis)
            }
            Custom(".top-bar-title-link, .top-bar-title-link:hover, .top-bar-title-link:visited, .top-bar-title-link:active") {
                BackgroundImage(
                    .linearGradient(
                        LinearGradient(
                            direction: .angle(120.deg),
                            stops: [
                                .init(CSSColor(stringLiteral: "var(--\(TokenKey.Colors.Accent.Primary.default.propertyName))"), 0.percent),
                                .init(CSSColor(stringLiteral: "var(--\(TokenKey.Colors.Accent.Secondary.default.propertyName))"), 100.percent)
                            ]
                        )
                    )
                )
                UnsafeRawProperty(name: "-webkit-background-clip", value: "text")
                UnsafeRawProperty(name: "background-clip", value: "text")
                Color(.transparent)
                WebkitTextFillColor(.transparent)
                TextDecoration(.none)
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
            Custom(".menu-trigger .sr-only, .account-trigger .sr-only") {
                Position(.absolute)
                Width(1.px)
                Height(1.px)
                Padding(0)
                Margin((-1).px)
                Overflow(.hidden)
                Clip(.shape("rect(0, 0, 0, 0)"))
                WhiteSpace(.nowrap)
                Border(0)
            }
            Custom("#accountToggle, #accountToggle + .account-trigger") {
                Cursor(.pointer)
            }
            Id("accountToggle") {
                Position(.absolute)
                Width(1.px)
                Height(1.px)
                Opacity(0)
                PointerEvents(.none)
            }
            Class("account-trigger") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Padding(2.px)
            }
            Custom(".account-trigger img, .account-trigger .account-profile-icon") {
                Display(.block)
                Width(28.px)
                Height(28.px)
                BorderRadius(999.px)
                Border(1.px, .solid, .variable(TokenKey.Colors.Border.secondary))
                BoxSizing(.borderBox)
            }
            Custom(".account-trigger .account-profile-icon") {
                Color(.variable(TokenKey.Colors.Link.visited))
            }
            Class("account-menu") {
                Position(.absolute)
                Right(0.px)
                Top(40.px)
                MinWidth(140.px)
                ListStyle(.none)
                Padding(vertical: 8.px, horizontal: 0.px)
                Margin(0)
                Display(.none)
                ZIndex(.number(20))
                Background(.variable(TokenKey.Colors.Background.primary))
                Border(1.px, .solid, .variable(TokenKey.Colors.Border.secondary))
                BorderRadius(10.px)
                BoxShadow(
                    0.px,
                    10.px,
                    blur: 24.px,
                    color: CSSColor(stringLiteral: "var(--\(TokenKey.Colors.BoxShadow.default.propertyName))")
                )
            }
            Custom(".account-menu li a") {
                Display(.block)
                Padding(vertical: 8.px, horizontal: 12.px)
                Color(.variable(TokenKey.Colors.Text.primary))
                TextDecoration(.none)
            }
            Custom("#accountToggle:checked + .account-trigger + .account-menu") {
                Display(.block)
            }
            Custom(".account-menu li a:hover, .account-menu li a:focus-visible") {
                Background(.variable(TokenKey.Colors.Background.secondary))
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
