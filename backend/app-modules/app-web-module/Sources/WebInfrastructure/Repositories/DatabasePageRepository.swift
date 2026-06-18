import FeatherDatabase
import Domain
import WebDomain
import Infrastructure

extension PageTable.Row {
    var asDomain: Page {
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

public struct DatabasePageRepository: PageRepository {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func insert(
        _ model: Page.New
    ) async throws -> Page {
        let table = PageTable(connection: connection)
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
    ) async throws -> Page? {
        let table = PageTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func update(
        _ model: Page
    ) async throws -> Page {
        let table = PageTable(connection: connection)
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
        let table = PageTable(connection: connection)
        return try await table.delete(id: id)
    }
}
