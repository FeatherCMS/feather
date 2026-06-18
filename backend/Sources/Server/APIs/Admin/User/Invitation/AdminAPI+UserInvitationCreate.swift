import AdminOpenAPI
import UserApplication
import Application

extension AdminAPI {

    func userInvitationCreate(
        _ input: Operations.UserInvitationCreate.Input
    ) async throws -> Operations.UserInvitationCreate.Output {
        let body: Components.Schemas.UserInvitationCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = modules.user.makeAddInvitation()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(email: body.email)
        )

        return .created(
            .init(
                body: .json(map(result))
            )
        )
    }
}
