import AccountContracts
import AuthDomain
public import FeatherApplication
public import FeatherContracts
public import FeatherDomain
import UserApplication
import UserDomain

public struct CreateAccount: UseCase {
    struct Action: PermissionAction {
        let key = AccountPermissions.Profile.create
    }

    let authorizer: any Authorizer
    let transaction: any ContextualTransactionExecutor<WriteAccount>
    let passwordHasher: any PasswordHasher
    let events: any EventPublisher

    public init(
        authorizer: any Authorizer,
        transaction: any ContextualTransactionExecutor<WriteAccount>,
        passwordHasher: any PasswordHasher,
        events: any EventPublisher
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.passwordHasher = passwordHasher
        self.events = events
    }

    public struct Input: DTO {
        public let email: String
        public let password: String

        public init(
            email: String,
            password: String
        ) {
            self.email = email
            self.password = password
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> AccountDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action)
        else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let passwordHash = try await passwordHasher.hash(input.password)
        return try await transaction.run { scope, context in
            let identity = try await scope.identity.insert(
                Identity.create(
                    name: input.email,
                    status: .active
                )
            )
            let authEmail = try await scope.authEmail.insert(
                identityId: identity.id,
                email: input.email
            )
            _ = try await scope.credential.insert(
                Credential.create(
                    authEmailId: authEmail.id,
                    passwordHash: passwordHash
                )
            )
            try await events.trigger(
                event: UserIdentityDidInsert(identityID: identity.id),
                using: context
            )
            return .init(userId: identity.id, email: input.email)
        }
    }
}
