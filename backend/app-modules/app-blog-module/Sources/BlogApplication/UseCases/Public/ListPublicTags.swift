import Application
import Foundation
import WebApplication
import BlogDomain

public struct ListPublicTags {
    let query: any QueryExecutor<ReadPublicBlogTag>

    public init(
        query: any QueryExecutor<ReadPublicBlogTag>
    ) {
        self.query = query
    }

    public func execute() async throws -> [PublicBlogTagSummary] {
        let now = Date()
        return try await query.run { context in
            let tags = try await context.tag.list(
                query: .init(
                    page: .init(size: 10_000, number: 1),
                    sort: [.init(field: .createdAt, direction: .desc)]
                )
            )
            var result: [PublicBlogTagSummary] = []
            for item in tags.items {
                guard
                    let metadata = try await context.metadata.find(
                        referenceType: "blog.tag",
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
