import Application
import AuthDomain

public struct ListAccountSessions: UseCase {
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
        public let accountId: String

        public init(accountId: String) {
            self.accountId = accountId
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

        return try await query.run { context in
            try await context.session.list(
                query: .init(accountId: input.accountId)
            )
        }
    }
}
