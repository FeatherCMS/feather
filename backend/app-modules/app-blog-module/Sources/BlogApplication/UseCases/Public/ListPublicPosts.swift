import Application
import Foundation
import WebApplication
import BlogDomain

public struct ListPublicPosts {
    let query: any QueryExecutor<ReadPublicBlogPost>

    public init(
        query: any QueryExecutor<ReadPublicBlogPost>
    ) {
        self.query = query
    }

    public func execute() async throws -> [PublicBlogPostSummary] {
        let now = Date()
        return try await query.run { context in
            let posts = try await context.post.list(
                query: .init(
                    page: .init(size: 10_000, number: 1),
                    sort: [.init(field: .createdAt, direction: .desc)]
                )
            )
            var result: [PublicBlogPostSummary] = []
            for item in posts.items {
                guard
                    let metadata = try await context.metadata.find(
                        referenceType: "blog.post",
                        referenceID: item.id
                    ),
                    metadata.isPublic(at: now)
                else {
                    continue
                }
                result.append(
                    .init(
                        id: item.id,
                        title: item.title,
                        excerpt: item.excerpt,
                        imageAssetId: item.imageAssetId,
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
