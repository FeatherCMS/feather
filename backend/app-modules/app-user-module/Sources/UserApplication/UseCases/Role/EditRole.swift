import Application
import UserDomain

public struct EditRole: UseCase {
    struct Action: PermissionAction {
        let key = UserPermissions.Roles.update
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteRole>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteRole>
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
    ) async throws -> RoleDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { context in
            guard var model = try await context.role.findBy(id: input.id) else {
                throw Error(message: "Role not found")
            }

            try model.update(
                name: input.name,
                notes: input.notes
            )

            return try await context.role.update(model)
        }

        return model.asDetail
    }
}
