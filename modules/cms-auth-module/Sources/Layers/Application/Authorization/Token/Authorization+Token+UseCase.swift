import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherModuleKit
import Foundation
import UserDomain

extension AuthModule.Authorization.Token {
    public struct UseCase: FeatherApplication.UseCase {
        let transaction: any TransactionExecutor<Scope>

        public init(transaction: any TransactionExecutor<Scope>) {
            self.transaction = transaction
        }

        public func execute(_ input: Input) async throws -> Output? {
            let now = Date()
            let resolved: Output? = try await transaction.run { scope in
                guard
                    let session = try await scope.session.findBy(
                        token: input.token
                    ),
                    session.expiresAt > now.timeIntervalSince1970,
                    let identity = try await scope.identity.findBy(
                        id: session.identityId
                    )
                else {
                    return nil
                }
                async let rolesTask = scope.roles.getRolesBy(
                    identityId: identity.id
                )
                async let permissionsTask = scope.permissions
                    .getPermissionsBy(identityId: identity.id)
                let roles = try await rolesTask
                let permissions = try await permissionsTask
                return Output(
                    identityId: identity.id,
                    roles: roles,
                    permissions: permissions,
                    isPersistent: session.isPersistent
                )
            }
            if let resolved { return resolved }

            try await transaction.run { scope in
                if let session = try await scope.session.findBy(
                    token: input.token
                ),
                    session.expiresAt <= now.timeIntervalSince1970
                {
                    _ = try await scope.session.delete(ids: [session.id])
                }
            }
            return nil
        }
    }
}
