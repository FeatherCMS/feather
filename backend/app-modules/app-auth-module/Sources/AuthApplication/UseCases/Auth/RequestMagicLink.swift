import Application
import AuthDomain
import Domain
import UserDomain
import struct Foundation.Date

public struct RequestMagicLink: UseCase {
    let transaction: any TransactionExecutor<WriteAuth>
    let idGenerator: any IDGenerator
    let mailSender: any MailSender

    public init(
        transaction: any TransactionExecutor<WriteAuth>,
        clock: any Clock,
        idGenerator: any IDGenerator,
        mailSender: any MailSender
    ) {
        self.transaction = transaction
        self.idGenerator = idGenerator
        self.mailSender = mailSender
    }

    public struct Input: DTO {
        public let email: String
        public let isPersistent: Bool

        public init(
            email: String,
            isPersistent: Bool
        ) {
            self.email = email
            self.isPersistent = isPersistent
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> Bool {
        let token: String? = try await transaction.run { context in
            guard try await context.account.findBy(email: input.email) != nil
            else {
                return nil
            }

            let token = generateToken()

            _ = try await context.magicLink.insert(
                MagicLink.create(
                    id: idGenerator.generate(),
                    email: input.email,
                    token: token,
                    isPersistent: input.isPersistent
                )
            )

            return token
        }

        guard let token else {
            return false
        }

        try await mailSender.send(
            .init(
                from: .init("info@binarybirds.com", name: "Binary Birds"),
                to: [.init(input.email)],
                subject: "Application - Sign In Link",
                body: #"""
                    Hello,

                    This is your sign-in token:

                    \#(token)

                    Use this token in the app on the magic link verification screen.

                    Cheers,
                    Application Team.
                    """#
            )
        )
        return true
    }
}
