//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import DOM
import HTML
public import SGML
public import SVG
import WebBuilders
public import WebComponents

public struct AdminSideBar: Component {

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

            public let parent: Item
            public let children: [Item]

            public init(
                parent: Item,
                children: [Item]
            ) {
                self.parent = parent
                self.children = children
            }
        }

        public let label: String
        public let menus: [Menu]

        public init(
            label: String,
            menus: [Menu]
        ) {
            self.label = label
            self.menus = menus
        }
    }

    public let groups: [Group]

    public init(groups: [Group]) {
        self.groups = groups
    }

    public func scripts() -> [String] {
        #"""
        document.addEventListener("DOMContentLoaded", function () {
            var key = "adminMenuCollapsed";
            var menuToggle = document.getElementById("menuToggle");
            var isDesktop = window.matchMedia("(min-width: 600px)").matches;
            var openCurrentSubmenus = function () {
                document.querySelectorAll(
                    ".menu .has-submenu.has-current > .submenu-toggle"
                ).forEach(function (submenuToggle) {
                    submenuToggle.checked = true;
                });
            };

            if (!menuToggle) {
                return;
            }

            if (isDesktop) {
                try {
                    menuToggle.checked = window.localStorage.getItem(key) === "1";
                }
                catch (_) {
                    // Ignore storage access errors.
                }
                openCurrentSubmenus();
            }
            else {
                menuToggle.checked = false;
            }

            menuToggle.addEventListener("change", function () {
                if (!window.matchMedia("(min-width: 600px)").matches) {
                    if (menuToggle.checked) {
                        openCurrentSubmenus();
                    }
                    return;
                }
                try {
                    window.localStorage.setItem(
                        key, menuToggle.checked ? "1" : "0"
                    );
                }
                catch (_) {
                    // Ignore storage access errors.
                }
            });

        });
        """#
    }

    private func renderListItem(
        item: Group.Menu.Item,
        context: inout BuilderContext
    ) -> Li {

        Li {
            if let link = item.link {
                A {
                    item.icon
                    Span(item.label)
                }
                .title(item.label)
                .href(link)
                .if(item.isCurrent) { $0.class("isCurrent") }
            }
            else {
                item.icon
                Span(item.label)
            }
        }
        .class("plain")
    }

    private func renderMenuParent(
        item: Group.Menu.Item,
        context: inout BuilderContext
    ) -> [any FlowContent] {

        guard let link = item.link else {
            return [
                item.icon,
                Span(item.label),
            ]
        }
        return [
            A {
                item.icon
                Span(item.label)
            }
            .title(item.label)
            .href(link)
        ]
    }

    private func renderSubmenuItem(
        item: Group.Menu.Item,
        context: inout BuilderContext
    ) -> Li {

        Li {
            A {
                item.icon
                Span(item.label)
            }
            .title(item.label)
            .href(item.link)
            .if(item.isCurrent) { $0.class("isCurrent") }
        }
        .class("plain")
    }

    private func renderSubmenu(
        items: [Group.Menu.Item],
        context: inout BuilderContext
    ) -> Ul {
        Ul {
            for item in items {
                renderSubmenuItem(item: item, context: &context)
            }
        }
        .class("sub-menu")
    }

    private func renderSubmenuMenu(
        menu: Group.Menu,
        index: Int,
        context: inout BuilderContext
    ) -> Li {
        let hasCurrentChild = menu.children.contains(where: { $0.isCurrent })

        return Li {
            Input()
                .id("applicationMenu\(index)Toggle")
                .type(.checkbox)
                .class("submenu-toggle")
            Label {
                renderMenuParent(item: menu.parent, context: &context)
            }
            .title(menu.parent.label)
            .for("applicationMenu\(index)Toggle")
            .class("submenu-label")
            .if(menu.parent.isCurrent) { $0.addClass("isCurrent") }
            renderSubmenu(items: menu.children, context: &context)
        }
        .class("has-submenu", "plain")
        .if(hasCurrentChild) { $0.addClass("has-current") }
    }

    private func renderMenu(
        menu: Group.Menu,
        index: Int,
        context: inout BuilderContext
    ) -> [any Element] {
        guard menu.children.isEmpty else {
            return [
                renderSubmenuMenu(menu: menu, index: index, context: &context)
            ]
        }
        return [renderListItem(item: menu.parent, context: &context)]
    }

    private func renderGroup(
        group: Group,
        context: inout BuilderContext
    ) -> Li {
        Li {
            Span(group.label)
                .class("group-label")
            Ul {
                for (index, menu) in group.menus.enumerated() {
                    renderMenu(menu: menu, index: index, context: &context)
                }
            }
            .class("group")
        }
        .class("plain")
    }

    private func renderNavigation(context: inout BuilderContext) -> Nav {
        Nav {
            Ul {
                for group in groups {
                    renderGroup(group: group, context: &context)
                }
            }
            .class("groups")
        }
        .class("menu")
    }

    public func html(
        context: inout BuilderContext
    ) -> some BasicTag {
        Div {
            Input()
                .id("menuToggle")
                .name("menuToggle")
                .type(.checkbox)
            renderNavigation(context: &context)
        }
    }
}
