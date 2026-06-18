import FeatherDatabase
import Domain
import BlogDomain
import Infrastructure

extension AuthorTable.Row {
    var asDomain: Author {
        .init(
            id: id,
            name: name,
            excerpt: excerpt,
            content: content,
            profileImageAssetId: profileImageAssetId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseAuthorRepository: AuthorRepository {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func insert(
        _ model: Author.New
    ) async throws -> Author {
        let table = AuthorTable(connection: connection)
        let saved = try await table.create(
            row: .init(
                id: model.id,
                name: model.name,
                excerpt: model.excerpt,
                content: model.content,
                profileImageAssetId: model.profileImageAssetId
            )
        )
        return saved.asDomain
    }

    public func find(
        id: String
    ) async throws -> Author? {
        let table = AuthorTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func update(
        _ model: Author
    ) async throws -> Author {
        let table = AuthorTable(connection: connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                key: model.id,
                name: model.name,
                excerpt: model.excerpt,
                content: model.content,
                profileImageAssetId: model.profileImageAssetId,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return updated.asDomain
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = AuthorTable(connection: connection)
        return try await table.delete(id: id)
    }
}
