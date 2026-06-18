import Application
import Domain
import BlogDomain

public struct GetAuthorLink: UseCase {
    struct Action: PermissionAction {
        let key = BlogPermissions.AuthorLinks.read
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadAuthorLink>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadAuthorLink>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let id: String
        public let authorId: String

        public init(
            id: String,
            authorId: String
        ) {
            self.id = id
            self.authorId = authorId
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> AuthorLinkDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { context in
            let detail = try await context.authorLink.find(id: input.id)
            guard detail.authorId == input.authorId else {
                throw Error(message: "Menu item not found")
            }
            return detail
        }
    }
}
