import Application
import UserDomain

public struct ListRoles: UseCase {
    struct Action: PermissionAction {
        let key = UserPermissions.Roles.list
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
        public let query: RoleList.Query

        public init(
            query: RoleList.Query
        ) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> RoleList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { context in
            try await context.role.list(query: inputQuery)
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
            try await context.role.count(query: input.query)
        }
    }
}
