import AdminOpenAPI
import UserApplication
import Application

extension AdminAPI {

    func authMe(
        _ input: Operations.AuthMe.Input
    ) async throws -> Operations.AuthMe.Output {
        let subject = try await CurrentSubject.require()
        let useCase = modules.user.makeGetMyAccount()
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
                            email: result.user.email
                        ),
                        roles: result.roles,
                        permissions: result.permissions,
                        token: ""
                    )
                )
            )
        )
    }
}
