public import BlogDomain
public import BlogModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
import WebDomain
import WebInfrastructure
import WebModule

import struct Foundation.Data
import class Foundation.JSONDecoder
import class Foundation.JSONEncoder

private func encodeIDs(_ ids: [String]) throws -> String {
    let data = try JSONEncoder().encode(ids)
    guard let result = String(data: data, encoding: .utf8) else {
        throw RepositoryError(
            reason: .unknown,
            logMessage: "Failed to encode blog post associations.",
            userFriendlyMessage: "Failed to save blog post associations."
        )
    }
    return result
}

private func decodeIDs(_ value: String) throws -> [String] {
    try JSONDecoder().decode([String].self, from: Data(value.utf8))
}

extension Post.Table.Detail {
    func asDomain(metadata: WebModule.Metadata.Model) throws -> Post.Model {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            authorIds: try decodeIDs(authorIds),
            tagIds: try decodeIDs(tagIds),
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Post.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext

        public init(context: DatabaseTransactionContext) {
            self.context = context
        }

        public func insert(_ model: Post.Model.New) async throws -> Post.Model {
            let accessLayer = DatabaseAccessLayer<Post.Table>(context: context)
            let id = context.idGenerator.generate()
            try await accessLayer.insert(
                Post.Table.Insert(
                    id: id,
                    title: model.title,
                    excerpt: model.excerpt,
                    content: model.content,
                    imageAssetId: model.imageAssetId,
                    authorIds: try encodeIDs(model.authorIds),
                    tagIds: try encodeIDs(model.tagIds)
                )
            )
            guard
                let post = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                throw RepositoryError.notFound
            }
            var newMetadata = model.metadata
            try newMetadata.set(referenceID: id)
            let metadata = try await WebModule.Metadata.Repository
                .Database(context: context)
                .insert(newMetadata)
            return try post.asDomain(metadata: metadata)
        }

        public func find(id: String) async throws -> Post.Model? {
            let accessLayer = DatabaseAccessLayer<Post.Table>(context: context)
            guard
                let post = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                return nil
            }
            guard
                let metadata = try await WebModule.Metadata.Repository
                    .Database(context: context)
                    .find(referenceType: "blog.post", referenceId: id)
            else {
                return nil
            }
            return try post.asDomain(metadata: metadata)
        }

        public func update(_ model: Post.Model) async throws -> Post.Model {
            let accessLayer = DatabaseAccessLayer<Post.Table>(context: context)
            try await accessLayer.update(
                Post.Table.Update(
                    title: model.title,
                    excerpt: model.excerpt,
                    content: model.content,
                    imageAssetId: model.imageAssetId,
                    authorIds: try encodeIDs(model.authorIds),
                    tagIds: try encodeIDs(model.tagIds)
                ),
                where: \.id,
                equals: model.id
            )
            guard
                let post = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id
                )
            else {
                throw RepositoryError.notFound
            }
            return try post.asDomain(metadata: model.metadata)
        }

        public func removeAuthor(id: String) async throws {
            let accessLayer = DatabaseAccessLayer<Post.Table>(context: context)
            let posts = try await accessLayer.select(as: Post.Table.Detail.self)
            { $0 }
            for post in posts {
                let authorIds = try decodeIDs(post.authorIds)
                guard authorIds.contains(id) else { continue }
                try await accessLayer.update(
                    Post.Table.Update(
                        title: post.title,
                        excerpt: post.excerpt,
                        content: post.content,
                        imageAssetId: post.imageAssetId,
                        authorIds: try encodeIDs(authorIds.filter { $0 != id }),
                        tagIds: post.tagIds
                    ),
                    where: \.id,
                    equals: post.id
                )
            }
        }

        public func removeTag(id: String) async throws {
            let accessLayer = DatabaseAccessLayer<Post.Table>(context: context)
            let posts = try await accessLayer.select(as: Post.Table.Detail.self)
            { $0 }
            for post in posts {
                let tagIds = try decodeIDs(post.tagIds)
                guard tagIds.contains(id) else { continue }
                try await accessLayer.update(
                    Post.Table.Update(
                        title: post.title,
                        excerpt: post.excerpt,
                        content: post.content,
                        imageAssetId: post.imageAssetId,
                        authorIds: post.authorIds,
                        tagIds: try encodeIDs(tagIds.filter { $0 != id })
                    ),
                    where: \.id,
                    equals: post.id
                )
            }
        }

        public func delete(ids: [String]) async throws -> [String] {
            try await DatabaseAccessLayer<Post.Table>(context: context)
                .delete(where: \.id, in: ids)
            return ids
        }
    }
}
