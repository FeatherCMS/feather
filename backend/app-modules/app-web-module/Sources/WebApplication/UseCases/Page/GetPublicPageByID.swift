import Application
import Domain
import Foundation
import WebApplication
import WebDomain

public struct GetPublicPageByID {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }

    let query: any QueryExecutor<ReadPageMetadata>

    public init(
        query: any QueryExecutor<ReadPageMetadata>
    ) {
        self.query = query
    }

    public func execute(
        id: String
    ) async throws -> PublicPageDetail {
        let now = Date()
        return try await query.run { context in
            guard
                let metadata = try await context.metadata.find(
                    referenceType: "web.page",
                    referenceID: id
                ),
                metadata.isDirectlyAccessible(at: now),
                let pageID = metadata.referenceID
            else {
                throw Error(message: "Page not found")
            }

            let page = try await context.page.find(id: pageID)
            return .init(
                id: page.id,
                title: page.title,
                excerpt: page.excerpt,
                content: page.content,
                imageAssetId: page.imageAssetId,
                imageURL: "",
                media: nil,
                metadata: metadata
            )
        }
    }
}
