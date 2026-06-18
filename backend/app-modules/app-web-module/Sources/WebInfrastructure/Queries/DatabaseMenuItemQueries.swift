import WebApplication
import FeatherDatabase
import Application
import Infrastructure

extension MenuItemTable.Row {

    var asQueryListItem: MenuItemList.Item {
        .init(
            id: id,
            menuId: menuId,
            label: label,
            url: url,
            priority: priority,
            isBlank: isBlank,
            permission: permission,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: MenuItemDetail {
        .init(
            id: id,
            menuId: menuId,
            label: label,
            url: url,
            priority: priority,
            isBlank: isBlank,
            permission: permission,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseMenuItemQueries: MenuItemQueries {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    func pageSizeOffset(
        _ page: Search.Page
    ) -> (size: Int, offset: Int) {
        let size = max(1, page.size)
        let number = max(1, page.number)
        return (size, (number - 1) * size)
    }

    func sortDirectionSQL(
        _ direction: Search.SortDirection
    ) -> String {
        switch direction {
        case .asc:
            "ASC"
        case .desc:
            "DESC"
        }
    }

    func orderByMenuItem(
        _ query: MenuItemList.Query
    ) -> String {
        let sortParts = query.sort.map { item -> String in
            let column: String
            switch item.field {
            case .id:
                column = "id"
            case .label:
                column = "label"
            case .url:
                column = "url"
            case .priority:
                column = "priority"
            case .permission:
                column = "permission"
            case .createdAt:
                column = "created_at"
            case .updatedAt:
                column = "updated_at"
            }
            return "\(column) \(sortDirectionSQL(item.direction))"
        }
        return (sortParts + ["id ASC"]).joined(separator: ", ")
    }

    public func find(
        id: String
    ) async throws -> MenuItemDetail {
        let table = MenuItemTable(connection: connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func list(
        menuId: String,
        query: MenuItemList.Query
    ) async throws -> MenuItemList {
        let page = pageSizeOffset(query.page)
        let table = MenuItemTable(connection: connection)
        let items =
            try await table.list(
                menuId: menuId,
                search: query.search,
                orderBy: orderByMenuItem(query),
                limit: page.size,
                offset: page.offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func count(
        menuId: String,
        query: MenuItemList.Query
    ) async throws -> Int {
        let table = MenuItemTable(connection: connection)
        return try await table.count(menuId: menuId, search: query.search)
    }
}
