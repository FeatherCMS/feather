import Application
import UserDomain

public struct GetAccount: UseCase {
    struct Action: PermissionAction {
        let key = UserPermissions.Accounts.read
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
    ) async throws -> AccountDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { context in
            var account = try await context.account.getBy(id: input.id)
            let roleIds = try await context.account.getRoleIdsBy(
                accountId: account.id
            )
            account = .init(
                id: account.id,
                email: account.email,
                roleIds: roleIds,
                status: account.status,
                createdAt: account.createdAt,
                updatedAt: account.updatedAt
            )
            return account
        }
    }
}
