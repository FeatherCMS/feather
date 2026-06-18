import Application
import AuthDomain

public struct ExtendSession: UseCase {
    struct Action: PermissionAction {
        let key = AuthPermissions.Sessions.update
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteSession>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteSession>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let token: String
        public let expiresAt: Double

        public init(
            token: String,
            expiresAt: Double
        ) {
            self.token = token
            self.expiresAt = expiresAt
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> Bool {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await transaction.run { context in
            guard
                let session = try await context.session.findBy(
                    token: input.token
                )
            else {
                return false
            }

            _ = try await context.session.update(
                .init(
                    id: session.id,
                    token: session.token,
                    accountId: session.accountId,
                    expiresAt: input.expiresAt,
                    isPersistent: session.isPersistent,
                    createdAt: session.createdAt,
                    updatedAt: session.updatedAt
                )
            )
            return true
        }
    }
}
