//
//  AddInvitation.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import Domain
import UserDomain

import struct Foundation.Date

public struct AddInvitation: UseCase {
    enum Error: UseCaseError {
        case dependenciesUnavailable
        case roleNotFound(String)

        var message: String {
            switch self {
            case .dependenciesUnavailable:
                "Invitation account dependencies are unavailable"
            case .roleNotFound(let roleID):
                "Role not found: \(roleID)"
            }
        }
    }

    struct Action: PermissionAction {
        let key = UserPermissions.Invitations.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteInvitation>
    let idGenerator: any IDGenerator
    let passwordHasher: (any PasswordHasher)?

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteInvitation>,
        idGenerator: any IDGenerator,
        passwordHasher: (any PasswordHasher)? = nil
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.idGenerator = idGenerator
        self.passwordHasher = passwordHasher
    }

    public struct Input: DTO {
        public let email: String
        public let roleIDs: [String]

        public init(email: String, roleIDs: [String] = []) {
            self.email = email
            self.roleIDs = roleIDs
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> InvitationDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { context in
            guard let accountRepository = context.account,
                let roleRepository = context.role,
                let passwordHasher
            else {
                throw Error.dependenciesUnavailable
            }
            let accountID = idGenerator.generate()
            let token = generateToken()
            let passwordHash = try await hashPassword(
                using: passwordHasher,
                original: token
            )
            let account = try await accountRepository.insert(
                Account.createInvited(
                    id: accountID,
                    email: input.email,
                    passwordHash: passwordHash
                )
            )
            for roleID in input.roleIDs {
                guard try await roleRepository.findBy(id: roleID) != nil else {
                    throw Error.roleNotFound(roleID)
                }
            }
            try await accountRepository.replaceRoleIds(
                accountId: account.id,
                roleIds: input.roleIDs
            )
            return try await context.invitation.insert(
                Invitation.create(
                    id: idGenerator.generate(),
                    accountID: account.id,
                    email: input.email,
                    token: token
                )
            )
        }
        // TODO: Send the invitation email after the transaction commits.
        // The backend currently has no configured runtime MailSender for this use case.
        return model.asDetail
    }
}
