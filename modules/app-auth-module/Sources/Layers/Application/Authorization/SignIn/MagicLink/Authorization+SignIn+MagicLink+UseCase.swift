import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherModuleKit
import UserDomain

extension AuthModule.Authorization.SignIn.MagicLink {
    public struct UseCase: FeatherApplication.UseCase {
        let transaction: any TransactionExecutor<Scope>

        public init(transaction: any TransactionExecutor<Scope>) {
            self.transaction = transaction
        }

        public func execute(_ input: Input) async throws -> Output {
            try await transaction.run { scope in
                do {
                    let usedLink = try await scope.magicLink.consumeByToken(
                        token: input.token
                    )
                    guard
                        let authEmail = try await scope.authEmail.findBy(
                            id: usedLink.authEmailId
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
                    async let permissionsTask = scope.permissions
                        .getPermissionsBy(identityId: user.id)
                    let roles = try await rolesTask
                    let permissions = try await permissionsTask
                    let sessionLifetime =
                        usedLink.isPersistent
                        ? Session.Model.Lifetimes.persistent
                        : Session.Model.Lifetimes.regular
                    let session = try await scope.session.insert(
                        Session.Model.create(
                            token: AuthModule.Authorization.Token
                                .generateToken(),
                            identityId: user.id,
                            authenticationType: Session.Model
                                .AuthenticationTypes.magicLink,
                            authenticationReference: usedLink.id,
                            expiresAtInterval: sessionLifetime,
                            isPersistent: usedLink.isPersistent
                        )
                    )
                    return Output(
                        user: user,
                        session: session,
                        roles: roles,
                        permissions: permissions
                    )
                }
                catch {
                    throw Error.authenticationFailed
                }
            }
        }
    }
}
