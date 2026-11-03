import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherModuleKit

extension RolePermission.BulkUpdate {
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
            input: Input
        ) async throws {
            guard !input.additions.isEmpty || !input.removals.isEmpty else {
                return
            }

            if !input.additions.isEmpty {
                let action = RolePermission.Add.Action()
                guard
                    try await authorizer.can(
                        subject: subject,
                        perform: action
                    )
                else {
                    throw AuthError(
                        kind: .forbidden,
                        message: action.key.rawValue
                    )
                }
            }

            if !input.removals.isEmpty {
                let action = RolePermission.Remove.Action()
                guard
                    try await authorizer.can(
                        subject: subject,
                        perform: action
                    )
                else {
                    throw AuthError(
                        kind: .forbidden,
                        message: action.key.rawValue
                    )
                }
            }

            let additions = try input.additions.map {
                try RolePermission.Model.create(
                    roleId: $0.roleId,
                    permissionId: $0.permissionId
                )
            }
            let removals = try input.removals.map {
                try RolePermission.Model.create(
                    roleId: $0.roleId,
                    permissionId: $0.permissionId
                )
            }

            try await transaction.run { scope in
                _ = try await scope.rolePermissions.delete(
                    ids: removals.map { "\($0.roleId):\($0.permissionId)" }
                )
                try await scope.rolePermissions.insert(additions)
            }
        }
    }
}
