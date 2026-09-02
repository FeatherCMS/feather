//
//  PageDatabaseRepository.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import WebDomain

public struct PageDatabaseRepository: PageRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(
        _ model: Page.New
    ) async throws -> Page {
        let table = PageTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId
            )
        )

        // TODO: check future / existing flag
        var newMetadata = model.metadata
        try newMetadata.set(referenceID: saved.id)

        let metadata = try await MetadataDatabaseRepository(context: context)
            .insert(newMetadata)

        return saved.asDomain(metadata: metadata)
    }

    public func find(
        id: String
    ) async throws -> Page? {
        let table = PageTable(connection: context.connection)
        guard let page = try await table.find(id: id) else { return nil }
        guard
            let metadata = try await MetadataDatabaseRepository(
                context: context
            )
            .find(reference: .existing(.init(type: "web.page", id: id)))
        else {
            return nil
        }
        return page.asDomain(metadata: metadata)
    }

    public func update(
        _ model: Page
    ) async throws -> Page {
        let table = PageTable(connection: context.connection)
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
        _ = try await MetadataDatabaseRepository(context: context)
            .update(model.metadata)
        return updated.asDomain(metadata: model.metadata)
    }

    public func delete(
        ids: [String]
    ) async throws -> [String] {
        let table = PageTable(connection: context.connection)
        return try await table.delete(ids: ids)
    }
}

extension PageTable.Row {
    fileprivate func asDomain(
        metadata: Metadata
    ) -> Page {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
