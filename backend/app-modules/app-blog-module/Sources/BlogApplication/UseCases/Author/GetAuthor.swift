import Application
import Domain
import WebApplication
import BlogDomain

public struct GetAuthor: UseCase {
    struct Action: PermissionAction {
        let key = BlogPermissions.Authors.read
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadAuthorMetadata>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadAuthorMetadata>
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
    ) async throws -> AuthorDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let id = input.id

        return try await query.run { context in
            let author = try await context.author.find(id: id)
            guard
                let metadata = try await context.metadata.find(
                    referenceType: "blog.author",
                    referenceID: id
                )
            else {
                throw Error(message: "Author metadata not found")
            }
            return .init(
                id: author.id,
                name: author.name,
                excerpt: author.excerpt,
                content: author.content,
                profileImageAssetId: author.profileImageAssetId,
                metadata: metadata,
                createdAt: author.createdAt,
                updatedAt: author.updatedAt
            )
        }
    }
}
