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
import WebComponents
import WebBuilders

public struct AdminSidebar: Leaf {

    public struct State: Sendable {
        public struct Group: Sendable {
            public struct Menu: Sendable {
                public struct Item: Sendable {
                    public let icon: SVG
                    public let label: String
                    public let link: String?
                    public let isCurrent: Bool

                    public init(
                        icon: SVG,
                        label: String,
                        link: String?,
                        isCurrent: Bool
                    ) {
                        self.icon = icon
                        self.label = label
                        self.link = link
                        self.isCurrent = isCurrent
                    }
                }

                public let current: Item
                public let children: [Item]

                public init(current: Item, children: [Item]) {
                    self.current = current
                    self.children = children
                }
            }

            public let label: String
            public let menus: [Menu]

            public init(label: String, menus: [Menu]) {
                self.label = label
                self.menus = menus
            }
        }

        public let current: String
        public let groups: [Group]

        public init(current: String, groups: [Group]) {
            self.current = current
            self.groups = groups
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func renderHTML() -> some BasicTag {
        Div {
            Input()
                .id("menuToggle")
                .name("menuToggle")
                .type(.checkbox)
            Nav {
                Ul {
                    for group in state.groups {
                        Li {
                            Span(group.label).class("group-label")
                            Ul {
                                for (idx, menu) in group.menus.enumerated() {
                                    if menu.children.isEmpty {
                                        Li {
                                            if let link = menu.current.link {
                                                A {
                                                    Icon(
                                                        svg: menu.current.icon,
                                                        class: "menu-icon"
                                                    ).renderHTML()
                                                    Span(menu.current.label)
                                                }
                                                .title(menu.current.label)
                                                .href(link)
                                                .if(menu.current.isCurrent) {
                                                    $0.class("isCurrent")
                                                }
                                            }
                                            else {
                                                Icon(
                                                    svg: menu.current.icon,
                                                    class: "menu-icon"
                                                ).renderHTML()
                                                Span(menu.current.label)
                                            }
                                        }
                                    }
                                    else {
                                        let hasCurrentChild = menu.children
                                            .contains(where: { $0.isCurrent })
                                        Li {
                                            Input()
                                                .id(
                                                    "applicationMenu\(idx)Toggle"
                                                )
                                                .type(.checkbox)
                                                .if(hasCurrentChild) {
                                                    $0.checked()
                                                }
                                                .class("submenu-toggle")
                                            Label {
                                                if let link = menu.current.link
                                                {
                                                    A {
                                                        Icon(
                                                            svg: menu.current
                                                                .icon,
                                                            class: "menu-icon"
                                                        ).renderHTML()
                                                        Span(menu.current.label)
                                                    }
                                                    .title(menu.current.label)
                                                    .href(link)
                                                }
                                                else {
                                                    Icon(
                                                        svg: menu.current.icon,
                                                        class: "menu-icon"
                                                    ).renderHTML()
                                                    Span(menu.current.label)
                                                }
                                            }
                                            .title(menu.current.label)
                                            .for("applicationMenu\(idx)Toggle")
                                            .class("submenu-label")
                                            .if(menu.current.isCurrent) {
                                                $0.addClass("isCurrent")
                                            }
                                            Ul {
                                                for child in menu.children {
                                                    Li {
                                                        A {
                                                            Icon(
                                                                svg: child.icon,
                                                                class:
                                                                    "menu-icon"
                                                            ).renderHTML()
                                                            Span(child.label)
                                                        }
                                                        .title(child.label)
                                                        .href(child.link)
                                                        .if(child.isCurrent) {
                                                            $0.class(
                                                                "isCurrent"
                                                            )
                                                        }
                                                    }
                                                }
                                            }
                                            .class("sub-menu")
                                        }
                                        .class("has-submenu")
                                    }
                                }
                            }
                            .class("sub-menu")
                        }
                        .class("menu-group")
                    }
                }
                .class("menu-groups")
            }
            .class("menu")
        }
    }
}
