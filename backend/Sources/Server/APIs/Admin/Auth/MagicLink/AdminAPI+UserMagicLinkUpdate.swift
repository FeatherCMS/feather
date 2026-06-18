import AdminOpenAPI
import AuthApplication
import Application

extension AdminAPI {

    func userMagicLinkUpdate(
        _ input: Operations.UserMagicLinkUpdate.Input
    ) async throws -> Operations.UserMagicLinkUpdate.Output {
        let body: Components.Schemas.UserMagicLinkCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.auth.makeEditMagicLink()
        let result = try await useCase.execute(
            subject: subject,
            input: AuthApplication.EditMagicLink.Input(
                id: input.path.userMagicLinkId,
                email: body.email,
                isPersistent: body.isPersistent
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
