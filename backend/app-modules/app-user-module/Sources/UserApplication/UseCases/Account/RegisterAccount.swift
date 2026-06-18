import Application
import Domain
import UserDomain

public struct RegisterAccount: UseCase {
    let transaction: any TransactionExecutor<WriteAccount>
    let idGenerator: any IDGenerator
    let passwordHasher: any PasswordHasher

    public init(
        transaction: any TransactionExecutor<WriteAccount>,
        idGenerator: any IDGenerator,
        passwordHasher: any PasswordHasher
    ) {
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
        input: Input
    ) async throws -> AccountDetail {
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
