import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherDomain
public import FeatherModuleKit
import UserDomain

extension AuthModule.Authorization.SignIn.Credentials {
    public struct UseCase: FeatherApplication.UseCase {
        let transaction: any TransactionExecutor<Scope>
        let passwordHasher: any PasswordHasher

        public init(
            transaction: any TransactionExecutor<Scope>,
            passwordHasher: any PasswordHasher
        ) {
            self.transaction = transaction
            self.passwordHasher = passwordHasher
        }

        public func execute(_ input: Input) async throws -> Output {
            try await transaction.run { scope in
                guard
                    let credential = try await scope.credential.findBy(
                        email: input.email
                    ),
                    let authEmail = try await scope.authEmail.findBy(
                        id: credential.authEmailId
                    ),
                    try await passwordHasher.verify(
                        input.password,
                        hash: credential.passwordHash
                    ),
                    let user = try await scope.identity.findBy(
                        id: authEmail.identityId
                    ),
                    user.status == .active
                else {
                    throw Error.authenticationFailed
                }
                async let rolesTask = scope.roles.getRolesBy(
                    identityId: user.id
                )
                async let permissionsTask = scope.permissions.getPermissionsBy(
                    identityId: user.id
                )
                let roles = try await rolesTask
                let permissions = try await permissionsTask
                let sessionLifetime =
                    input.isPersistent
                    ? Session.Model.Lifetimes.persistent
                    : Session.Model.Lifetimes.regular
                let session = try await scope.session.insert(
                    Session.Model.create(
                        token: AuthModule.Authorization.Token.generateToken(),
                        identityId: user.id,
                        authenticationType: Session.Model.AuthenticationTypes
                            .credential,
                        authenticationReference: credential.id,
                        expiresAtInterval: sessionLifetime,
                        isPersistent: input.isPersistent
                    )
                )
                return Output(
                    user: user,
                    session: session,
                    roles: roles,
                    permissions: permissions
                )
            }
        }
    }
}
