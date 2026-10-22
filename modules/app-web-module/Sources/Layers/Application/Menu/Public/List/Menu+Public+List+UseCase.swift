//
//  ListMenus.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
public import FeatherModuleKit
public import WebDomain

extension Menu.Public.List {
    public struct UseCase: Sendable {
        struct ItemPermissionAction: PermissionAction {
            let key: PermissionKey
        }

        let authorizer: any Authorizer
        let query: any QueryExecutor<Menu.Public.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Menu.Public.Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(
            subject: Subject?
        ) async throws -> Output {
            try await query.run { scope in
                let menus = try await scope.menuList.list()

                var result: [Output.Menu] = []

                for menu in menus.items {
                    let publicMenu = try await makePublicMenu(
                        id: menu.id,
                        key: menu.key,
                        name: menu.name,
                        menuItems: scope.menuItemList,
                        subject: subject
                    )
                    guard !publicMenu.items.isEmpty else { continue }
                    result.append(publicMenu)
                }

                return .init(menus: result)
            }
        }

        public func execute(
            key: String,
            subject: Subject?
        ) async throws -> Output.Menu? {
            try await query.run { scope in
                guard let menu = try await scope.menuDetail.find(key: key)
                else {
                    return nil
                }
                return try await makePublicMenu(
                    id: menu.id,
                    key: menu.key,
                    name: menu.name,
                    menuItems: scope.menuItemList,
                    subject: subject
                )
            }
        }

        private func makePublicMenu(
            id: String,
            key: String,
            name: String,
            menuItems: any MenuItem.List.Query.Interface,
            subject: Subject?
        ) async throws -> Output.Menu {
            let menuItems = try await menuItems.list(menuId: id)
            let items = try await filterItems(menuItems.items, subject: subject)
            return .init(id: id, key: key, name: name, items: items)
        }

        private func filterItems(
            _ items: [MenuItem.List.Output.Item],
            subject: Subject?
        ) async throws -> [Output.Menu.Item] {
            var result: [Output.Menu.Item] = []

            for item in items
            where try await isAvailable(item: item, subject: subject) {
                result.append(
                    .init(
                        id: item.id,
                        label: item.label,
                        url: item.url,
                        priority: item.priority,
                        isBlank: item.isBlank
                    )
                )
            }

            return result
        }

        private func isAvailable(
            item: MenuItem.List.Output.Item,
            subject: Subject?
        ) async throws -> Bool {
            switch item.authentication {
            case .any:
                break
            case .anonymous:
                guard subject == nil else { return false }
            case .authenticated:
                guard subject != nil else { return false }
            }

            let permission = item.permission

            guard !permission.isEmpty else {
                return true
            }
            guard let subject else {
                return false
            }

            return try await authorizer.can(
                subject: subject,
                perform: ItemPermissionAction(key: .init(permission))
            )
        }
    }
}
