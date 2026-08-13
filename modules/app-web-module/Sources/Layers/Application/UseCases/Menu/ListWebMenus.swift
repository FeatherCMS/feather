//
//  ListWebMenus.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import Foundation
import WebDomain

public struct ListPublicMenus: Sendable {
    struct ItemPermissionAction: PermissionAction {
        let key: PermissionKey
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadPublicMenu>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadPublicMenu>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public func execute(
        subject: Subject?
    ) async throws -> [PublicMenu] {
        try await query.run { scope in
            let menus = try await scope.menu.list(
                query: .init(
                    page: .init(size: 10_000, number: 1),
                    sort: [.init(field: .key, direction: .asc)]
                )
            )

            var result: [PublicMenu] = []

            for menu in menus.items {
                let menuItems = try await scope.menuItem.list(
                    menuId: menu.id,
                    query: .init(
                        page: .init(size: 10_000, number: 1),
                        sort: [
                            .init(field: .priority, direction: .asc),
                            .init(field: .label, direction: .asc),
                        ]
                    )
                )

                let items = try await filterItems(
                    menuItems.items,
                    subject: subject
                )

                guard !items.isEmpty else {
                    continue
                }

                result.append(
                    .init(
                        id: menu.id,
                        key: menu.key,
                        name: menu.name,
                        items: items
                    )
                )
            }

            return result
        }
    }

    private func filterItems(
        _ items: [MenuItemList.Item],
        subject: Subject?
    ) async throws -> [PublicMenuItem] {
        var result: [PublicMenuItem] = []

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
        item: MenuItemList.Item,
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

        let permission = item.permission.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

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
