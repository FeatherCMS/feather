import Application
import Domain
import Foundation
import WebApplication
import BlogDomain

public struct GetPublicPost {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }

    let query: any QueryExecutor<ReadPublicBlogPost>

    public init(
        query: any QueryExecutor<ReadPublicBlogPost>
    ) {
        self.query = query
    }

    public func execute(
        id: String
    ) async throws -> PublicBlogPostDetail {
        let now = Date()
        return try await query.run { context in
            guard
                let metadata = try await context.metadata.find(
                    referenceType: "blog.post",
                    referenceID: id
                ),
                metadata.isDirectlyAccessible(at: now),
                let postID = metadata.referenceID
            else {
                throw Error(message: "Post not found")
            }

            let post = try await context.post.find(id: postID)
            var authors: [PublicBlogAuthorSummary] = []
            for authorID in post.authorIds {
                guard
                    let authorMetadata = try await context.metadata.find(
                        referenceType: "blog.author",
                        referenceID: authorID
                    ),
                    authorMetadata.isPublic(at: now)
                else {
                    continue
                }
                let author = try await context.author.find(id: authorID)
                authors.append(
                    .init(
                        id: author.id,
                        name: author.name,
                        excerpt: author.excerpt,
                        content: author.content,
                        imageAssetId: author.profileImageAssetId,
                        imageURL: "",
                        media: nil,
                        metadata: authorMetadata
                    )
                )
            }

            var tags: [PublicBlogTagSummary] = []
            for tagID in post.tagIds {
                guard
                    let tagMetadata = try await context.metadata.find(
                        referenceType: "blog.tag",
                        referenceID: tagID
                    ),
                    tagMetadata.isPublic(at: now)
                else {
                    continue
                }
                let tag = try await context.tag.find(id: tagID)
                tags.append(
                    .init(
                        id: tag.id,
                        title: tag.title,
                        excerpt: tag.excerpt,
                        imageAssetId: tag.imageAssetId,
                        imageURL: "",
                        media: nil,
                        metadata: tagMetadata
                    )
                )
            }

            return .init(
                id: post.id,
                title: post.title,
                excerpt: post.excerpt,
                content: post.content,
                imageAssetId: post.imageAssetId,
                imageURL: "",
                media: nil,
                metadata: metadata,
                authors: authors,
                tags: tags
            )
        }
    }
}
