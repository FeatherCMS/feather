import Domain
import AuthDomain
import Infrastructure
import FeatherDatabase
import struct Foundation.Date


extension CredentialTable.Row {

    var asDomain: Credential {
        .init(
            id: id,
            accountID: accountID,
            email: email,
            passwordHash: passwordHash,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseCredentialRepository: CredentialRepository {

    public var connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }

    public func findBy(
        id: String
    ) async throws -> Credential? {
        let table = CredentialTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func findBy(
        accountID: String
    ) async throws -> Credential? {
        let table = CredentialTable(connection: connection)
        return try await table.findBy(accountID: accountID)?.asDomain
    }

    public func findBy(
        email: String
    ) async throws -> Credential? {
        let table = CredentialTable(connection: connection)
        return try await table.findBy(email: email)?.asDomain
    }

    public func insert(
        _ model: Credential.New
    ) async throws -> Credential {
        let table = CredentialTable(connection: connection)
        let saved = try await table.save(
            row: .init(
                id: model.id,
                accountID: model.accountID,
                email: model.email,
                passwordHash: model.passwordHash,
                createdAt: .init(timeIntervalSince1970: 0),
                updatedAt: .init(timeIntervalSince1970: 0)
            )
        )
        return saved.asDomain
    }

    public func update(
        _ model: Credential
    ) async throws -> Credential {
        let table = CredentialTable(connection: connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                accountID: model.accountID,
                email: model.email,
                passwordHash: model.passwordHash,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        guard let updated else {
            throw RepositoryError.notFound
        }
        return updated.asDomain
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = CredentialTable(connection: connection)
        return try await table.delete(id: id)
    }
}
