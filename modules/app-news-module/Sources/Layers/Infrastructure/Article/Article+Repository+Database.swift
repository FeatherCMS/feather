//
//  Article+Repository+Database.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import NewsDomain
public import NewsModule
import WebDomain
import WebInfrastructure
import WebModule

extension Article.Table.Detail {
    func asDomain(
        metadata: WebModule.Metadata.Model,
        categoryIds: [String]
    ) -> Article.Model {
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

extension Article.Repository {
    public struct Database: Interface {

        public let context: DatabaseTransactionContext
        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func insert(
            _ model: Article.Model.New
        ) async throws -> Article.Model {
            let accessLayer = DatabaseAccessLayer<Article.Table>(
                context: context
            )
            let row = Article.Table.Insert(
                id: context.idGenerator.generate(),
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId
            )
            try await accessLayer.insert(row)
            guard
                let saved = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: row.id
                )
            else {
                throw RepositoryError.notFound
            }
            try await ArticleCategory.Table.replace(
                context: context,
                articleID: saved.id,
                categoryIDs: model.categoryIds
            )
            var newMetadata = model.metadata
            try newMetadata.set(referenceID: saved.id)

            let metadata = try await WebModule.Metadata.Repository
                .Database(context: context)
                .insert(newMetadata)

            return saved.asDomain(
                metadata: metadata,
                categoryIds: model.categoryIds
            )
        }

        public func find(
            id: String
        ) async throws -> Article.Model? {
            let accessLayer = DatabaseAccessLayer<Article.Table>(
                context: context
            )
            guard
                let article = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else { return nil }
            let categoryIds = try await ArticleCategory.Table.listCategoryIDs(
                context: context,
                articleID: id
            )
            guard
                let metadata = try await WebModule.Metadata.Repository
                    .Database(
                        context: context
                    )
                    .find(referenceType: "news.article", referenceId: id)
            else { return nil }
            return article.asDomain(
                metadata: metadata,
                categoryIds: categoryIds
            )
        }

        public func update(
            _ model: Article.Model
        ) async throws -> Article.Model {
            let accessLayer = DatabaseAccessLayer<Article.Table>(
                context: context
            )
            try await accessLayer.update(
                .init(
                    title: model.title,
                    excerpt: model.excerpt,
                    content: model.content,
                    imageAssetId: model.imageAssetId
                ),
                where: \.id,
                equals: model.id
            )
            guard
                let updated = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id
                )
            else {
                throw RepositoryError.notFound
            }
            try await ArticleCategory.Table.replace(
                context: context,
                articleID: model.id,
                categoryIDs: model.categoryIds
            )
            _ = try await WebModule.Metadata.Repository
                .Database(context: context)
                .update(model.metadata)
            return updated.asDomain(
                metadata: model.metadata,
                categoryIds: model.categoryIds
            )
        }

        public func removeCategory(
            id: String
        ) async throws {
            try await ArticleCategory.Table.removeCategory(
                context: context,
                id: id
            )
        }

        public func delete(
            ids: [String]
        ) async throws -> [String] {
            try await DatabaseAccessLayer<Article.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
}
