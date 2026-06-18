import Application
import Domain
import SystemDomain

public struct RemoveVariable: UseCase {
    struct Action: PermissionAction {
        let key = SystemPermissions.Variables.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteVariable>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteVariable>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String

        public init(
            id: String
        ) {
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

        let id = input.id

        return try await transaction.run { context in
            try await context.variable.delete(id: id)
        }
    }
}
