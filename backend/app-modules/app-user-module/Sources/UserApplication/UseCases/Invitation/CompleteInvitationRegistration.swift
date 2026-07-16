import Application
import Domain
import UserDomain

public struct CompleteInvitationRegistration: UseCase {
    let transaction: any TransactionExecutor<WriteInvitation>
    let passwordHasher: any PasswordHasher

    public init(
        transaction: any TransactionExecutor<WriteInvitation>,
        passwordHasher: any PasswordHasher
    ) {
        self.transaction = transaction
        self.passwordHasher = passwordHasher
    }

    public struct Input: DTO {
        public let token: String
        public let password: String

        public init(token: String, password: String) {
            self.token = token
            self.password = password
        }
    }

    public func execute(
        input: Input
    ) async throws -> AccountDetail {
        let hash = try await hashPassword(using: passwordHasher, original: input.password)
        return try await transaction.run { context in
            guard var invitation = try await context.invitation.findBy(token: input.token),
                  let accountRepository = context.account,
                  var account = try await accountRepository.findBy(id: invitation.accountID)
            else {
                throw RepositoryError.notFound
            }
            try invitation.consume()
            try account.update(password: input.password, passwordHash: hash, status: .active)
            let updated = try await accountRepository.update(account)
            guard try await context.invitation.delete(id: invitation.id) else {
                throw RepositoryError.notFound
            }
            return updated.asDetail
        }
    }
}
