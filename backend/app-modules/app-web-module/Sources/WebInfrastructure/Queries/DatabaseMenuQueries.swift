import WebApplication
import FeatherDatabase
import Application
import Infrastructure

extension MenuTable.Row {

    var asQueryListItem: MenuList.Item {
        .init(
            id: id,
            key: key,
            name: name,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: MenuDetail {
        .init(
            id: id,
            key: key,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseMenuQueries: MenuQueries {

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

    func orderByMenu(
        _ query: MenuList.Query
    ) -> String {
        let sortParts = query.sort.map { menu -> String in
            let column: String
            switch menu.field {
            case .id:
                column = "id"
            case .key:
                column = "key"
            case .name:
                column = "name"
            case .createdAt:
                column = "created_at"
            case .updatedAt:
                column = "updated_at"
            }
            return "\(column) \(sortDirectionSQL(menu.direction))"
        }
        return (sortParts + ["id ASC"]).joined(separator: ", ")
    }

    public func find(
        id: String
    ) async throws -> MenuDetail {
        let table = MenuTable(connection: connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func list(
        query: MenuList.Query
    ) async throws -> MenuList {
        let page = pageSizeOffset(query.page)
        let table = MenuTable(connection: connection)
        let items =
            try await table.list(
                search: query.search,
                orderBy: orderByMenu(query),
                limit: page.size,
                offset: page.offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func count(
        query: MenuList.Query
    ) async throws -> Int {
        let table = MenuTable(connection: connection)
        return try await table.count(search: query.search)
    }
}
