import Application
import Domain
import SystemDomain

public struct RemovePermission: UseCase {
    struct Action: PermissionAction {
        let key = SystemPermissions.Permissions.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WritePermission>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WritePermission>
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

    public typealias Output = Bool

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> Output {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let id = input.id

        return try await transaction.run { context in
            try await context.permission.delete(id: id)
        }
    }
}
