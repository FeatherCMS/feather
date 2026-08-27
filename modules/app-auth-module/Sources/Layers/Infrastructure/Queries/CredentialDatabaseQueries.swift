import AuthApplication
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherInfrastructure

extension CredentialTable.Row {

    var asQueryListItem: CredentialList.Item {
        .init(
            id: id,
            userId: userId,
            email: email,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: CredentialDetail {
        .init(
            id: id,
            userId: userId,
            email: email,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct CredentialDatabaseQueries: CredentialQueries {

    public let context: DatabaseQueryContext

    public init(context: DatabaseQueryContext) {
        self.context = context
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
            case .userId:
                column = "user_id"
            case .email:
                column = "email"
            }
            return "\(column) \(sortDirectionSQL(rule.direction))"
        }
        return (sortParts + ["user_id ASC", "email ASC"])
            .joined(separator: ", ")
    }

    private func listCredentials(
        userId: String?,
        query: CredentialList.Query
    ) async throws -> CredentialList {
        let page = pageSizeOffset(query.page)
        let orderBy = orderByCredential(query)
        let table = CredentialTable(connection: context.connection)
        let items =
            try await table.list(
                userId: userId,
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
            userId: nil,
            query: query
        )
    }

    public func list(
        userId: String,
        query: CredentialList.Query
    ) async throws -> CredentialList {
        try await listCredentials(
            userId: userId,
            query: query
        )
    }

    private func countCredentials(
        userId: String?,
        query: CredentialList.Query
    ) async throws -> Int {
        let table = CredentialTable(connection: context.connection)
        return try await table.count(
            userId: userId,
            search: query.search
        )
    }

    public func count(
        query: CredentialList.Query
    ) async throws -> Int {
        try await countCredentials(
            userId: nil,
            query: query
        )
    }

    public func count(
        userId: String,
        query: CredentialList.Query
    ) async throws -> Int {
        try await countCredentials(
            userId: userId,
            query: query
        )
    }

    public func find(
        id: String
    ) async throws -> CredentialDetail {
        let table = CredentialTable(connection: context.connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func findBy(
        userId: String
    ) async throws -> CredentialDetail? {
        let table = CredentialTable(connection: context.connection)
        return try await table.findBy(userId: userId)
            .map { row in
                row.asDetail
            }
    }

    public func findBy(
        email: String
    ) async throws -> CredentialDetail? {
        let table = CredentialTable(connection: context.connection)
        return try await table.findBy(email: email)
            .map { row in
                row.asDetail
            }
    }
}
