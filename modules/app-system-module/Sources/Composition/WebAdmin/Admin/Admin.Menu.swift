public import FeatherWebAdmin
import FeatherWebShared
public import FeatherModuleKit
public import Hummingbird

extension Admin {

    public enum Menu {

        public static func groups(
            for context: AuthenticatedRequestContext,
            request: Request,
            events: any EventPublisher
        ) async throws -> [AdminSideBar.Group] {
            let definitions = try await load(from: events)
            let path = request.uri.path
            let permissions = context.currentUserPermissions
            let visibleMenuDefinitions =
                definitions.groups
                .filter { definition in
                    guard let permission = definition.permission else {
                        return true
                    }
                    return permissions.contains(permission)
                }
                .sorted { $0.priority < $1.priority }

            var groups: [String: [AdminSideBar.Group.Menu]] = [:]
            for definition in visibleMenuDefinitions {
                let parentIcon =
                    FeatherIcons.get(named: definition.icon)
                    ?? FeatherIcons.helpCircle()

                let children =
                    definitions.items
                    .filter { $0.menuKey == definition.key }
                    .filter { item in
                        guard let permission = item.permission else {
                            return true
                        }
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

        private static func load(
            from events: any EventPublisher
        ) async throws -> Definitions {
            let context = Menu.Context(
                path: "",
                permissions: []
            )
            let menus =
                try await events.trigger(
                    event: Menu.Group.Provider(),
                    using: context
                )
                .flatMap { $0 }

            var items: [Menu.Item.Definition] = []
            for menu in menus {
                items +=
                    try await events.trigger(
                        event: Menu.Item.Provider(
                            menuKey: menu.key
                        ),
                        using: context
                    )
                    .flatMap { $0 }
            }
            return .init(groups: menus, items: items)
        }

        private static func isCurrent(_ link: String, path: String) -> Bool {
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

        private static func normalizedPath(_ value: String) -> String {
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
    }
}
