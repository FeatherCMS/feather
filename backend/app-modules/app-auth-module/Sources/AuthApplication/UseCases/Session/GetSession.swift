import Application
import AuthDomain

public struct GetSession: UseCase {
    struct Action: PermissionAction {
        let key = AuthPermissions.Sessions.read
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
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> SessionDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { context in
            try await context.session.find(id: input.id)
        }
    }
}
