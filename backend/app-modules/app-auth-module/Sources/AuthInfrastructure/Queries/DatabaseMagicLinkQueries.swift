import AuthApplication
import FeatherDatabase
import Application
import Infrastructure

extension MagicLinkTable.Row {

    var asQueryListItem: MagicLinkList.Item {
        .init(
            id: id,
            email: email,
            token: token,
            expiresAt: expiresAt,
            isPersistent: isPersistent,
            isUsed: isUsed,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: MagicLinkDetail {
        .init(
            id: id,
            email: email,
            token: token,
            expiresAt: expiresAt,
            isPersistent: isPersistent,
            isUsed: isUsed,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseMagicLinkQueries: MagicLinkQueries {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    private func pageSizeOffset(
        _ page: Search.Page
    ) -> (size: Int, offset: Int) {
        let size = max(1, page.size)
        let number = max(1, page.number)
        return (size, (number - 1) * size)
    }

    private func sortDirectionSQL(
        _ direction: Search.SortDirection
    ) -> String {
        switch direction {
        case .asc:
            "ASC"
        case .desc:
            "DESC"
        }
    }

    private func orderBySystemMagicLink(
        _ query: MagicLinkList.Query
    ) -> String {
        let sortParts = query.sort.map { rule -> String in
            let column: String
            switch rule.field {
            case .id:
                column = "id"
            }
            return "\(column) \(sortDirectionSQL(rule.direction))"
        }
        return (sortParts + ["id ASC"]).joined(separator: ", ")
    }

    public func find(
        id: String
    ) async throws -> MagicLinkDetail {
        let table = MagicLinkTable(connection: connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func list(
        query: MagicLinkList.Query
    ) async throws -> MagicLinkList {
        let search = query.search
        let page = pageSizeOffset(query.page)
        let orderBy = orderBySystemMagicLink(query)

        let table = MagicLinkTable(connection: connection)
        let items =
            try await table.list(
                search: search,
                orderBy: orderBy,
                limit: page.size,
                offset: page.offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func count(
        query: MagicLinkList.Query
    ) async throws -> Int {
        let table = MagicLinkTable(connection: connection)
        return try await table.count(search: query.search)
    }
}
