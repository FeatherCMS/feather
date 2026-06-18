import Application
import Domain
import UserDomain
import struct Foundation.Date

public struct AddAccount: UseCase {
    struct Action: PermissionAction {
        let key = UserPermissions.Accounts.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteAccount>
    let idGenerator: any IDGenerator
    let passwordHasher: any PasswordHasher

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteAccount>,
        idGenerator: any IDGenerator,
        passwordHasher: any PasswordHasher
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.idGenerator = idGenerator
        self.passwordHasher = passwordHasher
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

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let id = idGenerator.generate()
        let hash = try await hashPassword(
            using: passwordHasher,
            original: input.password
        )

        let model = try await transaction.run { context in
            try await context.account.insert(
                Account.create(
                    id: id,
                    email: input.email,
                    password: input.password,
                    passwordHash: hash
                )
            )
        }
        return model.asDetail
    }
}
