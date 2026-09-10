//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import HTML
import CSS
import SGML
import WebComponents
import WebBuilders

public struct NewAdminBreadcrumb: Leaf {

    public struct Link: Sendable {
        public let label: String
        public let link: String

        public init(label: String, link: String) {
            self.label = label
            self.link = link
        }
    }

    public let links: [Link]

    public init(links: [Link]) {
        self.links = links
    }

    public func selectors() -> [any Selector] {
        Custom(".breadcrumb") {
            MarginBottom(15.px)
        }
        Custom(".breadcrumb ol") {
            ListStyle(.none)
            Margin(0)
            Padding(0)
            Display(.flex)
            FlexWrap(.wrap)
            AlignItems(.center)
            Gap(5.px)
        }
        Custom(".breadcrumb li") {
            Display(.inlineFlex)
            AlignItems(.center)
            FontSize(0.84.rem)
            LineHeight(1.2)
        }
        Custom(".breadcrumb li:not(:last-child)::after") {
            Content(.string("\"/\""))
            MarginLeft(5.px)
            Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
        }
        Custom(".breadcrumb li a") {
            Display(.inlineFlex)
            AlignItems(.center)
            Padding(vertical: 5.px, horizontal: 10.px)
            Color(.variable(TokenKey.Colors.Link.default))
            TextDecoration(.none)
            BorderRadius(10.px)
            UnsafeRawProperty(
                name: "transition",
                value: "background-color 0.18s ease, color 0.18s ease"
            )
        }
        Custom(".breadcrumb li a:hover") {
            Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            Color(.variable(TokenKey.Colors.Link.hover))
        }
        Custom(".breadcrumb li[aria-current='page']") {
            Padding(vertical: 5.px, horizontal: 10.px)
            Color(.variable(TokenKey.Colors.Materials.Primary.text))
            FontWeight(.number(600))
        }
    }

    public func html() -> Nav {
        Nav {
            Ol {
                for (idx, breadcrumb) in links.enumerated() {
                    if idx == links.count - 1 {
                        Li(breadcrumb.label).ariaCurrent(.page)
                    }
                    else {
                        Li { A(breadcrumb.label).href(breadcrumb.link) }
                    }
                }
            }
        }
        .class("breadcrumb")
        .ariaLabel("Breadcrumb")
    }
}
