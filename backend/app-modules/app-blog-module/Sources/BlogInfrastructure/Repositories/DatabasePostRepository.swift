import FeatherDatabase
import Domain
import BlogDomain
import Infrastructure

extension PostTable.Row {
    var asDomain: Post {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            authorIds: authorIds,
            tagIds: tagIds,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabasePostRepository: PostRepository {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func insert(
        _ model: Post.New
    ) async throws -> Post {
        let table = PostTable(connection: connection)
        let saved = try await table.create(
            row: .init(
                id: model.id,
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId,
                authorIds: model.authorIds,
                tagIds: model.tagIds
            )
        )
        return saved.asDomain
    }

    public func find(
        id: String
    ) async throws -> Post? {
        let table = PostTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func update(
        _ model: Post
    ) async throws -> Post {
        let table = PostTable(connection: connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId,
                authorIds: model.authorIds,
                tagIds: model.tagIds,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return updated.asDomain
    }

    public func removeAuthor(
        id: String
    ) async throws {
        let table = PostTable(connection: connection)
        try await table.removeAuthorReference(id: id)
    }

    public func removeTag(
        id: String
    ) async throws {
        let table = PostTable(connection: connection)
        try await table.removeTagReference(id: id)
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = PostTable(connection: connection)
        return try await table.delete(id: id)
    }
}
