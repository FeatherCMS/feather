import Application
import UserDomain

public struct GetRole: UseCase {
    struct Action: PermissionAction {
        let key = UserPermissions.Roles.read
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadRole>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadRole>
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
    ) async throws -> RoleDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { context in
            try await context.role.getBy(id: input.id)
        }
    }
}
