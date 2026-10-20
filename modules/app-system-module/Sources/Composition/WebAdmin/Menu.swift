public import FeatherAdmin
public import FeatherModuleKit
public import Hummingbird

public enum Menu {}

private struct MenuCatalog: Sendable {
    let menus: [Events.Menu.Definition]
    let items: [Events.MenuItem.Definition]

    static func load(from events: any EventPublisher) async throws -> Self {
        let context = Events.Context(
            path: "",
            permissions: []
        )
        let menus =
            try await events.trigger(
                event: Events.Menu.Provider(),
                using: context
            )
            .flatMap { $0 }

        var items: [Events.MenuItem.Definition] = []
        for menu in menus {
            items +=
                try await events.trigger(
                    event: Events.MenuItem.Provider(
                        menuKey: menu.key
                    ),
                    using: context
                )
                .flatMap { $0 }
        }
        return .init(menus: menus, items: items)
    }
}

extension Menu {
    public static func groups(
        for context: AuthenticatedRequestContext,
        request: Request,
        events: any EventPublisher
    ) async throws -> [AdminSideBar.Group] {
        let catalog = try await MenuCatalog.load(from: events)
        let path = request.uri.path
        let permissions = context.currentUserPermissions
        let menuDefinitions = catalog.menus
            .filter { definition in
                guard let permission = definition.permission else {
                    return true
                }
                return permissions.contains(permission)
            }
            .sorted { $0.priority < $1.priority }

        var groups: [String: [AdminSideBar.Group.Menu]] = [:]
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
                    return AdminSideBar.Group.Menu.Item(
                        icon: icon,
                        label: item.label,
                        link: item.link,
                        isCurrent: isCurrent(item.link, path: path)
                    )
                }

            guard definition.link != nil || !children.isEmpty else {
                continue
            }

            let parent = AdminSideBar.Group.Menu.Item(
                icon: parentIcon,
                label: definition.label,
                link: definition.link,
                isCurrent: definition.link.map { isCurrent($0, path: path) }
                    ?? children.contains(where: { $0.isCurrent })
            )
            groups[definition.groupKey, default: []]
                .append(.init(parent: parent, children: children))
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
}

private func isCurrent(_ link: String, path: String) -> Bool {
    let normalizedLink = normalizedPath(link)
    let currentPath = normalizedPath(path)

    guard normalizedLink != "/" else {
        return currentPath == "/"
    }

    guard
        currentPath == normalizedLink
            || currentPath.hasPrefix(normalizedLink + "/")
    else {
        return false
    }

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
