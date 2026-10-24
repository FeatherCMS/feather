import AuthDomain
public import AuthModule
public import AuthModule
import FeatherApplication
import FeatherModuleKit
import UserDomain
import UserModule

extension AuthModule.Authorization {
    public enum SignIn {}
}

extension AuthModule.Authorization.SignIn {
    static func makeAuthResponse(
        rolesQuery: any Authorization.Roles.Query.Interface,
        permissionsQuery: any Authorization.Permissions.Query.Interface,
        userSessionRepository: any Session.Repository.Interface,
        user: Identity.Model,
        authenticationType: String,
        authenticationReference: String,
        isPersistent: Bool
    ) async throws -> AuthModule.Authorization.SignIn.Output {
        async let rolesTask = rolesQuery.getRolesBy(identityId: user.id)
        async let permissionsTask = permissionsQuery.getPermissionsBy(
            identityId: user.id
        )
        let roles = try await rolesTask
        let permissions = try await permissionsTask
        let sessionLifetime =
            isPersistent
            ? Session.Model.Lifetimes.persistent
            : Session.Model.Lifetimes.regular
        let session = try await userSessionRepository.insert(
            Session.Model.create(
                token: AuthModule.Authorization.Token.generateToken(),
                identityId: user.id,
                authenticationType: authenticationType,
                authenticationReference: authenticationReference,
                expiresAtInterval: sessionLifetime,
                isPersistent: isPersistent
            )
        )
        return .init(
            user: user,
            session: session,
            roles: roles,
            permissions: permissions
        )
    }
}
