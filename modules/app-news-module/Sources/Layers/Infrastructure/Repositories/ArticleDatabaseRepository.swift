//
//  ArticleDatabaseRepository.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import NewsDomain
import WebDomain
import WebInfrastructure

extension ArticleTable.Row {
    func asDomain(
        metadata: Metadata,
        categoryIds: [String]
    ) -> Article {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            categoryIds: categoryIds,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct ArticleDatabaseRepository: ArticleRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(
        _ model: Article.New
    ) async throws -> Article {
        let table = ArticleTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId
            )
        )
        try await ArticleCategoryTable(connection: context.connection)
            .replace(
                articleID: saved.id,
                categoryIDs: model.categoryIds
            )
        var newMetadata = model.metadata
        try newMetadata.set(referenceID: saved.id)

        let metadata = try await MetadataDatabaseRepository(context: context)
            .insert(newMetadata)

        return saved.asDomain(
            metadata: metadata,
            categoryIds: model.categoryIds
        )
    }

    public func find(
        id: String
    ) async throws -> Article? {
        let table = ArticleTable(connection: context.connection)
        guard let article = try await table.find(id: id) else { return nil }
        let categoryIds = try await ArticleCategoryTable(
            connection: context.connection
        )
        .listCategoryIDs(articleID: id)
        guard
            let metadata = try await MetadataDatabaseRepository(
                context: context
            )
            .find(
                reference: .existing(.init(type: "news.article", id: id))
            )
        else { return nil }
        return article.asDomain(
            metadata: metadata,
            categoryIds: categoryIds
        )
    }

    public func update(
        _ model: Article
    ) async throws -> Article {
        let table = ArticleTable(connection: context.connection)
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
        try await ArticleCategoryTable(connection: context.connection)
            .replace(
                articleID: model.id,
                categoryIDs: model.categoryIds
            )
        _ = try await MetadataDatabaseRepository(context: context)
            .update(model.metadata)
        return updated.asDomain(
            metadata: model.metadata,
            categoryIds: model.categoryIds
        )
    }

    public func removeCategory(
        id: String
    ) async throws {
        try await ArticleCategoryTable(connection: context.connection)
            .removeCategory(id: id)
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        try await ArticleCategoryTable(connection: context.connection)
            .removeArticle(id: id)
        let table = ArticleTable(connection: context.connection)
        return try await table.delete(id: id)
    }
}
