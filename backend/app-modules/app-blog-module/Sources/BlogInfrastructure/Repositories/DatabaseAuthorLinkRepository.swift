import FeatherDatabase
import Domain
import BlogDomain
import Infrastructure

extension AuthorLinkTable.Row {
    var asDomain: AuthorLink {
        .init(
            id: id,
            authorId: authorId,
            label: label,
            url: url,
            priority: priority,
            isBlank: isBlank,
            permission: permission,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseAuthorLinkRepository: AuthorLinkRepository {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func insert(
        _ model: AuthorLink.New
    ) async throws -> AuthorLink {
        let table = AuthorLinkTable(connection: connection)
        let saved = try await table.create(
            row: .init(
                id: model.id,
                authorId: model.authorId,
                label: model.label,
                url: model.url,
                priority: model.priority,
                isBlank: model.isBlank,
                permission: model.permission,
                notes: model.notes
            )
        )
        return saved.asDomain
    }

    public func find(
        id: String
    ) async throws -> AuthorLink? {
        let table = AuthorLinkTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func update(
        _ model: AuthorLink
    ) async throws -> AuthorLink {
        let table = AuthorLinkTable(connection: connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                authorId: model.authorId,
                label: model.label,
                url: model.url,
                priority: model.priority,
                isBlank: model.isBlank,
                permission: model.permission,
                notes: model.notes,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return updated.asDomain
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = AuthorLinkTable(connection: connection)
        return try await table.delete(id: id)
    }
}
