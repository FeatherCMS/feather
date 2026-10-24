import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherModuleKit

extension RolePermission.Add {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: RolePermission.Add.Input
        ) async throws -> RolePermission.Add.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let model = try await transaction.run { scope in
                try await scope.rolePermissions.insert(
                    RolePermission.Model.create(
                        roleId: input.roleId,
                        permissionId: input.permissionId
                    )
                )
            }

            return .init(
                roleId: model.roleId,
                permissionId: model.permissionId,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        }

    }
}
