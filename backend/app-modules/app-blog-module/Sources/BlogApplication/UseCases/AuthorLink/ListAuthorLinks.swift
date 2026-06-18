import Domain
import Application
import BlogDomain

public struct ListAuthorLinks: UseCase {
    struct Action: PermissionAction {
        let key = BlogPermissions.AuthorLinks.list
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
        public let authorId: String
        public let query: AuthorLinkList.Query

        public init(
            authorId: String,
            query: AuthorLinkList.Query
        ) {
            self.authorId = authorId
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> AuthorLinkList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { context in
            try await context.authorLink.list(
                authorId: input.authorId,
                query: inputQuery
            )
        }
    }

    public func count(
        subject: Subject,
        input: Input
    ) async throws -> Int {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { context in
            try await context.authorLink.count(
                authorId: input.authorId,
                query: inputQuery
            )
        }
    }
}
