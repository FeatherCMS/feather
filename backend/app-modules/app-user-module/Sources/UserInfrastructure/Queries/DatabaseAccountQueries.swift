import UserApplication
import FeatherDatabase
import Application
import Infrastructure

extension AccountTable.Row {

    var asAccountStatus: AccountStatus {
        .init(rawValue: status) ?? .inactive
    }

    var asQueryListItem: AccountList.Item {
        .init(
            id: id,
            email: email,
            passwordHash: passwordHash,
            status: asAccountStatus,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: AccountDetail {
        .init(
            id: id,
            email: email,
            status: asAccountStatus,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseAccountQueries: AccountQueries {

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

    private func orderBySystemAccount(
        _ query: AccountList.Query
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
    ) async throws -> AccountDetail {
        let table = AccountTable(connection: connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func getRolesBy(
        accountId: String
    ) async throws -> [String] {
        let table = AccountTable(connection: connection)
        return try await table.listRoleNames(accountId: accountId)
    }

    public func getRoleIdsBy(
        accountId: String
    ) async throws -> [String] {
        let table = AccountTable(connection: connection)
        return try await table.listRoleIds(accountId: accountId)
    }

    public func getPermissionsBy(
        accountId: String
    ) async throws -> [String] {
        let table = AccountTable(connection: connection)
        return try await table.listPermissionNames(accountId: accountId)
    }

    public func list(
        query: AccountList.Query
    ) async throws -> AccountList {
        let search = query.search
        let page = pageSizeOffset(query.page)
        let orderBy = orderBySystemAccount(query)

        let table = AccountTable(connection: connection)
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
        query: AccountList.Query
    ) async throws -> Int {
        let table = AccountTable(connection: connection)
        return try await table.count(search: query.search)
    }
}
