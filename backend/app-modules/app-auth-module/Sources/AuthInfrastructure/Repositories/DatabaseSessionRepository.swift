import Domain
import AuthDomain
import Infrastructure
import FeatherDatabase
import struct Foundation.Date

extension SessionTable.Row {
    var asDomain: Session {
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

public struct DatabaseSessionRepository: SessionRepository {

    public var connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }

    public func findBy(
        id: String
    ) async throws -> Session? {
        let table = SessionTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func findBy(
        token: String
    ) async throws -> Session? {
        let table = SessionTable(connection: connection)
        return try await table.find(token: token)?.asDomain
    }

    public func insert(
        _ model: Session.New
    ) async throws -> Session {
        let table = SessionTable(connection: connection)
        let saved = try await table.save(
            row: .init(
                id: model.id,
                token: model.token,
                accountId: model.accountId,
                isPersistent: model.isPersistent,
                expiresAtInterval: model.expiresAtInterval
            )
        )
        return saved.asDomain
    }

    public func update(
        _ model: Session
    ) async throws -> Session {
        let table = SessionTable(connection: connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                token: model.token,
                accountId: model.accountId,
                isPersistent: model.isPersistent,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt,
                expiresAt: .init(timeIntervalSince1970: model.expiresAt)
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
        let table = SessionTable(connection: connection)
        return try await table.delete(id: id)
    }
}
