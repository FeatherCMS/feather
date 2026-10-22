public import AccountModule
import AuthDomain
import AuthModule
public import FeatherApplication
public import FeatherDomain
public import FeatherModuleKit
import UserApplication
import UserDomain
import UserModule

// Creates the initial identity and its credentials.
extension Account.Create {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any ContextualTransactionExecutor<Account.Create.Scope>
        let passwordHasher: any PasswordHasher
        let events: any EventPublisher

        public init(
            authorizer: any Authorizer,
            transaction: any ContextualTransactionExecutor<
                Account.Create.Scope
            >,
            passwordHasher: any PasswordHasher,
            events: any EventPublisher
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
            self.passwordHasher = passwordHasher
            self.events = events
        }

        public func execute(
            subject: Subject,
            input: Account.Create.Input
        ) async throws -> Account.Create.Output {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let passwordHash = try await passwordHasher.hash(input.password)
            return try await transaction.run { scope, context in
                let identity = try await scope.identity.insert(
                    Identity.Model.create(
                        name: input.email,
                        status: .active
                    )
                )
                let authEmail = try await scope.authEmail.insert(
                    identityId: identity.id,
                    email: input.email
                )
                _ = try await scope.credential.insert(
                    Credential.Model.create(
                        authEmailId: authEmail.id,
                        passwordHash: passwordHash
                    )
                )
                try await events.trigger(
                    event: Identity.Event.DidInsert(identityID: identity.id),
                    using: context
                )
                return .init(userId: identity.id, email: input.email)
            }
        }
    }
}
