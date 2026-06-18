import Application
import Domain
import WebApplication
import BlogDomain

public struct GetTag: UseCase {
    struct Action: PermissionAction {
        let key = BlogPermissions.Tags.read
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadTagMetadata>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadTagMetadata>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let id: String

        public init(
            id: String
        ) {
            self.id = id
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> TagDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let id = input.id

        return try await query.run { context in
            let tag = try await context.tag.find(id: id)
            guard
                let metadata = try await context.metadata.find(
                    referenceType: "blog.tag",
                    referenceID: id
                )
            else {
                throw Error(message: "Tag metadata not found")
            }
            return .init(
                id: tag.id,
                title: tag.title,
                excerpt: tag.excerpt,
                content: tag.content,
                imageAssetId: tag.imageAssetId,
                metadata: metadata,
                createdAt: tag.createdAt,
                updatedAt: tag.updatedAt
            )
        }
    }
}
