import AuthApplication
import FeatherDatabase
import Application
import Infrastructure

extension CredentialTable.Row {

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
        return try await table.findBy(accountID: accountID).map { row in
            row.asDetail
        }
    }

    public func findBy(
        email: String
    ) async throws -> CredentialDetail? {
        let table = CredentialTable(connection: connection)
        return try await table.findBy(email: email).map { row in
            row.asDetail
        }
    }
}
