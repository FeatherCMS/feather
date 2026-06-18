import Domain
import Application
import BlogDomain

public struct ListAuthors: UseCase {
    struct Action: PermissionAction {
        let key = BlogPermissions.Authors.list
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
        public let query: AuthorList.Query

        public init(
            query: AuthorList.Query
        ) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> AuthorList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { context in
            try await context.author.list(
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
            try await context.author.count(
                query: inputQuery
            )
        }
    }
}
