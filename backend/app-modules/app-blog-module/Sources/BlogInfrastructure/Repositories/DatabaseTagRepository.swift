import FeatherDatabase
import Domain
import BlogDomain
import Infrastructure

extension TagTable.Row {
    var asDomain: Tag {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseTagRepository: TagRepository {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func insert(
        _ model: Tag.New
    ) async throws -> Tag {
        let table = TagTable(connection: connection)
        let saved = try await table.create(
            row: .init(
                id: model.id,
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId
            )
        )
        return saved.asDomain
    }

    public func find(
        id: String
    ) async throws -> Tag? {
        let table = TagTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func update(
        _ model: Tag
    ) async throws -> Tag {
        let table = TagTable(connection: connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return updated.asDomain
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = TagTable(connection: connection)
        return try await table.delete(id: id)
    }
}
