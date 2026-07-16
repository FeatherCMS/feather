import AppOpenAPI
import UserApplication

extension AppAPI {

    func authInvitationRegistration(
        _ input: Operations.AuthInvitationRegistration.Input
    ) async throws -> Operations.AuthInvitationRegistration.Output {
        let body: Components.Schemas.AuthInvitationRegistrationRequestSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let account = try await modules.user
            .makeCompleteInvitationRegistration()
            .execute(
                input: .init(
                    token: body.token,
                    password: body.password
                )
            )

        return .ok(
            .init(
                body: .json(
                    .init(
                        user: .init(
                            id: account.id,
                            email: account.email
                        ),
                        roles: account.roleIds,
                        permissions: [],
                        token: ""
                    )
                )
            )
        )
    }
}
