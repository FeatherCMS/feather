import AuthDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

import struct Foundation.Date

extension CredentialTable.Row {

    var asDomain: Credential {
        .init(
            id: id,
            userId: userId,
            email: email,
            passwordHash: passwordHash,
            isPersistent: isPersistent,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct CredentialDatabaseRepository: CredentialRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func findBy(
        id: String
    ) async throws -> Credential? {
        let table = CredentialTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func findBy(
        userId: String
    ) async throws -> Credential? {
        let table = CredentialTable(connection: context.connection)
        return try await table.findBy(userId: userId)?.asDomain
    }

    public func findBy(
        email: String
    ) async throws -> Credential? {
        let table = CredentialTable(connection: context.connection)
        return try await table.findBy(email: email)?.asDomain
    }

    public func insert(
        _ model: Credential.New
    ) async throws -> Credential {
        let table = CredentialTable(connection: context.connection)
        let saved = try await table.save(
            row: .init(
                id: context.idGenerator.generate(),
                userId: model.userId,
                email: model.email,
                passwordHash: model.passwordHash,
                isPersistent: model.isPersistent,
                createdAt: .init(timeIntervalSince1970: 0),
                updatedAt: .init(timeIntervalSince1970: 0)
            )
        )
        return saved.asDomain
    }

    public func update(
        _ model: Credential
    ) async throws -> Credential {
        let table = CredentialTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                userId: model.userId,
                email: model.email,
                passwordHash: model.passwordHash,
                isPersistent: model.isPersistent,
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
        let table = CredentialTable(connection: context.connection)
        return try await table.delete(id: id)
    }
}
