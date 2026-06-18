import Application
import AuthDomain

public struct ListSessions: UseCase {
    struct Action: PermissionAction {
        let key = AuthPermissions.Sessions.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadSession>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadSession>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let query: SessionList.Query

        public init(
            query: SessionList.Query
        ) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> SessionList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { context in
            try await context.session.list(query: inputQuery)
        }
    }
}
