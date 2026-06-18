import Application
import Domain
import Foundation
import WebApplication

public struct ResolveWebRoute {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }

    let query: any QueryExecutor<ReadMetadata>

    public init(
        query: any QueryExecutor<ReadMetadata>
    ) {
        self.query = query
    }

    public func execute(
        slug: String
    ) async throws -> WebRouteDetail {
        let now = Date()
        return try await query.run { context in
            guard let metadata = try await context.metadata.resolve(slug: slug),
                metadata.isDirectlyAccessible(at: now),
                let referenceType = metadata.referenceType,
                let referenceID = metadata.referenceID
            else {
                throw Error(message: "Route not found")
            }

            return .init(
                referenceType: referenceType,
                referenceID: referenceID,
                slug: metadata.slug
            )
        }
    }
}
