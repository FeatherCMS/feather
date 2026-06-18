import Application
import UserDomain

public struct GetMyAccount: UseCase {
    struct Action: PermissionAction {
        let key = PermissionKey("auth:profile:read")
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadAccount>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadAccount>
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
    ) async throws -> MyAccountDetail {
        let action = Action()

        guard input.id == subject.id else {
            throw AuthError(
                kind: .forbidden,
                message: "Cannot access another account."
            )
        }

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { context in
            let account = try await context.account.getBy(id: input.id)

            async let roles = context.account.getRolesBy(
                accountId: account.id
            )

            async let permissions = context.account.getPermissionsBy(
                accountId: account.id
            )

            return try await MyAccountDetail(
                user: account,
                roles: roles,
                permissions: permissions
            )
        }
    }
}
