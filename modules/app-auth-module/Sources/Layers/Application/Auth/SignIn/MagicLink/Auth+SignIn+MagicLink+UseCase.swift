import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherModuleKit
import UserDomain

extension AuthModule.Auth.SignIn.MagicLink {
    public struct UseCase: FeatherApplication.UseCase {
        let transaction: any TransactionExecutor<Scope>

        public init(transaction: any TransactionExecutor<Scope>) {
            self.transaction = transaction
        }

        public func execute(_ input: Input) async throws
            -> AuthModule.Auth.SignIn.Output
        {
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
                        throw UseCaseError.authentication()
                    }
                    return try await AuthModule.Auth.SignIn.makeAuthResponse(
                        authorization: scope.authorization,
                        userSessionRepository: scope.session,
                        user: user,
                        authenticationType: Session.Model.AuthenticationTypes
                            .magicLink,
                        authenticationReference: usedLink.id,
                        isPersistent: usedLink.isPersistent
                    )
                }
                catch {
                    throw UseCaseError.authentication()
                }
            }
        }
    }
}
