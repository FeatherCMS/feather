import Domain
import UserDomain
import Infrastructure
import FeatherDatabase
import struct Foundation.Date

extension RoleTable.Row {
    var asDomain: Role {
        .init(
            id: id,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseRoleRepository: RoleRepository {

    public var connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }

    public func findBy(
        id: String
    ) async throws -> Role? {
        let table = RoleTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func insert(
        _ model: Role.New
    ) async throws -> Role {
        let table = RoleTable(connection: connection)
        let saved = try await table.save(
            row: .init(
                id: model.id,
                name: model.name,
                notes: model.notes,
                createdAt: .init(timeIntervalSince1970: 0),
                updatedAt: .init(timeIntervalSince1970: 0)
            )
        )
        return saved.asDomain
    }

    public func update(
        _ model: Role
    ) async throws -> Role {
        let table = RoleTable(connection: connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                name: model.name,
                notes: model.notes,
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
        let table = RoleTable(connection: connection)
        return try await table.delete(id: id)
    }
}
