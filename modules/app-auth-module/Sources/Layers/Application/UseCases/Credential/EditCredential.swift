import AuthContracts
import AuthDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain

public struct EditCredential: UseCase {
    struct Action: PermissionAction {
        let key = AuthPermissions.Credential.update
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
        public let id: String
        public let userId: String?
        public let email: String?
        public let password: String?

        public init(
            id: String,
            userId: String? = nil,
            email: String?,
            password: String?,
        ) {
            self.id = id
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

        let passwordHash: String?

        if let password = input.password {
            passwordHash = try await passwordHasher.hash(password)
        }
        else {
            passwordHash = nil
        }

        let model = try await transaction.run { scope in
            guard
                var model = try await scope.credential.findBy(
                    id: input.id
                )
            else {
                throw UseCaseError(
                    reason: .validation,
                    logMessage: "Credential not found: \(input.id)",
                    userFriendlyMessage: "Credential not found"
                )
            }

            try model.update(
                userId: input.userId,
                email: input.email,
                passwordHash: passwordHash
            )

            return try await scope.credential.update(model)
        }

        return model.asDetail
    }
}
