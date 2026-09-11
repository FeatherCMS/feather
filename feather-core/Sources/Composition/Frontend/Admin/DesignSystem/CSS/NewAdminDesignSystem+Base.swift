//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 10..
//

import CSS
import WebBuilders

extension NewAdminDesignSystem {

    @Builder<CSS.Rule>
    func base(
    ) -> [any Rule] {

        Media {
            Universal {
                Margin(0)
                Padding(0)
            }
            
            Custom("ul.inline") {
                Display(.flex)
                FlexWrap(.wrap)
                Gap(16.px)
            }
            Custom("ul.plain li, ul.inline li") {
                ListStyleType(.none)
            }

            Custom("a:link") {
                Color(.variable(TokenKey.Colors.Link.default))
            }
            Custom("a:visited") {
                Color(.variable(TokenKey.Colors.Link.visited))
            }
            Custom("a:hover") {
                Color(.variable(TokenKey.Colors.Link.hover))
            }
            Custom("a:active") {
                Color(.variable(TokenKey.Colors.Link.active))
            }
            Custom(".button") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                BoxSizing(.borderBox)
                UnsafeRawProperty(name: "font", value: "inherit")
                FontWeight(.number(700))
                Border(1.px, .solid, .variable(TokenKey.Colors.Materials.Primary.border))
                BorderRadius(999.px)
                Padding(vertical: 10.px, horizontal: 16.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Cursor(.pointer)
                TextDecoration(.none)
                UnsafeRawProperty(
                    name: "transition",
                    value: "background-color 0.18s ease, border-color 0.18s ease, color 0.18s ease"
                )
            }
            Custom(".button, .button:link, .button:visited, .button:hover, .button:active") {
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                TextDecoration(.none)
            }
            Custom(".button.row-button") {
                BorderRadius(6.px)
                Padding(vertical: 7.px, horizontal: 10.px)
                FontSize(0.875.rem)
                FontWeight(.normal)
            }
            Custom(".button.primary") {
                Background(.variable(TokenKey.Colors.Accents.Primary.tint))
                BorderColor(.variable(TokenKey.Colors.Accents.Primary.border))
                Color(.variable(TokenKey.Colors.Accents.Primary.text))
            }
            Custom(".button.primary:hover:not(:disabled):not(.disabled)") {
                Background(.variable(TokenKey.Colors.Accents.Primary.hover))
            }
            Custom(".button.secondary") {
                Background(.variable(TokenKey.Colors.Accents.Secondary.tint))
                BorderColor(.variable(TokenKey.Colors.Accents.Secondary.border))
                Color(.variable(TokenKey.Colors.Accents.Secondary.text))
            }
            Custom(".button.secondary:hover:not(:disabled):not(.disabled)") {
                Background(.variable(TokenKey.Colors.Accents.Secondary.hover))
            }
            Custom(".button.primary-ghost") {
                Background(.variable(TokenKey.Colors.Buttons.Ghost.Primary.tint))
                BorderColor(.variable(TokenKey.Colors.Buttons.Ghost.Primary.border))
                Color(.variable(TokenKey.Colors.Buttons.Ghost.Primary.text))
            }
            Custom(".button.primary-ghost:hover:not(:disabled):not(.disabled)") {
                Background(.variable(TokenKey.Colors.Buttons.Ghost.Primary.hover))
            }
            Custom(".button.secondary-ghost") {
                Background(.variable(TokenKey.Colors.Buttons.Ghost.Secondary.tint))
                BorderColor(.variable(TokenKey.Colors.Buttons.Ghost.Secondary.border))
                Color(.variable(TokenKey.Colors.Buttons.Ghost.Secondary.text))
            }
            Custom(".button.secondary-ghost:hover:not(:disabled):not(.disabled)") {
                Background(.variable(TokenKey.Colors.Buttons.Ghost.Secondary.hover))
            }
            Custom(".button.destructive") {
                Background(.variable(TokenKey.Colors.Buttons.Destructive.tint))
                BorderColor(.variable(TokenKey.Colors.Buttons.Destructive.border))
                Color(.variable(TokenKey.Colors.Buttons.Destructive.text))
            }
            Custom(".button.destructive:hover:not(:disabled):not(.disabled)") {
                Background(.variable(TokenKey.Colors.Buttons.Destructive.hover))
            }
            Custom(".button.disabled, .button:disabled") {
                Background(.variable(TokenKey.Colors.Buttons.Disabled.tint))
                BorderColor(.variable(TokenKey.Colors.Buttons.Disabled.border))
                Color(.variable(TokenKey.Colors.Buttons.Disabled.text))
                Cursor(.notAllowed)
            }
            Custom(".button.disabled:hover, .button:disabled:hover") {
                Background(.variable(TokenKey.Colors.Buttons.Disabled.hover))
            }
            Class("panel") {
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
            }

            
            Custom("body") {
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                FontFamily(.family("'SF Pro Display', 'SF Pro Icons', 'Helvetica Neue', Helvetica, Arial, sans-serif"))
            }
            Id("footer") {
                Padding(32.px)
                TextAlign(.center)
                BorderTop(1.px, .solid, .variable(TokenKey.Colors.Materials.Primary.border))
            }

        }
    }
}
