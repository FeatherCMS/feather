import Application
import AuthDomain

public struct EditMagicLink: UseCase {
    struct Action: PermissionAction {
        let key = AuthPermissions.MagicLinks.update
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMagicLink>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMagicLink>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let email: String?
        public let isPersistent: Bool?

        public init(
            id: String,
            email: String?,
            isPersistent: Bool?
        ) {
            self.id = id
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
            guard
                let existing = try await context.magicLink.findById(
                    id: input.id
                )
            else {
                throw UseCaseError(
                    reason: .validation,
                    logMessage: "Magic link not found: \(input.id)",
                    userFriendlyMessage: "Magic link not found"
                )
            }

            let updated = MagicLink(
                id: existing.id,
                email: input.email ?? existing.email,
                token: existing.token,
                expiresAt: existing.expiresAt,
                isPersistent: input.isPersistent ?? existing.isPersistent,
                isUsed: existing.isUsed,
                createdAt: existing.createdAt,
                updatedAt: existing.updatedAt
            )

            return try await context.magicLink.update(updated)
        }

        return model.asDetail
    }
}
