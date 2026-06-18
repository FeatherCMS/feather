import Domain
import UserDomain
import Infrastructure
import FeatherDatabase
import struct Foundation.Date

extension InvitationTable.Row {
    var asDomain: Invitation {
        .init(
            id: id,
            email: email,
            token: token,
            expiresAt: expiresAt,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseInvitationRepository: InvitationRepository {

    public var connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }

    public func findBy(
        id: String
    ) async throws -> Invitation? {
        let table = InvitationTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func insert(
        _ model: Invitation.New
    ) async throws -> Invitation {
        let table = InvitationTable(connection: connection)
        let saved = try await table.save(
            row: .init(
                id: model.id,
                email: model.email,
                token: model.token,
                expiresAtInterval: model.expiresAtInterval
            )
        )
        return saved.asDomain
    }

    public func update(
        _ model: Invitation
    ) async throws -> Invitation {
        let table = InvitationTable(connection: connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                email: model.email,
                token: model.token,
                expiresAt: model.expiresAt,
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
        let table = InvitationTable(connection: connection)
        return try await table.delete(id: id)
    }
}
