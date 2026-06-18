import Application
import AuthDomain

public struct RemoveSession: UseCase {
    struct Action: PermissionAction {
        let key = AuthPermissions.Sessions.delete
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
        public let id: String

        public init(id: String) {
            self.id = id
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
            try await context.session.delete(id: input.id)
        }
    }
}
