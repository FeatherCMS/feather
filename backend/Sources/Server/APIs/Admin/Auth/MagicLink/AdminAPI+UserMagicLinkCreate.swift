import AdminOpenAPI
import Application
import AuthApplication

extension AdminAPI {

    func userMagicLinkCreate(
        _ input: Operations.UserMagicLinkCreate.Input
    ) async throws -> Operations.UserMagicLinkCreate.Output {
        let body: Components.Schemas.UserMagicLinkCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.auth.makeAddMagicLink()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                email: body.email,
                isPersistent: body.isPersistent
            )
        )

        return .created(
            .init(
                body: .json(map(result))
            )
        )
    }
}
