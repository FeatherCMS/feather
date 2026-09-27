import AuthContracts
import AuthDomain
public import FeatherApplication
public import FeatherContracts
public import FeatherDomain

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

            let currentAuthEmail = try await scope.authEmail.findBy(
                id: model.authEmailId
            )
            let userId = input.userId ?? currentAuthEmail?.identityId
            let email = input.email ?? currentAuthEmail?.email
            guard let userId, let email else {
                throw UseCaseError(
                    reason: .validation,
                    logMessage: "Auth email not found for credential: \(input.id)",
                    userFriendlyMessage: "Auth email not found"
                )
            }
            guard let authEmail = try await scope.authEmail.findBy(
                email: email
            ), authEmail.identityId == userId else {
                throw UseCaseError(
                    reason: .validation,
                    logMessage: "Auth email not found for identity: \(userId)",
                    userFriendlyMessage: "Auth email not found"
                )
            }

            try model.update(
                authEmailId: authEmail.id,
                passwordHash: passwordHash
            )

            let updated = try await scope.credential.update(model)
            return (model: updated, authEmail: authEmail)
        }

        return .init(
            id: model.model.id,
            userId: model.authEmail.identityId,
            email: model.authEmail.email,
            createdAt: model.model.createdAt,
            updatedAt: model.model.updatedAt
        )
    }
}
