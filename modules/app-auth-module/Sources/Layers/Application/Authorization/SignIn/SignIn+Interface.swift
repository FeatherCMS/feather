import AuthDomain
import AuthModule
import FeatherApplication
import FeatherModuleKit
import UserDomain
import UserModule

extension AuthModule.Authorization.SignIn {
    static func makeAuthResponse(
        authorization: any AuthModule.Authorization.Query.Interface,
        userSessionRepository: any Session.Repository.Interface,
        user: Identity.Model,
        authenticationType: String,
        authenticationReference: String,
        isPersistent: Bool
    ) async throws -> AuthModule.Authorization.SignIn.Output {
        let (roles, permissions) = try await (
            authorization.getRolesBy(identityId: user.id),
            authorization.getPermissionsBy(identityId: user.id)
        )
        let sessionLifetime =
            isPersistent
            ? Session.Model.Lifetimes.persistent
            : Session.Model.Lifetimes.regular
        let session = try await userSessionRepository.insert(
            Session.Model.create(
                token: AuthModule.Authorization.TokenAuth.generateToken(),
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
