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

struct AdminSidebar: Component, FlowContent {

    struct State {
        struct Group {
            struct Menu {
                struct Item {
                    let icon: SVG
                    let label: String
                    let link: String?
                    let isCurrent: Bool
                }

                let current: Item
                let children: [Item]
            }
            let label: String
            let menus: [Menu]
        }

        let current: String
        let groups: [Group]
    }

    let state: State

    func content() -> some BasicTag {
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
                                                    )
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
                                                )
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
                                                        )
                                                        Span(menu.current.label)
                                                    }
                                                    .title(menu.current.label)
                                                    .href(link)
                                                }
                                                else {
                                                    Icon(
                                                        svg: menu.current.icon,
                                                        class: "menu-icon"
                                                    )
                                                    Span(menu.current.label)
                                                }
                                            }
                                            .title(menu.current.label)
                                            .setAttribute(
                                                name: "for",
                                                value:
                                                    "applicationMenu\(idx)Toggle"
                                            )
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
                                                            )
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
