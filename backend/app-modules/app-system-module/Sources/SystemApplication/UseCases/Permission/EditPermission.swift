import Application
import Domain
import SystemDomain

public struct EditPermission: UseCase {
    struct Action: PermissionAction {
        let key = SystemPermissions.Permissions.update
    }

    public enum Error: UseCaseError {
        case notFound
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
        public let name: String?
        public let notes: String?

        public init(
            id: String,
            name: String?,
            notes: String?
        ) {
            self.id = id
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

        let id = input.id
        let name = input.name
        let notes = input.notes

        return
            try await transaction.run { context in
                guard
                    var model = try await context.permission.find(id: id)
                else {
                    throw Error.notFound
                }

                try model.update(
                    name: name,
                    notes: notes
                )

                return try await context.permission.update(model)
            }
            .asDetail
    }
}
