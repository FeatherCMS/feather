//
//  Page.Repository.Database.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import WebDomain

extension Page.Repository {
    public struct Database: Interface {

        public let context: DatabaseTransactionContext
        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func insert(
            _ model: Page.Model.New
        ) async throws -> Page.Model {
            let accessLayer = DatabaseAccessLayer<Page.Table>(context: context)
            let id = context.idGenerator.generate()
            try await accessLayer.insert(
                Page.Table.Insert(
                    id: id,
                    title: model.title,
                    excerpt: model.excerpt,
                    content: model.content,
                    imageAssetId: model.imageAssetId
                )
            )

            // TODO: check future / existing flag
            var newMetadata = model.metadata
            try newMetadata.set(referenceID: id)

            let metadata = try await Metadata.Repository
                .Database(context: context)
                .insert(newMetadata)

            guard
                let saved = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                throw RepositoryError.notFound
            }
            return saved.asDomain(metadata: metadata)
        }

        public func find(
            id: String
        ) async throws -> Page.Model? {
            let accessLayer = DatabaseAccessLayer<Page.Table>(context: context)
            guard
                let page = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else { return nil }
            guard
                let metadata = try await Metadata.Repository
                    .Database(
                        context: context
                    )
                    .find(referenceType: "web.page", referenceId: id)
            else {
                return nil
            }
            return page.asDomain(metadata: metadata)
        }

        public func update(
            _ model: Page.Model
        ) async throws -> Page.Model {
            let accessLayer = DatabaseAccessLayer<Page.Table>(context: context)
            try await accessLayer.update(
                Page.Table.Update(
                    title: model.title,
                    excerpt: model.excerpt,
                    content: model.content,
                    imageAssetId: model.imageAssetId
                ),
                where: \.id,
                equals: model.id
            )
            _ = try await Metadata.Repository.Database(context: context)
                .update(model.metadata)
            guard
                let updated = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id
                )
            else {
                throw RepositoryError.notFound
            }
            return updated.asDomain(metadata: model.metadata)
        }

        public func delete(
            ids: [String]
        ) async throws -> [String] {
            try await DatabaseAccessLayer<Page.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
    }

    extension Page.Table.Detail {
    fileprivate func asDomain(
        metadata: Metadata.Model
    ) -> Page.Model {
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
