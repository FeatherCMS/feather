public import AuthModule
public import FeatherApplication
public import FeatherModuleKit
public import UserApplication
public import UserModule

extension AuthModule.Authorization.CurrentUser {
    public struct UseCase: FeatherApplication.UseCase {
        let detailQuery: any QueryExecutor<Identity.Detail.Scope>
        let authorizationQuery:
            any QueryExecutor<Scope>

        public init(
            detailQuery: any QueryExecutor<Identity.Detail.Scope>,
            authorizationQuery: any QueryExecutor<
                Scope
            >
        ) {
            self.detailQuery = detailQuery
            self.authorizationQuery = authorizationQuery
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Output {
            guard input.id == subject.id else {
                throw AuthError(
                    kind: .forbidden,
                    message: "Cannot access another identity."
                )
            }

            let identity = try await detailQuery.run { scope in
                try await scope.identity.find(id: input.id)
            }
            async let roles = authorizationQuery.run { scope in
                try await scope.roles.getRolesBy(identityId: identity.id)
            }
            async let permissions = authorizationQuery.run { scope in
                try await scope.permissions.getPermissionsBy(
                    identityId: identity.id
                )
            }
            return try await Output(
                user: identity,
                roles: roles,
                permissions: permissions
            )
        }

    }
}
