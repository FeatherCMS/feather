import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherDomain
public import FeatherModuleKit

extension Credential.Add {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>
        let passwordHasher: any PasswordHasher

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>,
            passwordHasher: any PasswordHasher
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
            self.passwordHasher = passwordHasher
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Credential.Detail.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let passwordHash = try await passwordHasher.hash(input.password)
            let model = try await transaction.run { scope in
                guard
                    let authEmail = try await scope.authEmail.findBy(
                        email: input.email
                    ), authEmail.identityId == input.userId
                else {
                    throw UseCaseError(
                        reason: .validation,
                        logMessage:
                            "Auth email not found for identity: \(input.userId)",
                        userFriendlyMessage: "Auth email not found"
                    )
                }
                return try await scope.credential.insert(
                    Credential.Model.create(
                        authEmailId: authEmail.id,
                        passwordHash: passwordHash
                    )
                )
            }

            return .init(
                id: model.id,
                userId: input.userId,
                email: input.email,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        }

    }
}
