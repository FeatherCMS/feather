public import BlogApplication
public import BlogModule
import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

import struct Foundation.Data
import class Foundation.JSONDecoder

extension Post.Table.Detail {
    func asApplicationDetail(metadata: WebModule.Metadata.Snapshot) throws -> Post.Detail.Output {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            authorIds: try JSONDecoder().decode([String].self, from: Data(authorIds.utf8)),
            tagIds: try JSONDecoder().decode([String].self, from: Data(tagIds.utf8)),
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Post.Detail.Query {
    public struct Database: Interface {
        let context: DatabaseQueryContext
        let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            context: DatabaseQueryContext,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.context = context
            self.metadata = metadata
        }

        public func find(id: String) async throws -> Post.Detail.Output {
            guard
                let post = try await DatabaseAccessLayer<Post.Table>(context: context)
                    .selectFirst(by: \.id, equals: id, as: Post.Table.Detail.self)
            else {
                throw RepositoryError.notFound
            }
            guard
                let metadata = try await metadata.find(
                    referenceType: "blog.post",
                    referenceID: id
                )
            else {
                throw RepositoryError.notFound
            }
            return try post.asApplicationDetail(metadata: metadata)
        }
    }
}
