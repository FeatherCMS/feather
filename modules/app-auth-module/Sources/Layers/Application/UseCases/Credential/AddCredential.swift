import AuthContracts
import AuthDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain

public struct AddCredential: UseCase {
    struct Action: PermissionAction {
        let key = AuthPermissions.Credential.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteCredentialLink>
    let passwordHasher: any PasswordHasher

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteCredentialLink>,
        passwordHasher: any PasswordHasher
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.passwordHasher = passwordHasher
    }

    public struct Input: DTO {
        public let userId: String
        public let email: String
        public let password: String

        public init(
            userId: String,
            email: String,
            password: String,
        ) {
            self.userId = userId
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
        let model = try await transaction.run { scope in
            try await scope.credential.insert(
                Credential.create(
                    userId: input.userId,
                    email: input.email,
                    passwordHash: passwordHash
                )
            )
        }

        return model.asDetail
    }
}
