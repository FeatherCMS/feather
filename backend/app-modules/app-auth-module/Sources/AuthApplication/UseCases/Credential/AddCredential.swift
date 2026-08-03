import Application
import AuthDomain

public struct AddCredential: UseCase {
    struct Action: PermissionAction {
        let key = AuthPermissions.Credential.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteCredentialLink>
    let idGenerator: any IDGenerator
    let passwordHasher: any PasswordHasher

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteCredentialLink>,
        idGenerator: any IDGenerator,
        passwordHasher: any PasswordHasher
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.idGenerator = idGenerator
        self.passwordHasher = passwordHasher
    }

    public struct Input: DTO {
        public let accountID: String
        public let email: String
        public let password: String

        public init(
            accountID: String,
            email: String,
            password: String
        ) {
            self.accountID = accountID
            self.email = email
            self.password = password
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> CredentialDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let passwordHash = try await passwordHasher.hash(input.password)
        let model = try await transaction.run { context in
            try await context.credential.insert(
                Credential.create(
                    id: idGenerator.generate(),
                    accountID: input.accountID,
                    email: input.email,
                    passwordHash: passwordHash
                )
            )
        }

        return model.asDetail
    }
}
