import Application
import Domain
import AuthDomain
import struct Foundation.Date

public struct AddMagicLink: UseCase {
    struct Action: PermissionAction {
        let key = AuthPermissions.MagicLinks.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMagicLink>
    let idGenerator: any IDGenerator

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMagicLink>,
        idGenerator: any IDGenerator
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.idGenerator = idGenerator
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
        subject: Subject,
        input: Input
    ) async throws -> MagicLinkDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { context in
            try await context.magicLink.insert(
                MagicLink.create(
                    id: idGenerator.generate(),
                    email: input.email,
                    token: generateToken(),
                    isPersistent: input.isPersistent
                )
            )
        }
        return model.asDetail
    }
}
