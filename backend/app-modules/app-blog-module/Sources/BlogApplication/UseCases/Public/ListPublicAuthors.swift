import Application
import Foundation
import WebApplication
import BlogDomain

public struct ListPublicAuthors {
    let query: any QueryExecutor<ReadPublicBlogAuthor>

    public init(
        query: any QueryExecutor<ReadPublicBlogAuthor>
    ) {
        self.query = query
    }

    public func execute() async throws -> [PublicBlogAuthorSummary] {
        let now = Date()
        return try await query.run { context in
            let authors = try await context.author.list(
                query: .init(
                    page: .init(size: 10_000, number: 1),
                    sort: [.init(field: .createdAt, direction: .desc)]
                )
            )
            var result: [PublicBlogAuthorSummary] = []
            for item in authors.items {
                guard
                    let metadata = try await context.metadata.find(
                        referenceType: "blog.author",
                        referenceID: item.id
                    ),
                    metadata.isPublic(at: now)
                else {
                    continue
                }
                let author = try await context.author.find(id: item.id)
                result.append(
                    .init(
                        id: author.id,
                        name: author.name,
                        excerpt: author.excerpt,
                        content: author.content,
                        imageAssetId: author.profileImageAssetId,
                        imageURL: "",
                        media: nil,
                        metadata: metadata
                    )
                )
            }
            return result
        }
    }
}
