import Domain
import AuthDomain
import Infrastructure
import FeatherDatabase
import struct Foundation.Date

extension MagicLinkTable.Row {
    var asDomain: MagicLink {
        .init(
            id: id,
            email: email,
            token: token,
            expiresAt: expiresAt,
            isPersistent: isPersistent,
            isUsed: isUsed,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseMagicLinkRepository: MagicLinkRepository {

    public var connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }

    public func findById(
        id: String
    ) async throws -> MagicLink? {
        let table = MagicLinkTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func insert(
        _ model: MagicLink.New
    ) async throws -> MagicLink {
        let table = MagicLinkTable(connection: connection)
        let saved = try await table.save(
            row: .init(
                id: model.id,
                email: model.email,
                token: model.token,
                expiresAtInterval: model.expiresAtInterval,
                isPersistent: model.isPersistent,
                isUsed: false
            )
        )
        return saved.asDomain
    }

    public func update(
        _ model: MagicLink
    ) async throws -> MagicLink {
        let table = MagicLinkTable(connection: connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                email: model.email,
                token: model.token,
                expiresAt: model.expiresAt,
                isPersistent: model.isPersistent,
                isUsed: model.isUsed,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        guard let updated else {
            throw RepositoryError.notFound
        }
        return updated.asDomain
    }

    public func consumeByToken(
        token: String,
        now: Double
    ) async throws -> MagicLink {
        let table = MagicLinkTable(connection: connection)
        guard let consumed = try await table.consume(token: token, now: now)
        else {
            throw RepositoryError.notFound
        }
        return consumed.asDomain
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = MagicLinkTable(connection: connection)
        return try await table.delete(id: id)
    }
}
