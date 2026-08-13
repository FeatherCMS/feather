import AuthAdminAPI
import AuthApplication
import AuthDomain
import FeatherApplication
import FeatherContracts
import UserApplication
import UserBackend
// @TODO: do not import domain
import UserDomain

extension AuthBackend {

    public func authMe(
        _ input: Operations.AuthMe.Input
    ) async throws -> Operations.AuthMe.Output {
        let subject = try await CurrentSubject.require()
        let useCase = makeGetCurrentUser()
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

    /*
     curl -i -X 'POST' \
        'http://127.0.0.1:8080/api/v1/admin/auth/login' \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d '{"email":"mail.tib@gmail.com","password":"root","isPersistent":true}'
    */
    public func authLogin(
        _ input: Operations.AuthLogin.Input
    ) async throws -> Operations.AuthLogin.Output {

        let body: Components.Schemas.AuthLoginRequestSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.makeSignInWithCredentials()

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
}
