import Application
import AuthDomain
import Domain
import UserDomain

public struct SignInWithMagicLink: SignIn {
    let transaction: any TransactionExecutor<WriteAuth>
    let clock: any Clock
    let idGenerator: any IDGenerator

    public init(
        transaction: any TransactionExecutor<WriteAuth>,
        clock: any Clock,
        idGenerator: any IDGenerator
    ) {
        self.transaction = transaction
        self.clock = clock
        self.idGenerator = idGenerator
    }

    public struct Input: DTO {
        public let token: String

        public init(token: String) {
            self.token = token
        }
    }

    public typealias Output = AuthDetail

    public func execute(
        _ input: Input
    ) async throws -> Output {
        try await transaction.run { context in
            let usedLink = try await context.magicLink.consumeByToken(
                token: input.token,
                now: clock.now()
            )

            guard
                let user = try await context.account.findBy(
                    email: usedLink.email
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
                isPersistent: usedLink.isPersistent
            )
        }
    }
}
