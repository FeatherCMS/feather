import AuthApplication
import FeatherDatabase
import Application
import Infrastructure
import struct Foundation.Date

extension SessionTable.Row {

    var asQueryListItem: SessionList.Item {
        .init(
            id: id,
            token: token,
            accountId: accountId,
            expiresAt: expiresAt.timeIntervalSince1970,
            isPersistent: isPersistent,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseSessionQueries: SessionQueries {

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

    public func find(
        id: String
    ) async throws -> SessionDetail {
        let table = SessionTable(connection: connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return .init(
            id: row.id,
            token: row.token,
            accountId: row.accountId,
            expiresAt: row.expiresAt.timeIntervalSince1970,
            isPersistent: row.isPersistent,
            createdAt: row.createdAt,
            updatedAt: row.updatedAt
        )
    }

    public func list(
        query: SessionList.Query
    ) async throws -> SessionList {
        let table = SessionTable(connection: connection)
        let rows = try await table.list()

        let searched = rows.filter { row in
            if let accountId = query.accountId,
                row.accountId != accountId
            {
                return false
            }
            guard let search = query.search?.lowercased(), !search.isEmpty
            else {
                return true
            }
            return row.id.lowercased().contains(search)
                || row.token.lowercased().contains(search)
                || row.accountId.lowercased().contains(search)
                || String(row.expiresAt.timeIntervalSince1970).contains(search)
                || String(row.isPersistent).lowercased().contains(search)
        }

        let sorted = searched.sorted { lhs, rhs in
            let direction = query.sort.first?.direction ?? .asc
            switch direction {
            case .asc:
                return lhs.id < rhs.id
            case .desc:
                return lhs.id > rhs.id
            }
        }

        let page = pageSizeOffset(query.page)
        let paged = Array(sorted.dropFirst(page.offset).prefix(page.size))
        let items = paged.map(\.asQueryListItem)

        return .init(items: items)
    }
}
