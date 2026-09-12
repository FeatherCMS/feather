//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import DOM
import FeatherContracts
import HTML
import Hummingbird
import SGML
import SVG
import WebBuilders
import WebComponents

public struct NewAdminSidebar: Component {

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
        context: inout RenderContext
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
        context: inout RenderContext
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
        context: inout RenderContext
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
        context: inout RenderContext
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
        context: inout RenderContext
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
        context: inout RenderContext
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
        context: inout RenderContext
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

    private func renderNavigation(context: inout RenderContext) -> Nav {
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
        context: inout RenderContext
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

extension DefaultRequestContext {

    public func adminMenuGroups(
        request: Request,
        events: any EventPublisher
    ) async throws -> [NewAdminSidebar.Group] {
        let catalog = try await load(events: events)
        let path = request.uri.path
        let permissions = currentUserPermissions
        let menuDefinitions = catalog.menus
            .filter { definition in
                guard let permission = definition.permission else {
                    return true
                }
                return permissions.contains(permission)
            }
            .sorted { $0.priority < $1.priority }

        var groups: [String: [NewAdminSidebar.Group.Menu]] = [:]
        for definition in menuDefinitions {
            let parentIcon =
                FeatherIcons.get(named: definition.icon)
                ?? FeatherIcons.helpCircle()

            let children = catalog.items
                .filter { $0.menuKey == definition.key }
                .filter { item in
                    guard let permission = item.permission else { return true }
                    return permissions.contains(permission)
                }
                .sorted { $0.priority < $1.priority }
                .compactMap { item in
                    let icon =
                        FeatherIcons.get(named: item.icon)
                        ?? FeatherIcons.helpCircle()
                    return NewAdminSidebar.Group.Menu.Item(
                        icon: icon,
                        label: item.label,
                        link: item.link,
                        isCurrent: isCurrent(item.link, path: path)
                    )
                }

            guard definition.link != nil || !children.isEmpty else {
                continue
            }

            let parent = NewAdminSidebar.Group.Menu.Item(
                icon: parentIcon,
                label: definition.label,
                link: definition.link,
                isCurrent: definition.link.map { isCurrent($0, path: path) }
                    ?? children.contains(where: { $0.isCurrent })
            )
            groups[definition.groupKey, default: []]
                .append(
                    .init(parent: parent, children: children)
                )
        }

        return ["site", "admin"]
            .compactMap { key in
                guard let menus = groups[key], !menus.isEmpty else {
                    return nil
                }
                return .init(
                    label: key == "site" ? "Site" : "Admin",
                    menus: menus
                )
            }
    }

    private func isCurrent(
        _ link: String,
        path: String
    ) -> Bool {
        let normalizedLink = normalizedPath(link)
        let currentPath = normalizedPath(path)

        guard normalizedLink != "/" else {
            return currentPath == "/"
        }

        // Match route segments rather than raw prefixes so query parameters
        // and trailing slashes do not affect selection, while similarly named
        // routes (for example `/variables` and `/variables-archive`) remain
        // distinct.
        guard
            currentPath == normalizedLink
                || currentPath.hasPrefix(normalizedLink + "/")
        else {
            return false
        }

        // The admin root is a standalone route and must not remain selected
        // for nested admin pages.
        if normalizedLink == "/admin" {
            return currentPath == normalizedLink
        }
        return true
    }

    private func normalizedPath(_ value: String) -> String {
        let path = String(
            value.split(
                separator: "?",
                maxSplits: 1,
                omittingEmptySubsequences: false
            )[0]
        )
        guard path.count > 1, path.hasSuffix("/") else {
            return path
        }
        return String(path.dropLast())
    }

    private func load(
        events: any EventPublisher
    ) async throws -> AdminMenuCatalog {
        let context = AdminEventContext(path: "", permissions: [])
        let menus =
            try await events.trigger(
                event: AdminMenuProvider(),
                using: context
            )
            .flatMap { $0 }
        var items: [AdminMenuItemDefinition] = []
        for menu in menus {
            items +=
                try await events.trigger(
                    event: AdminMenuItemProvider(menuKey: menu.key),
                    using: context
                )
                .flatMap { $0 }
        }
        return .init(menus: menus, items: items)
    }
}
