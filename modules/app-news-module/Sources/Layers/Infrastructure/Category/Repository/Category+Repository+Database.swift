//
//  CategoryDatabaseRepository.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import NewsDomain
import WebDomain
import WebInfrastructure

extension CategoryTable.Row {
    func asDomain(metadata: WebDomain.Metadata.Model) -> Category {
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

public struct CategoryDatabaseRepository: CategoryRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(
        _ model: Category.New
    ) async throws -> Category {
        let table = CategoryTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId
            )
        )
        var newMetadata = model.metadata
        try newMetadata.set(referenceID: saved.id)

        let metadata = try await Metadata.Repository.Database(context: context)
            .insert(newMetadata)
        return saved.asDomain(metadata: metadata)
    }

    public func find(
        id: String
    ) async throws -> Category? {
        let table = CategoryTable(connection: context.connection)
        guard let category = try await table.find(id: id) else { return nil }
        guard
            let metadata = try await Metadata.Repository.Database(
                context: context
            )
            .find(referenceType: "news.category", referenceId: id)
        else { return nil }
        return category.asDomain(metadata: metadata)
    }

    public func update(
        _ model: Category
    ) async throws -> Category {
        let table = CategoryTable(connection: context.connection)
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
        _ = try await Metadata.Repository.Database(context: context)
            .update(model.metadata)
        return updated.asDomain(metadata: model.metadata)
    }

    public func delete(
        ids: [String]
    ) async throws -> [String] {
        try await DatabaseAccessLayer<CategoryTable>(context: context)
            .delete(where: \.id, in: ids)
        return ids
    }
}
