//
//  Category+Repository+Database.swift
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

extension Category.Table.Detail {
    func asDomain(metadata: WebModule.Metadata.Model) -> Category.Model {
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

extension Category.Repository {
    public struct Database: Interface {

        public let context: DatabaseTransactionContext
        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func insert(
            _ model: Category.Model.New
        ) async throws -> Category.Model {
            let accessLayer = DatabaseAccessLayer<Category.Table>(
                context: context
            )
            let row = Category.Table.Insert(
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
            var newMetadata = model.metadata
            try newMetadata.set(referenceID: saved.id)

            let metadata = try await WebModule.Metadata.Repository
                .Database(context: context)
                .insert(newMetadata)
            return saved.asDomain(metadata: metadata)
        }

        public func find(
            id: String
        ) async throws -> Category.Model? {
            let accessLayer = DatabaseAccessLayer<Category.Table>(
                context: context
            )
            guard
                let category = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else { return nil }
            guard
                let metadata = try await WebModule.Metadata.Repository
                    .Database(
                        context: context
                    )
                    .find(referenceType: "news.category", referenceId: id)
            else { return nil }
            return category.asDomain(metadata: metadata)
        }

        public func update(
            _ model: Category.Model
        ) async throws -> Category.Model {
            let accessLayer = DatabaseAccessLayer<Category.Table>(
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
            _ = try await WebModule.Metadata.Repository
                .Database(context: context)
                .update(model.metadata)
            return updated.asDomain(metadata: model.metadata)
        }

        public func delete(
            ids: [String]
        ) async throws -> [String] {
            try await DatabaseAccessLayer<Category.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
}
