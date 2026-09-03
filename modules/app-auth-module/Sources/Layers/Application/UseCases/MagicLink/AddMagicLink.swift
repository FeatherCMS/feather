import AuthContracts
import AuthDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain

//
//  AddMagicLink.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct AddMagicLink: UseCase {
    struct Action: PermissionAction {
        let key = AuthPermissions.MagicLinks.create
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
        public let identityEmailId: String
        public let isPersistent: Bool

        public init(
            identityEmailId: String,
            isPersistent: Bool
        ) {
            self.identityEmailId = identityEmailId
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
            try await scope.magicLink.insert(
                MagicLink.create(
                    identityEmailId: input.identityEmailId,
                    token: generateToken(),
                    isPersistent: input.isPersistent
                )
            )
        }
        return model.asDetail
    }
}
