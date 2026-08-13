import AuthAdminAPI
import AuthApplication
import AuthDomain
import UserDomain

extension AuthBackend {

    public func authMagicLinkVerify(
        _ input: Operations.AuthMagicLinkVerify.Input
    ) async throws -> Operations.AuthMagicLinkVerify.Output {
        let body: Components.Schemas.AuthMagicLinkVerifyRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.makeSignInWithMagicLink()
        let result = try await useCase.execute(
            .init(token: body.token)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        user: .init(
                            id: result.user.id,
                            status: .init(rawValue: result.user.status.rawValue)
                                ?? .active
                        ),
                        roles: result.roles,
                        permissions: result.permissions,
                        token: result.session.token
                    )
                )
            )
        )
    }
}
