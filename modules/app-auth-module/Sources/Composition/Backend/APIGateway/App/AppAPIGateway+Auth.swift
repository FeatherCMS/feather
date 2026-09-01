import AuthAppAPI
import AuthApplication
import AuthDomain
import FeatherApplication
import FeatherContracts
import UserApplication
import UserBackend
import UserDomain

extension AppAPIGateway {

    public func authMe(
        _ input: Operations.AuthMe.Input
    ) async throws -> Operations.AuthMe.Output {
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeGetCurrentUser()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: subject.id)
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
                        token: ""
                    )
                )
            )
        )
    }

    public func authLogin(
        _ input: Operations.AuthLogin.Input
    ) async throws -> Operations.AuthLogin.Output {
        let body: Components.Schemas.AuthLoginRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeSignInWithCredentials()

        let result = try await useCase.execute(
            .init(
                object: .init(
                    email: body.email,
                    password: body.password,
                    isPersistent: body.isPersistent
                )
            )
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

    public func authLogout(
        _ input: Operations.AuthLogout.Input
    ) async throws -> Operations.AuthLogout.Output {
        guard (try? await CurrentSubject.require()) != nil else {
            return .unauthorized
        }
        return .noContent
    }

    public func authMagicLink(
        _ input: Operations.AuthMagicLink.Input
    ) async throws -> Operations.AuthMagicLink.Output {
        let body: Components.Schemas.AuthMagicLinkRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeRequestMagicLink()
        _ = try await useCase.execute(
            .init(
                email: body.email,
                isPersistent: body.isPersistent
            )
        )

        return .noContent
    }

    public func authMagicLinkVerify(
        _ input: Operations.AuthMagicLinkVerify.Input
    ) async throws -> Operations.AuthMagicLinkVerify.Output {
        let body: Components.Schemas.AuthMagicLinkVerifyRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeSignInWithMagicLink()
        do {
            let result = try await useCase.execute(
                .init(token: body.token)
            )

            return .ok(
                .init(
                    body: .json(
                        .init(
                            user: .init(
                                id: result.user.id,
                                status: .init(
                                    rawValue: result.user.status.rawValue
                                )
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
        catch is AuthApplication.UseCaseError {
            return .unauthorized
        }
    }
}
