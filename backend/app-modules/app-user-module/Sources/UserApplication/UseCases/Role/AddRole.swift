import Application
import Domain
import UserDomain

public struct AddRole: UseCase {
    struct Action: PermissionAction {
        let key = UserPermissions.Roles.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteRole>
    let idGenerator: any IDGenerator

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteRole>,
        idGenerator: any IDGenerator
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.idGenerator = idGenerator
    }

    public func execute(
        subject: Subject,
        input: RoleCreate
    ) async throws -> RoleDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { context in
            try await context.role.insert(
                Role.create(
                    id: idGenerator.generate(),
                    name: input.name,
                    notes: input.notes
                )
            )
        }

        return model.asDetail
    }
}
