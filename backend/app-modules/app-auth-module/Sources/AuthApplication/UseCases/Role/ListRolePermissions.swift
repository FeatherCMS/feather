import Application

public struct ListRolePermissions: UseCase {
    struct Action: PermissionAction {
        let key = AuthPermissions.AccessControl.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<AuthScope>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<AuthScope>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let query: RolePermissionList.Query

        public init(
            query: RolePermissionList.Query
        ) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> RolePermissionList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { context in
            try await context.rolePermissions.list(query: inputQuery)
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
            try await context.rolePermissions.count(query: input.query)
        }
    }
}
