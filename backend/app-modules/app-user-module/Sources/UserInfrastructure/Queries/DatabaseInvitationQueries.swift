import UserApplication
import FeatherDatabase
import Application
import Infrastructure

extension InvitationTable.Row {

    var asQueryListItem: InvitationList.Item {
        .init(
            id: id,
            email: email,
            token: token,
            expiresAt: expiresAt,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: InvitationDetail {
        .init(
            id: id,
            email: email,
            token: token,
            expiresAt: expiresAt,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseInvitationQueries: InvitationQueries {

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

    private func orderBySystemInvitation(
        _ query: InvitationList.Query
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

    public func getBy(
        id: String
    ) async throws -> InvitationDetail {
        let table = InvitationTable(connection: connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func list(
        query: InvitationList.Query
    ) async throws -> InvitationList {
        let search = query.search
        let page = pageSizeOffset(query.page)
        let orderBy = orderBySystemInvitation(query)

        let table = InvitationTable(connection: connection)
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
        query: InvitationList.Query
    ) async throws -> Int {
        let table = InvitationTable(connection: connection)
        return try await table.count(search: query.search)
    }
}
