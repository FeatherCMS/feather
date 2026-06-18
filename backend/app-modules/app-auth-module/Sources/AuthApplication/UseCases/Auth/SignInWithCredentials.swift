import Application
import AuthDomain
import Domain
import UserDomain

public struct SignInWithCredentials: SignIn {
    let transaction: any TransactionExecutor<WriteAuth>
    let clock: any Clock
    let idGenerator: any IDGenerator
    let passwordHasher: any PasswordHasher

    public init(
        transaction: any TransactionExecutor<WriteAuth>,
        clock: any Clock,
        idGenerator: any IDGenerator,
        passwordHasher: any PasswordHasher
    ) {
        self.transaction = transaction
        self.clock = clock
        self.idGenerator = idGenerator
        self.passwordHasher = passwordHasher
    }

    public struct Input: DTO {
        public let object: AuthCredentials

        public init(object: AuthCredentials) {
            self.object = object
        }
    }

    public typealias Output = AuthDetail

    public func execute(
        _ input: Input
    ) async throws -> Output {
        try await transaction.run { context in
            guard
                let user = try await context.account.findBy(
                    email: input.object.email
                ),
                let hash = try await context.account.findPasswordHashBy(
                    email: input.object.email
                ),
                try await checkPasswordHash(
                    using: passwordHasher,
                    original: input.object.password,
                    hash: hash
                )
            else {
                throw UseCaseError.authentication()
            }

            return try await makeAuthResponse(
                clock: clock,
                idGenerator: idGenerator,
                userAccountRepository: context.account,
                userSessionRepository: context.session,
                user: user,
                isPersistent: input.object.isPersistent
            )
        }
    }
}
