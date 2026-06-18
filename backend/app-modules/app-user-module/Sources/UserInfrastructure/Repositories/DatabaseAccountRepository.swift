import Domain
import UserDomain
import UserApplication
import Application
import Infrastructure
import FeatherDatabase

extension AccountTable.Row {
    var asDomain: Account {
        get throws {
            guard let status = Account.Status(rawValue: status) else {
                throw RepositoryError.invalidEnumValue(status)
            }
            return .init(
                id: id,
                email: email,
                passwordHash: passwordHash,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
    }
}

public struct DatabaseAccountRepository: AccountRepository {

    public var connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
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

    func orderByUserAccount(
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

    // MARK: -

    public func insert(
        _ model: Account.New
    ) async throws -> Account {
        let table = AccountTable(connection: connection)
        let saved = try await table.save(
            row: .init(
                id: model.id,
                email: model.email,
                password: model.passwordHash,
                status: model.status.rawValue
            )
        )
        return try saved.asDomain
    }

    public func listUserAccounts(
        query: AccountList.Query
    ) async throws -> [Account] {
        let search = query.search
        let page = pageSizeOffset(query.page)
        let orderBy = orderByUserAccount(query)

        let table = AccountTable(connection: connection)
        return
            try await table.list(
                search: search,
                orderBy: orderBy,
                limit: page.size,
                offset: page.offset
            )
            .map { try $0.asDomain }
    }

    public func countUserAccounts(
        query: AccountList.Query
    ) async throws -> Int {
        let search = query.search
        let table = AccountTable(connection: connection)
        return try await table.count(search: search)
    }

    public func findBy(
        id: String
    ) async throws -> Account? {
        let table = AccountTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func findBy(
        email: String
    ) async throws -> Account? {
        let table = AccountTable(connection: connection)
        return try await table.find(email: email)?.asDomain
    }

    public func findPasswordHashBy(
        email: String
    ) async throws -> String? {
        let table = AccountTable(connection: connection)
        return try await table.find(email: email)?.passwordHash
    }

    public func findAccountBy(
        sessionToken: String
    ) async throws -> Account? {
        let table = AccountTable(connection: connection)
        return try await table.find(sessionToken: sessionToken)?.asDomain
    }

    public func findRolesBy(
        accountId: String
    ) async throws -> [String] {
        let table = AccountTable(connection: connection)
        return try await table.listRoleNames(accountId: accountId)
    }

    public func findRoleIdsBy(
        accountId: String
    ) async throws -> [String] {
        let table = AccountTable(connection: connection)
        return try await table.listRoleIds(accountId: accountId)
    }

    public func findPermissionsBy(
        accountId: String
    ) async throws -> [String] {
        let table = AccountTable(connection: connection)
        return try await table.listPermissionNames(accountId: accountId)
    }

    public func update(
        _ model: Account
    ) async throws -> Account {
        let table = AccountTable(connection: connection)
        let rowId = model.id
        let updated = try await table.update(
            id: rowId,
            row: .init(
                id: model.id,
                email: model.email,
                passwordHash: model.passwordHash,
                status: model.status.rawValue,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        guard let updated else {
            throw RepositoryError.notFound
        }
        return try updated.asDomain
    }

    public func replaceRoleIds(
        accountId: String,
        roleIds: [String]
    ) async throws {
        let table = AccountTable(connection: connection)
        try await table.replaceRoleIds(accountId: accountId, roleIds: roleIds)
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = AccountTable(connection: connection)
        return try await table.delete(id: id)
    }
}
