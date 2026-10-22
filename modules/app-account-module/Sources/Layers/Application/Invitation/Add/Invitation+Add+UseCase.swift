import AccountDomain
public import AccountModule
import AuthDomain
public import FeatherApplication
import FeatherMail
public import FeatherModuleKit
import SystemApplication
import UserApplication
import UserDomain
import UserModule

//
//  Invitation+Add+UseCase.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Invitation.Add {
    public struct UseCase: FeatherApplication.UseCase {
        private struct MailContext: Sendable {
            let invitation: Invitation.Model
            let publicBaseURL: String
            let mailFromAddress: String
            let mailFromName: String?
        }

        let authorizer: any Authorizer
        let transaction: any ContextualTransactionExecutor<Invitation.Add.Scope>
        let events: any EventPublisher
        let jobs: any SendMailJobController

        public init(
            authorizer: any Authorizer,
            transaction: any ContextualTransactionExecutor<
                Invitation.Add.Scope
            >,
            events: any EventPublisher,
            jobs: any SendMailJobController
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
            self.events = events
            self.jobs = jobs
        }

        public func execute(
            subject: Subject,
            input: Invitation.Add.Input
        ) async throws -> Invitation.Detail.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let model = try await transaction.run { scope, context in
                guard
                    let mailFromAddress = try await scope.variable.get(
                        "system-settings-mail-from-address"
                    )?
                    .whitespaceTrimmed,
                    !mailFromAddress.isEmpty
                else {
                    throw Error.mailFromNotConfigured
                }
                let mailFromName = try await scope.variable.get(
                    "system-settings-mail-from-name"
                )?
                .whitespaceTrimmed.emptyToNil
                let identityRepository = scope.identity
                let roleRepository = scope.role
                for roleID in input.roleIDs {
                    guard try await roleRepository.findBy(id: roleID) != nil
                    else {
                        throw Error.roleNotFound(roleID)
                    }
                }
                let token = Invitation.Token.generate()
                let identity = try await identityRepository.insert(
                    Identity.Model.create(status: .invited)
                )
                _ = try await scope.authEmail.insert(
                    identityId: identity.id,
                    email: input.email
                )
                try await identityRepository.replaceRoleIds(
                    identityId: identity.id,
                    roleIds: input.roleIDs
                )
                let invitation = try await scope.invitation.insert(
                    Invitation.Model.create(
                        userId: identity.id,
                        email: input.email,
                        token: token,
                        roleIDs: input.roleIDs
                    )
                )
                try await events.trigger(
                    event: Identity.Event.DidInsert(identityID: identity.id),
                    using: context
                )
                let configuredPublicBaseURL =
                    try await scope.variable.get(
                        "web-settings-public-base-url"
                    )?
                    .whitespaceTrimmed
                let publicBaseURL =
                    configuredPublicBaseURL?.isEmpty == false
                    ? configuredPublicBaseURL!
                    : "http://localhost:3456"
                return MailContext(
                    invitation: invitation,
                    publicBaseURL: publicBaseURL,
                    mailFromAddress: mailFromAddress,
                    mailFromName: mailFromName
                )
            }

            try await jobs.enqueue(
                .init(
                    from: .init(
                        model.mailFromAddress,
                        name: model.mailFromName
                    ),
                    to: [.init(model.invitation.email)],
                    subject: "Application - Invitation",
                    body: .plainText(
                        #"""
                        Hello,

                        You have been invited to create your application identity.
                        Open this invitation link to complete registration:

                        \#(model.publicBaseURL)/account/invitation/accept/?token=\#(model.invitation.token)

                        Cheers,
                        Application Team.
                        """#
                    )
                )
            )
            return .init(
                id: model.invitation.id,
                userId: model.invitation.userId,
                email: model.invitation.email,
                token: model.invitation.token,
                roleIDs: model.invitation.roleIDs,
                expiresAt: model.invitation.expiresAt,
                createdAt: model.invitation.createdAt,
                updatedAt: model.invitation.updatedAt
            )
        }
    }
}
