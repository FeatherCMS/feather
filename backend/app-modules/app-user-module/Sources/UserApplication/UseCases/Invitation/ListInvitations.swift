import Application
import UserDomain

public struct ListInvitations: UseCase {
    struct Action: PermissionAction {
        let key = UserPermissions.Invitations.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadInvitation>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadInvitation>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let query: InvitationList.Query

        public init(query: InvitationList.Query) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> InvitationList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { context in
            try await context.invitation.list(query: input.query)
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

        return try await query.run { context in
            try await context.invitation.count(
                query: input.query
            )
        }
    }
}
