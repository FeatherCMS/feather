import AuthContracts
import AuthDomain
import FeatherApplication
import FeatherContracts

//
//  EditMagicLink.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

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
        public let authEmailId: String?
        public let isPersistent: Bool?

        public init(
            id: String,
            authEmailId: String?,
            isPersistent: Bool?
        ) {
            self.id = id
            self.authEmailId = authEmailId
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

        let model = try await transaction.run { scope in
            guard
                let existing = try await scope.magicLink.findById(
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
                authEmailId: input.authEmailId
                    ?? existing.authEmailId,
                token: existing.token,
                expiresAt: existing.expiresAt,
                isPersistent: input.isPersistent ?? existing.isPersistent,
                isUsed: existing.isUsed,
                createdAt: existing.createdAt,
                updatedAt: existing.updatedAt
            )

            return try await scope.magicLink.update(updated)
        }

        return model.asDetail
    }
}
