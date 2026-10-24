import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherDomain
public import FeatherModuleKit

extension Credential.Edit {
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
        ) async throws -> Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let passwordHash: FieldChange<String>
            if case .set(let password) = input.password {
                passwordHash = .set(try await passwordHasher.hash(password))
            }
            else {
                passwordHash = .unchanged
            }

            return try await transaction.run { scope in
                guard
                    var model = try await scope.credential.findBy(
                        id: input.id
                    )
                else {
                    throw Credential.Edit.Error.credentialNotFound(id: input.id)
                }

                let currentAuthEmail = try await scope.authEmail.findBy(
                    id: model.authEmailId
                )
                guard let currentAuthEmail else {
                    throw Credential.Edit.Error.authEmailNotFoundForCredential(id: input.id)
                }
                let userId = input.userId.apply(to: currentAuthEmail.identityId)
                let email = input.email.apply(to: currentAuthEmail.email)
                guard
                    let authEmail = try await scope.authEmail.findBy(
                        email: email
                    ), authEmail.identityId == userId
                else {
                    throw Credential.Edit.Error.authEmailNotFoundForIdentity(identityId: userId)
                }

                let authEmailId: FieldChange<String>
                if case .unchanged = input.userId,
                    case .unchanged = input.email
                {
                    authEmailId = .unchanged
                }
                else {
                    authEmailId = .set(authEmail.id)
                }

                try model.update(
                    authEmailId: authEmailId,
                    passwordHash: passwordHash
                )

                let updated = try await scope.credential.update(model)
                return Output(
                    id: updated.id,
                    userId: authEmail.identityId,
                    email: authEmail.email,
                    createdAt: updated.createdAt,
                    updatedAt: updated.updatedAt
                )
            }
        }

    }
}
