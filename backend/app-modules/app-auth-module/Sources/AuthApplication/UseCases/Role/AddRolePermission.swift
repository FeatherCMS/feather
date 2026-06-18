import Application
import AuthDomain

public struct AddRolePermission: UseCase {
    struct Action: PermissionAction {
        let key = AuthPermissions.AccessControl.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteRolePermissions>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteRolePermissions>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public func execute(
        subject: Subject,
        input: RolePermissionCreate
    ) async throws -> RolePermissionDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { context in
            try await context.rolePermissions.insert(
                RolePermission.create(
                    roleId: input.roleId,
                    permissionId: input.permissionId
                )
            )
        }

        return model.asDetail
    }
}
