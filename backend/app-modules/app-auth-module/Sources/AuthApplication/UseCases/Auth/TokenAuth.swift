import Application
import AuthDomain
import Domain
import UserDomain

// TODO: no need for clock, no need to return permissions & roles only accountId
public struct TokenAuth: Sendable {
    let transaction: any TransactionExecutor<WriteAuth>
    let clock: any Clock

    public init(
        transaction: any TransactionExecutor<WriteAuth>,
        clock: any Clock
    ) {
        self.transaction = transaction
        self.clock = clock
    }

    public struct Input: DTO {
        public let token: String

        public init(token: String) {
            self.token = token
        }
    }

    public typealias Output = AuthResolvedSession?

    public func execute(
        _ input: Input
    ) async throws -> Output {
        let now = clock.now()

        let resolved: AuthResolvedSession? = try await transaction.run {
            context in
            guard
                let session = try await context.session.findBy(
                    token: input.token
                )
            else {
                return nil
            }
            guard session.expiresAt > now else {
                return nil
            }
            guard
                let account = try await context.account
                    .findAccountBy(
                        sessionToken: input.token
                    )
            else {
                return nil
            }

            let (roles, permissions) = try await (
                context.account.findRolesBy(
                    accountId: account.id
                ),
                context.account.findPermissionsBy(
                    accountId: account.id
                )
            )

            return AuthResolvedSession(
                accountId: account.id,
                roles: roles,
                permissions: permissions,
                isPersistent: session.isPersistent
            )
        }

        if resolved != nil {
            return resolved
        }

        try await transaction.run { context in
            if let session = try await context.session.findBy(
                token: input.token
            ),
                session.expiresAt <= now
            {
                _ = try await context.session.delete(id: session.id)
            }
        }

        return nil
    }
}
