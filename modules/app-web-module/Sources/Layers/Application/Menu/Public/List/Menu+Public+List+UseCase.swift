//
//  ListMenus.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import FeatherModuleKit
public import WebModule

extension Menu.Public.List {
    public struct UseCase: FeatherApplication.UseCase {
        struct ItemPermissionAction: PermissionAction {
            let key: PermissionKey
        }

        let authorizer: any Authorizer
        let query: any QueryExecutor<Menu.Public.List.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Menu.Public.List.Scope>
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
                        menuItems: scope.menuItems,
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
                guard let menu = try await scope.menuLookup.find(key: key)
                else {
                    return nil
                }
                return try await makePublicMenu(
                    id: menu.id,
                    key: menu.key,
                    name: menu.name,
                    menuItems: scope.menuItems,
                    subject: subject
                )
            }
        }

        private func makePublicMenu(
            id: String,
            key: String,
            name: String,
            menuItems: any Query.Interface,
            subject: Subject?
        ) async throws -> Output.Menu {
            let items = try await menuItems.listMenuItems(menuId: id)
            let filteredItems = try await filterItems(
                items,
                subject: subject
            )
            return .init(
                id: id,
                key: key,
                name: name,
                items: filteredItems
            )
        }

        private func filterItems(
            _ items: [Query.Item],
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
            item: Query.Item,
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
