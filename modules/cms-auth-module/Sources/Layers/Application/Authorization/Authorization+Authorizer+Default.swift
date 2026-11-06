public import AuthModule
public import FeatherModuleKit
import UserApplication

extension AuthModule.Authorization {
    public enum Authorizer {}
}

extension AuthModule.Authorization.Authorizer {
    public struct Default: FeatherModuleKit.Authorizer {
        let query: any QueryExecutor<AuthModule.Authorization.Scope>

        public init(
            query: any QueryExecutor<AuthModule.Authorization.Scope>
        ) {
            self.query = query
        }

        public func can(
            subject: Subject,
            perform action: any Action
        ) async throws -> Bool {
            try await query.run { scope in
                let permissions = try await scope.permissions.getPermissionsBy(
                    identityId: subject.id
                )

                return try await action.authorize(
                    subject: subject,
                    permissions: Set(permissions.map { .init($0) })
                )
            }
        }
    }
}
