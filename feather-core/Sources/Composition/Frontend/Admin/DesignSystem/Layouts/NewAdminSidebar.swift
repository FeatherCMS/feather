//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import CSS
import DOM
import FeatherContracts
import HTML
import Hummingbird
import SGML
import SVG
import WebComponents
import WebBuilders

public struct NewAdminSidebar: Leaf {

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

    public func rules() -> [any Rule] {
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
        item: Group.Menu.Item
    ) -> Li {
        Li {
            if let link = item.link {
                A {
                    Icon(svg: item.icon).html()
                    Span(item.label)
                }
                .title(item.label)
                .href(link)
                .if(item.isCurrent) { $0.class("isCurrent") }
            }
            else {
                Icon(svg: item.icon).html()
                Span(item.label)
            }
        }
        .class("plain")
    }

    private func renderMenuParent(
        item: Group.Menu.Item
    ) -> [any FlowContent] {
        if let link = item.link {
            return [
                A {
                    Icon(svg: item.icon).html()
                    Span(item.label)
                }
                .title(item.label)
                .href(link)
            ]
        }
        else {
            return [
                Icon(svg: item.icon).html(),
                Span(item.label)
            ]
        }
    }

    private func renderSubmenuItem(
        item: Group.Menu.Item
    ) -> Li {
        Li {
            A {
                Icon(svg: item.icon).html()
                Span(item.label)
            }
            .title(item.label)
            .href(item.link)
            .if(item.isCurrent) { $0.class("isCurrent") }
        }
        .class("plain")
    }

    private func renderSubmenu(
        items: [Group.Menu.Item]
    ) -> Ul {
        Ul {
            for item in items {
                renderSubmenuItem(item: item)
            }
        }
        .class("sub-menu")
    }

    private func renderSubmenuMenu(
        menu: Group.Menu,
        index: Int
    ) -> Li {
        let hasCurrentChild = menu.children.contains(where: { $0.isCurrent })

        return Li {
            Input()
                .id("applicationMenu\(index)Toggle")
                .type(.checkbox)
                .class("submenu-toggle")
            Label {
                renderMenuParent(item: menu.parent)
            }
            .title(menu.parent.label)
            .for("applicationMenu\(index)Toggle")
            .class("submenu-label")
            .if(menu.parent.isCurrent) { $0.addClass("isCurrent") }
            renderSubmenu(items: menu.children)
        }
        .class("has-submenu", "plain")
        .if(hasCurrentChild) { $0.addClass("has-current") }
    }

    private func renderMenu(
        menu: Group.Menu,
        index: Int
    ) -> [any Element] {
        if menu.children.isEmpty {
            return [renderListItem(item: menu.parent)]
        }
        else {
            return [renderSubmenuMenu(menu: menu, index: index)]
        }
    }

    private func renderGroup(
        group: Group
    ) -> Li {
        Li {
            Span(group.label)
                .class("group-label")
            Ul {
                for (index, menu) in group.menus.enumerated() {
                    renderMenu(menu: menu, index: index)
                }
            }
            .class("group")
        }
        .class("plain")
    }

    private func renderNavigation() -> Nav {
        Nav {
            Ul {
                for group in groups {
                    renderGroup(group: group)
                }
            }
            .class("groups")
        }
        .class("menu")
    }

    public func html() -> some BasicTag {
        Div {
            Input()
                .id("menuToggle")
                .name("menuToggle")
                .type(.checkbox)
            renderNavigation()
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
            let parentIcon = FeatherIcons.get(named: definition.icon) ?? FeatherIcons.helpCircle()

            let children = catalog.items
                .filter { $0.menuKey == definition.key }
                .filter { item in
                    guard let permission = item.permission else { return true }
                    return permissions.contains(permission)
                }
                .sorted { $0.priority < $1.priority }
                .compactMap { item in
                    let icon = FeatherIcons.get(named: item.icon) ?? FeatherIcons.helpCircle()
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
                isCurrent: definition.link.map { isCurrent($0, path: path) } ?? children.contains(where: { $0.isCurrent })
            )
            groups[definition.groupKey, default: []].append(
                .init(parent: parent, children: children)
            )
        }

        return ["site", "admin"].compactMap { key in
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
        guard link != "/" else { return path == "/" }
        guard path == link || path.hasPrefix(link) else { return false }
        if link == "/admin/" {
            return path == link
        }
        return true
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
