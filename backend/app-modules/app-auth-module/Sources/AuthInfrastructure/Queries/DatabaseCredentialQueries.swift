import Application
import AuthApplication
import FeatherDatabase
import Infrastructure

extension CredentialTable.Row {

    var asQueryListItem: CredentialList.Item {
        .init(
            id: id,
            accountID: accountID,
            email: email,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: CredentialDetail {
        .init(
            id: id,
            accountID: accountID,
            email: email,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseCredentialQueries: CredentialQueries {

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

    private func orderByCredential(
        _ query: CredentialList.Query
    ) -> String {
        let sortParts = query.sort.map { rule -> String in
            let column: String
            switch rule.field {
            case .accountID:
                column = "account_id"
            case .email:
                column = "email"
            }
            return "\(column) \(sortDirectionSQL(rule.direction))"
        }
        return (sortParts + ["account_id ASC", "email ASC"])
            .joined(separator: ", ")
    }

    private func listCredentials(
        accountID: String?,
        query: CredentialList.Query
    ) async throws -> CredentialList {
        let page = pageSizeOffset(query.page)
        let orderBy = orderByCredential(query)
        let table = CredentialTable(connection: connection)
        let items =
            try await table.list(
                accountID: accountID,
                search: query.search,
                orderBy: orderBy,
                limit: page.size,
                offset: page.offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func list(
        query: CredentialList.Query
    ) async throws -> CredentialList {
        try await listCredentials(
            accountID: nil,
            query: query
        )
    }

    public func list(
        accountID: String,
        query: CredentialList.Query
    ) async throws -> CredentialList {
        try await listCredentials(
            accountID: accountID,
            query: query
        )
    }

    private func countCredentials(
        accountID: String?,
        query: CredentialList.Query
    ) async throws -> Int {
        let table = CredentialTable(connection: connection)
        return try await table.count(
            accountID: accountID,
            search: query.search
        )
    }

    public func count(
        query: CredentialList.Query
    ) async throws -> Int {
        try await countCredentials(
            accountID: nil,
            query: query
        )
    }

    public func count(
        accountID: String,
        query: CredentialList.Query
    ) async throws -> Int {
        try await countCredentials(
            accountID: accountID,
            query: query
        )
    }

    public func find(
        id: String
    ) async throws -> CredentialDetail {
        let table = CredentialTable(connection: connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func findBy(
        accountID: String
    ) async throws -> CredentialDetail? {
        let table = CredentialTable(connection: connection)
        return try await table.findBy(accountID: accountID)
            .map { row in
                row.asDetail
            }
    }

    public func findBy(
        email: String
    ) async throws -> CredentialDetail? {
        let table = CredentialTable(connection: connection)
        return try await table.findBy(email: email)
            .map { row in
                row.asDetail
            }
    }
}
