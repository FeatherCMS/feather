import AuthDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

import struct Foundation.Date

extension CredentialTable.Row {

    var asDomain: Credential {
        .init(
            id: id,
            identityEmailId: identityEmailId,
            userId: userId,
            email: email,
            passwordHash: passwordHash,
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
        let emailTable = IdentityEmailTable(connection: context.connection)
        let identityEmail: IdentityEmailTable.Row
        if let existing = try await emailTable.findBy(
            identityId: model.userId,
            email: model.email
        ) {
            identityEmail = existing
        }
        else {
            identityEmail = try await emailTable.save(
                id: context.idGenerator.generate(),
                identityId: model.userId,
                email: model.email
            )
        }
        let saved = try await table.save(
            row: .init(
                id: context.idGenerator.generate(),
                identityEmailId: identityEmail.id,
                userId: model.userId,
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
        let table = CredentialTable(connection: context.connection)
        let emailTable = IdentityEmailTable(connection: context.connection)
        let identityEmail: IdentityEmailTable.Row
        if let existing = try await emailTable.findBy(
            identityId: model.userId,
            email: model.email
        ) {
            identityEmail = existing
        }
        else {
            identityEmail = try await emailTable.save(
                id: context.idGenerator.generate(),
                identityId: model.userId,
                email: model.email
            )
        }
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                identityEmailId: identityEmail.id,
                userId: model.userId,
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
        ids: [String]
    ) async throws -> [String] {
        let table = CredentialTable(connection: context.connection)
        return try await table.delete(ids: ids)
    }
}
