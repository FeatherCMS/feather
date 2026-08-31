import AccountAppAPI
import AccountApplication
import UserApplication
import Foundation

extension AppAPIGateway {

    public func accountInvitationExchange(
        _ input: Operations.AccountInvitationExchange.Input
    ) async throws -> Operations.AccountInvitationExchange.Output {
        let body: Components.Schemas.AccountInvitationExchangeRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let identity = try await useCases.makeCompleteInvitationRegistration()
            .execute(
                input: .init(token: body.token, password: body.password)
            )

        return .ok(
            .init(
                body: .json(
                    .init(
                        user: .init(
                            id: identity.id,
                            status: .init(rawValue: identity.status.rawValue)
                                ?? .invited
                        ),
                        roles: identity.roleIds,
                        permissions: [],
                        token: ""
                    )
                )
            )
        )
    }

    public func accountInvitationValidation(
        _ input: Operations.AccountInvitationValidation.Input
    ) async throws -> Operations.AccountInvitationValidation.Output {
        let invitation = try await useCases.makeValidateInvitation().execute(
            input: .init(token: input.query.token)
        )
        return .ok(
            .init(
                body: .json(
                    .init(
                        email: invitation.email,
                        expiresAt: invitation.expiresAt.timeIntervalSince1970
                    )
                )
            )
        )
    }
}
