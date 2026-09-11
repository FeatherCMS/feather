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
    func navigation(
    ) -> [any Rule] {
        Media {
            Custom(".group + .group") {
                BorderTop(1.px, .solid, .variable(TokenKey.Colors.Materials.Secondary.border))
            }
            Custom(".group-label") {
                Display(.block)
                TextTransform(.uppercase)
                LetterSpacing(0.08.em)
                FontSize(12.px)
                FontWeight(.number(700))
                Padding(16.px)
                PaddingBottom(8.px)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            }
            Custom(".menu li a") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
                Padding(16.px)
                TextDecoration(.none)
            }
            Custom(".submenu-toggle") {
                Position(.absolute)
                Width(1.px)
                Height(1.px)
                Opacity(0)
                PointerEvents(.none)
            }
            Custom(".submenu-label") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
                Position(.relative)
                Padding(16.px)
                Width(100.percent)
                BoxSizing(.borderBox)
                Cursor(.pointer)
            }
            Custom(".menu svg") {
                Width(16.px)
                Height(16.px)
                UnsafeRawProperty(name: "fill", value: "none")
                UnsafeRawProperty(name: "stroke", value: "currentColor")
                UnsafeRawProperty(name: "stroke-width", value: "1.5")
                UnsafeRawProperty(name: "stroke-linecap", value: "round")
                UnsafeRawProperty(name: "stroke-linejoin", value: "round")
                FlexShrink(0)
            }
            Custom(".submenu-label::after") {
                Content(.string("\"\""))
                Position(.absolute)
                Right(16.px)
                Top(50.percent)
                Width(7.px)
                Height(7.px)
                BorderRight(1.px, .solid, .variable(TokenKey.Colors.Accents.Primary.border))
                BorderBottom(1.px, .solid, .variable(TokenKey.Colors.Accents.Primary.border))
                UnsafeRawProperty(
                    name: "transform",
                    value: "translateY(-50%) rotate(-45deg)"
                )
                UnsafeRawProperty(
                    name: "transition",
                    value: "transform 0.16s ease-out"
                )
            }
            Custom(".submenu-toggle + .submenu-label + .sub-menu") {
                MaxHeight(0.px)
                Overflow(.hidden)
                UnsafeRawProperty(
                    name: "transition",
                    value: "max-height 0.18s ease-out"
                )
            }
            Custom(".submenu-toggle:checked + .submenu-label::after") {
                UnsafeRawProperty(
                    name: "transform",
                    value: "translateY(-50%) rotate(45deg)"
                )
            }
            Custom(".submenu-toggle:checked + .submenu-label + .sub-menu") {
                MaxHeight(100.vh)
            }
            Id("menuToggle") {
                Position(.absolute)
                Width(1.px)
                Height(1.px)
                Opacity(0)
                PointerEvents(.none)
            }
            Class("menu") {
                Width(100.percent)
                MaxHeight(0)
                Overflow(.hidden)
                UnsafeRawProperty(name: "transition", value: "max-height 0.22s ease-out")
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
            }
            Custom("#menuToggle:checked ~ .menu") {
                MaxHeight(.none)
            }
            Class("menu-trigger-desktop") {
                Display(.none)
            }
            Class("menu-trigger-mobile") {
                Display(.block)
                UnsafeRawProperty(
                    name: "transition",
                    value: "transform 0.22s ease-out"
                )
                UnsafeRawProperty(name: "transform-origin", value: "50% 50%")
            }
            Custom("body:has(#menuToggle:checked) .menu-trigger-mobile line:nth-child(1)") {
                Transform(.translateX((-50).px))
            }
            Custom("body:has(#menuToggle:checked) .menu-trigger-mobile line:nth-child(2)") {
                UnsafeRawProperty(name: "transform", value: "translateY(6px) rotate(45deg)")
            }
            Custom("body:has(#menuToggle:checked) .menu-trigger-mobile line:nth-child(3)") {
                UnsafeRawProperty(name: "transform", value: "translateY(-6px) rotate(-45deg)")
            }
        }
        Media(.minWidth("600px")) {
            Class("container") {
                GridTemplateColumns(.tracks([.auto, .fraction(1.fr)]))
                AlignItems(.flexStart)
            }
            Class("menu") {
                Width(250.px)
                MaxHeight(.none)
                Overflow(.hidden)
                BorderRight(1.px, .solid, .variable(TokenKey.Colors.Materials.Primary.border))
                BorderBottom(1.px, .solid, .variable(TokenKey.Colors.Materials.Primary.border))
            }
            Custom(".menu .group-label") {
                Overflow(.hidden)
                WhiteSpace(.nowrap)
                MaxHeight(.none)
                Opacity(1)
                Transform(.translateX(0.px))
            }
            Custom(".menu .submenu-label span, .menu li a span") {
                Display(.inlineBlock)
                Overflow(.hidden)
                WhiteSpace(.nowrap)
                MaxWidth(140.px)
                Opacity(1)
                Transform(.translateX(0.px))
            }
            Custom("#menuToggle:checked ~ .menu") {
                Width(60.px)
            }
            Custom("#menuToggle:checked ~ .menu .group-label") {
                MaxHeight(0.px)
                Opacity(0)
                PaddingTop(0.px)
                PaddingBottom(0.px)
                Transform(.translateX((-6).px))
            }
            Custom("#menuToggle:checked ~ .menu .submenu-label span, #menuToggle:checked ~ .menu li a span") {
                MaxWidth(0.px)
                Opacity(0)
                Transform(.translateX((-4).px))
            }
            Custom("#menuToggle:checked ~ .menu .submenu-label::after") {
                Opacity(0)
            }
            Custom("#menuToggle:checked ~ .menu .has-submenu > .sub-menu") {
                Display(.block)
                MaxHeight(0.px)
                Position(.static)
                Width(100.percent)
                Overflow(.hidden)
            }
            Custom("#menuToggle:checked ~ .menu .submenu-label, #menuToggle:checked ~ .menu li a") {
                JustifyContent(.center)
                Gap(0.px)
                Padding(16.px)
            }
            Custom("#menuToggle:checked ~ .menu .submenu-label > a") {
                PointerEvents(.none)
            }
            Custom("#menuToggle:checked ~ .menu .has-submenu > .submenu-toggle:checked + .submenu-label + .sub-menu") {
                MaxHeight(.none)
            }
            Class("menu-trigger-desktop") {
                Display(.block)
                UnsafeRawProperty(name: "transition", value: "transform 0.22s ease-out")
            }
            Class("menu-trigger-mobile") {
                Display(.none)
            }
        }
        Media {
            Custom(".menu a") {
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            }
            Custom(".menu svg") {
                Color(.variable(TokenKey.Colors.Accents.Primary.tint))
            }
            Custom(".menu .sub-menu svg") {
                Color(.variable(TokenKey.Colors.Accents.Secondary.tint))
            }
            Custom(".menu .sub-menu") {
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
            }
            Custom(".isCurrent") {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            }
            Custom(".menu a:hover, .menu .submenu-label:hover") {
                Background(.variable(TokenKey.Colors.Materials.Tertiary.hover))
            }
        }
    }
}
