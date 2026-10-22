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

        public func execute(_ input: Input) async throws
            -> AuthModule.Authorization.SignIn.Output
        {
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
                    throw UseCaseError.authentication()
                }
                return try await AuthModule.Authorization.SignIn.makeAuthResponse(
                    authorization: scope.authorization,
                    userSessionRepository: scope.session,
                    user: user,
                    authenticationType: Session.Model.AuthenticationTypes
                        .credential,
                    authenticationReference: credential.id,
                    isPersistent: input.isPersistent
                )
            }
        }
    }
}
