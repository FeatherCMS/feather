import Application
import Domain
import SystemDomain

public struct AddPermission: UseCase {
    struct Action: PermissionAction {
        let key = SystemPermissions.Permissions.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WritePermission>
    let idGenerator: any IDGenerator

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WritePermission>,
        idGenerator: any IDGenerator
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.idGenerator = idGenerator
    }

    public struct Input: DTO {
        public let name: String
        public let notes: String

        public init(
            name: String,
            notes: String
        ) {
            self.name = name
            self.notes = notes
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> PermissionDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let name = input.name
        let notes = input.notes

        return
            try await transaction.run { context in
                try await context.permission.insert(
                    Permission.create(
                        id: idGenerator.generate(),
                        name: name,
                        notes: notes
                    )
                )
            }
            .asDetail
    }
}
